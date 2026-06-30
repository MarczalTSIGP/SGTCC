import fs from "fs";
import os from "os";
import path from "path";
import { execSync } from "child_process";

const taskName = process.argv[2];
const shouldApply = process.argv.includes("--apply");

const gitArg = process.argv.find((arg) => arg.startsWith("--git="));
const gitMode = gitArg ? gitArg.replace("--git=", "") : "pr";

const aiArg = process.argv.find((arg) => arg.startsWith("--ai="));
const noGemini = process.argv.includes("--no-gemini");

const aiMode = noGemini
  ? "codex"
  : aiArg
    ? aiArg.replace("--ai=", "")
    : "gemini-codex";

const VALID_GIT_MODES = ["none", "commit", "pr"];
const VALID_AI_MODES = ["gemini-codex", "codex", "claude"];

// Caminhos permitidos para o SGTCC, que é um Rails monolítico.
// A IA não deve alterar arquivos sensíveis, gerados ou dependências instaladas.
const ALLOWED_PATHS = [
  "app/",
  "config/",
  "db/",
  "lib/",
  "spec/",
  "test/",
  "bin/",
  "public/",
  "vendor/javascript/",
  "package.json",
  "package-lock.json",
  "yarn.lock",
  "Gemfile",
  "Gemfile.lock",
  "Rakefile",
  "config.ru",
];

const BLOCKED_PATHS = [
  ".env",
  ".env.local",
  ".env.production",
  "config/master.key",
  "config/credentials.yml.enc",
  "node_modules/",
  "vendor/bundle/",
  "tmp/",
  "log/",
  "storage/",
  "coverage/",
  "public/assets/",
  "public/packs/",
  "public/vite/",
  ".git/",
];

// Modelos que o Codex vai tentar, em ordem.
// Se um modelo der "Model not found", ele tenta o próximo.
const CODEX_MODELS = ["gpt-5.5", "gpt-5.4", "gpt-5-codex", "gpt-5"];

if (!taskName) {
  console.log(
    "⚠️ Uso: node ai-runner.js nome-da-task [--apply] [--git=none|commit|pr] [--ai=gemini-codex|codex|claude] [--no-gemini]",
  );
  process.exit(1);
}

if (!VALID_GIT_MODES.includes(gitMode)) {
  console.error(
    "❌ Modo de git inválido. Use: --git=none, --git=commit ou --git=pr",
  );
  process.exit(1);
}

if (!VALID_AI_MODES.includes(aiMode)) {
  console.error(
    "❌ Modo de IA inválido. Use: --ai=gemini-codex, --ai=codex, --ai=claude ou --no-gemini",
  );
  process.exit(1);
}

if (aiMode === "gemini-codex" && !process.env.GEMINI_API_KEY) {
  console.error("❌ ERRO: GEMINI_API_KEY não encontrada no .env");
  console.error("Use --ai=codex ou --no-gemini para rodar sem Gemini.");
  process.exit(1);
}

console.log(`🧠 AI mode ativo: ${aiMode}`);

let genAI = null;

async function setupGeminiIfNeeded() {
  if (aiMode !== "gemini-codex") return;

  const { GoogleGenerativeAI } = await import("@google/generative-ai");
  genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
}

const railsContext = fs.existsSync("./ai/rails-context.md")
  ? fs.readFileSync("./ai/rails-context.md", "utf-8")
  : "";

const refactoringContext = fs.existsSync("./ai/refatoracao.md")
  ? fs.readFileSync("./ai/refatoracao.md", "utf-8")
  : "";

function cleanContent(content) {
  return content
    .replace(/```[a-zA-Z]*\n?/g, "")
    .replace(/```/g, "")
    .trim();
}

function normalizePath(filePath) {
  return filePath.trim().replace(/^\.?\//, "");
}

function isBlockedPath(filePath) {
  return BLOCKED_PATHS.some(
    (blockedPath) =>
      filePath === blockedPath.replace(/\/$/, "") ||
      filePath.startsWith(blockedPath),
  );
}

function isAllowedPath(filePath) {
  if (isBlockedPath(filePath)) return false;

  return ALLOWED_PATHS.some(
    (allowedPath) =>
      filePath === allowedPath.replace(/\/$/, "") ||
      filePath.startsWith(allowedPath),
  );
}

function escapeRegExp(string) {
  return string.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function slugify(value) {
  return value
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^a-z0-9-_]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 80);
}

function extractBlocks(output, marker) {
  const escapedMarker = escapeRegExp(marker);

  const regex = new RegExp(
    `${escapedMarker}\\s*([^\\n]+)\\n([\\s\\S]*?)(?=\\n#\\s*(?:CREATE|MANUAL_UPDATE):|$)`,
    "g",
  );

  const blocks = [];
  let match;

  while ((match = regex.exec(output)) !== null) {
    const originalPath = match[1].trim();
    const filePath = normalizePath(originalPath);
    const content = cleanContent(match[2]);

    if (!filePath || !content) continue;

    blocks.push({
      originalPath,
      filePath,
      content,
    });
  }

  return blocks;
}

function applyCreatesOnly(output) {
  const createBlocks = extractBlocks(output, "# CREATE:");

  if (createBlocks.length === 0) {
    console.log("⚠️ Nenhum arquivo novo para criar automaticamente.");
    return;
  }

  for (const block of createBlocks) {
    const { filePath, content } = block;

    if (!isAllowedPath(filePath)) {
      console.log(`⚠️ Ignorado fora do escopo ou bloqueado: ${filePath}`);
      continue;
    }

    if (fs.existsSync(filePath)) {
      console.log(`⚠️ Arquivo já existe. Não será sobrescrito: ${filePath}`);
      continue;
    }

    try {
      const dir = path.dirname(filePath);
      fs.mkdirSync(dir, { recursive: true });
      fs.writeFileSync(filePath, content);
      console.log(`✅ Criado: ${filePath}`);
    } catch (err) {
      console.log(`❌ Erro ao criar ${filePath}: ${err.message}`);
    }
  }
}

function getManualUpdates(output) {
  const blocks = extractBlocks(output, "# MANUAL_UPDATE:");

  if (blocks.length === 0) {
    return "Nenhuma alteração manual foi sugerida.";
  }

  return blocks
    .filter((block) => isAllowedPath(block.filePath))
    .map((block) => `# MANUAL_UPDATE: ${block.filePath}\n${block.content}`)
    .join("\n\n");
}

function runCommand(command) {
  execSync(command, {
    stdio: "inherit",
    encoding: "utf-8",
    maxBuffer: 1024 * 1024 * 20,
  });
}

function readCommand(command) {
  return execSync(command).toString().trim();
}

function hasGitChanges() {
  return readCommand("git status --porcelain").length > 0;
}

function getGitStatus() {
  try {
    return execSync("git status --porcelain", {
      encoding: "utf-8",
      maxBuffer: 1024 * 1024 * 20,
    });
  } catch {
    return "";
  }
}

function getChangedFiles() {
  const status = getGitStatus();

  if (!status.trim()) {
    return [];
  }

  return status
    .split("\n")
    .map((line) => {
      const filePath = line.slice(3).trim();

      if (filePath.includes(" -> ")) {
        return filePath.split(" -> ").pop().trim();
      }

      return filePath;
    })
    .filter(Boolean);
}

function getGitDiff() {
  try {
    return execSync("git diff -- .", {
      encoding: "utf-8",
      maxBuffer: 1024 * 1024 * 20,
    });
  } catch {
    return "";
  }
}

function getUntrackedFilesPreview() {
  const untrackedFiles = getGitStatus()
    .split("\n")
    .filter((line) => line.startsWith("?? "))
    .map((line) => line.slice(3).trim())
    .filter((filePath) => isAllowedPath(filePath))
    .slice(0, 20);

  if (untrackedFiles.length === 0) {
    return "";
  }

  return untrackedFiles
    .map((filePath) => {
      try {
        const content = fs.readFileSync(filePath, "utf-8");
        return `# ${filePath}\n${content.slice(0, 8000)}`;
      } catch {
        return `# ${filePath}\nNão foi possível ler o arquivo.`;
      }
    })
    .join("\n\n");
}

function ensureCleanWorkingTreeForGitFlow() {
  const status = readCommand("git status --porcelain");

  if (!status) return;

  console.log("❌ Existem mudanças locais antes de criar branch:");
  console.log(status);
  console.log("\nResolva antes de rodar com --git=commit ou --git=pr.");
  console.log(
    "Dica: use git status e faça commit, stash ou descarte as mudanças locais antes de rodar.",
  );
  process.exit(1);
}

function getDefaultBranch() {
  try {
    return readCommand("git symbolic-ref refs/remotes/origin/HEAD").replace(
      "refs/remotes/origin/",
      "",
    );
  } catch {
    return "main";
  }
}

function prepareGitFlow() {
  if (gitMode === "none") {
    console.log(
      "🧪 Modo git=none: aplicando na branch atual, sem commit e sem PR.",
    );
    return null;
  }

  ensureCleanWorkingTreeForGitFlow();

  const defaultBranch = getDefaultBranch();
  const branch = `ai/${slugify(taskName)}-${Date.now()}`;

  console.log(`\n🔄 Voltando para ${defaultBranch}...`);
  runCommand(`git checkout ${defaultBranch}`);

  console.log("⬇️ Atualizando repo...");
  runCommand("git pull");

  console.log(`🌿 Criando branch: ${branch}`);
  runCommand(`git checkout -b ${branch}`);

  return branch;
}

function createTempFile(prefix, content) {
  const tempPath = path.join(
    os.tmpdir(),
    `${prefix}-${slugify(taskName)}-${Date.now()}-${Math.random()
      .toString(16)
      .slice(2)}.md`,
  );

  fs.writeFileSync(tempPath, content);
  return tempPath;
}

function removeFileIfExists(filePath) {
  try {
    fs.rmSync(filePath, { force: true });
  } catch {
    // ignore cleanup errors
  }
}

function runCodexCommand(command) {
  return execSync(command, {
    stdio: "pipe",
    encoding: "utf-8",
    maxBuffer: 1024 * 1024 * 20,
  });
}

function isModelNotFoundOutput(output) {
  return (
    output.includes("Model not found") ||
    output.includes("model_not_found") ||
    output.includes("not supported") ||
    output.includes("404 Not Found")
  );
}

function runCodex(prompt, outputPath, sandbox = "workspace-write") {
  const tempPromptPath = createTempFile("codex-prompt", prompt);
  const safeOutputPath = JSON.stringify(outputPath);
  const safePromptPath = JSON.stringify(tempPromptPath);

  let lastOutput = "";

  for (const modelName of CODEX_MODELS) {
    const command = `codex exec --model ${modelName} -C . -s ${sandbox} --skip-git-repo-check -o ${safeOutputPath} - < ${safePromptPath}`;

    console.log(`\n🤖 Rodando Codex com modelo: ${modelName}`);

    try {
      const output = runCodexCommand(command);

      if (output.trim()) {
        console.log(output);
      }

      removeFileIfExists(tempPromptPath);
      return;
    } catch (err) {
      const stdout = err.stdout?.toString?.() || "";
      const stderr = err.stderr?.toString?.() || "";
      const combinedOutput = `${stdout}\n${stderr}\n${err.message || ""}`;

      lastOutput = combinedOutput;

      if (combinedOutput.trim()) {
        console.log(combinedOutput);
      }

      if (isModelNotFoundOutput(combinedOutput)) {
        console.log(
          `⚠️ Modelo indisponível: ${modelName}. Tentando próximo...`,
        );
        continue;
      }

      removeFileIfExists(tempPromptPath);
      throw err;
    }
  }

  removeFileIfExists(tempPromptPath);

  throw new Error(
    `Nenhum modelo do Codex funcionou. Modelos tentados: ${CODEX_MODELS.join(", ")}.\n\nÚltimo erro:\n${lastOutput}`,
  );
}

function runCodexToTemp(prompt, sandbox = "workspace-write") {
  const outputPath = createTempFile("codex-output", "");
  runCodex(prompt, outputPath, sandbox);

  const content = fs.existsSync(outputPath)
    ? fs.readFileSync(outputPath, "utf-8")
    : "";

  removeFileIfExists(outputPath);

  return content;
}

function runCodexManualUpdates({ manualUpdates, taskPath }) {
  if (
    !manualUpdates.trim() ||
    manualUpdates.includes("Nenhuma alteração manual foi sugerida.")
  ) {
    console.log("⚠️ Nenhuma alteração manual para o Codex aplicar.");
    return;
  }

  const task = fs.readFileSync(taskPath, "utf-8");
  const rules = fs.existsSync("./ai/rules.md")
    ? fs.readFileSync("./ai/rules.md", "utf-8")
    : "";

  const prompt = `
Você é o Codex atuando dentro do repositório Rails do SGTCC.

Sua responsabilidade:
- Aplicar alterações em arquivos existentes com segurança.
- NÃO criar branch.
- NÃO fazer commit.
- NÃO fazer push.
- NÃO abrir Pull Request.
- NÃO reescrever arquivos inteiros sem necessidade.
- Preservar código existente.
- Alterar apenas o necessário para cumprir a task.
- Respeitar a arquitetura Rails do projeto.
- Reutilizar models, controllers, services, concerns, helpers, components, views e specs existentes quando fizer sentido.
- Não alterar .env, credenciais, node_modules, vendor/bundle, tmp, log, storage, coverage ou arquivos gerados.
- Não executar comandos destrutivos.

# TASK ORIGINAL

${task}

# CONTEXTO RAILS / SGTCC

${railsContext}

# DIRETRIZ DE REFATORAÇÃO

${refactoringContext}

# REGRAS DO PROJETO

${rules}

# ALTERAÇÕES MANUAIS GERADAS PELO GEMINI

${manualUpdates}

Aplique essas alterações diretamente nos arquivos existentes.
Depois responda de forma curta listando o que foi alterado.
`;

  runCodexToTemp(prompt);
}

function runCodexReview({ taskPath }) {
  const task = fs.readFileSync(taskPath, "utf-8");
  const diff = getGitDiff();

  if (!diff.trim()) {
    console.log("⚠️ Sem diff para revisar com Codex.");
    return;
  }

  const prompt = `
Você é o Codex revisando alterações feitas no repositório Rails do SGTCC.

Sua responsabilidade:
- Revisar o diff atual.
- Corrigir bugs óbvios de import/require, path, sintaxe Ruby, ERB, rotas, migrations, specs e integração Rails.
- Não mudar o escopo da task.
- Não reescrever arquivos inteiros sem necessidade.
- Não fazer commit.
- Não fazer push.
- Não abrir Pull Request.
- Não alterar .env, credenciais, node_modules, vendor/bundle, tmp, log, storage, coverage ou arquivos gerados.
- Não executar comandos destrutivos.

# TASK ORIGINAL

${task}

# CONTEXTO RAILS / SGTCC

${railsContext}

# DIRETRIZ DE REFATORAÇÃO

${refactoringContext}

# DIFF ATUAL

${diff}

Revise e corrija diretamente os arquivos se encontrar problemas.
Depois responda resumindo o que foi revisado/corrigido.
`;

  runCodexToTemp(prompt);
}

function runCodexFullImplementation({ taskPath }) {
  const system = fs.existsSync("./ai/system.md")
    ? fs.readFileSync("./ai/system.md", "utf-8")
    : "";

  const context = fs.existsSync("./ai/context.md")
    ? fs.readFileSync("./ai/context.md", "utf-8")
    : "";

  const rules = fs.existsSync("./ai/rules.md")
    ? fs.readFileSync("./ai/rules.md", "utf-8")
    : "";

  const task = fs.readFileSync(taskPath, "utf-8");

  const prompt = `
Você é o Codex atuando como agente principal no repositório Rails do SGTCC.

Nesta execução, o Gemini está desativado.
Você deve fazer tudo:
- interpretar a task;
- criar arquivos novos se necessário;
- editar arquivos existentes se necessário;
- revisar o próprio resultado.

Regras obrigatórias:
- NÃO criar branch.
- NÃO fazer commit.
- NÃO fazer push.
- NÃO abrir Pull Request.
- NÃO alterar arquivos sensíveis ou gerados.
- NÃO alterar .env, credenciais, node_modules, vendor/bundle, tmp, log, storage ou coverage.
- NÃO executar comandos destrutivos.
- NÃO reescrever arquivos inteiros sem necessidade.
- Preservar comportamento existente.
- Fazer somente as alterações necessárias para cumprir a task.
- Respeitar padrões Rails e a arquitetura atual do SGTCC.
- Reutilizar models, controllers, services, concerns, helpers, ViewComponents, views, jobs, mailers e specs existentes.

# SYSTEM

${system}

# CONTEXT

${context}

# CONTEXTO RAILS / SGTCC

${railsContext}

# DIRETRIZ DE REFATORAÇÃO

${refactoringContext}

# RULES

${rules}

# TASK

${task}

Implemente a task diretamente nos arquivos do projeto.
Depois revise o resultado e corrija problemas óbvios.
Ao final, responda de forma curta com o que foi feito.
`;

  runCodexToTemp(prompt);
}

const CLAUDE_WRITE_TOOLS = "Edit,Write,Read,Bash";

function runClaudeCommand(command) {
  return execSync(command, {
    stdio: "pipe",
    encoding: "utf-8",
    maxBuffer: 1024 * 1024 * 20,
  });
}

function runClaude(prompt, outputPath, writeAccess = true) {
  const tempPromptPath = createTempFile("claude-prompt", prompt);
  const toolsFlag = writeAccess ? `--allowedTools "${CLAUDE_WRITE_TOOLS}"` : "";
  const command = `claude --print ${toolsFlag} < ${JSON.stringify(tempPromptPath)}`;

  console.log(`\n🤖 Rodando Claude...`);

  try {
    const output = runClaudeCommand(command);

    if (output.trim()) {
      console.log(output.slice(0, 500));
    }

    fs.writeFileSync(outputPath, output);
    removeFileIfExists(tempPromptPath);
  } catch (err) {
    const stdout = err.stdout?.toString?.() || "";
    const stderr = err.stderr?.toString?.() || "";
    const combined = `${stdout}\n${stderr}\n${err.message || ""}`;

    if (combined.trim()) console.log(combined);

    removeFileIfExists(tempPromptPath);
    throw err;
  }
}

function runClaudeToTemp(prompt, writeAccess = true) {
  const outputPath = createTempFile("claude-output", "");
  runClaude(prompt, outputPath, writeAccess);

  const content = fs.existsSync(outputPath)
    ? fs.readFileSync(outputPath, "utf-8")
    : "";

  removeFileIfExists(outputPath);
  return content;
}

function runClaudeFullImplementation({ taskPath }) {
  const system = fs.existsSync("./ai/system.md")
    ? fs.readFileSync("./ai/system.md", "utf-8")
    : "";

  const context = fs.existsSync("./ai/context.md")
    ? fs.readFileSync("./ai/context.md", "utf-8")
    : "";

  const rules = fs.existsSync("./ai/rules.md")
    ? fs.readFileSync("./ai/rules.md", "utf-8")
    : "";

  const task = fs.readFileSync(taskPath, "utf-8");

  const prompt = `
Você é o Claude Code atuando como agente principal no repositório Rails do SGTCC.

Nesta execução, você deve fazer tudo:
- interpretar a task;
- criar arquivos novos se necessário;
- editar arquivos existentes se necessário;
- revisar o próprio resultado.

Regras obrigatórias:
- NÃO criar branch.
- NÃO fazer commit.
- NÃO fazer push.
- NÃO abrir Pull Request.
- NÃO alterar arquivos sensíveis ou gerados.
- NÃO alterar .env, credenciais, node_modules, vendor/bundle, tmp, log, storage ou coverage.
- NÃO executar comandos destrutivos.
- NÃO reescrever arquivos inteiros sem necessidade.
- Preservar comportamento existente.
- Fazer somente as alterações necessárias para cumprir a task.
- Respeitar padrões Rails e a arquitetura atual do SGTCC.
- Reutilizar models, controllers, services, concerns, helpers, ViewComponents, views, jobs, mailers e specs existentes.

# SYSTEM

${system}

# CONTEXT

${context}

# CONTEXTO RAILS / SGTCC

${railsContext}

# DIRETRIZ DE REFATORAÇÃO

${refactoringContext}

# RULES

${rules}

# TASK

${task}

Implemente a task diretamente nos arquivos do projeto.
Depois revise o resultado e corrija problemas óbvios.
Ao final, responda de forma curta com o que foi feito.
`;

  runClaudeToTemp(prompt, true);
}

function runClaudeReview({ taskPath }) {
  const task = fs.readFileSync(taskPath, "utf-8");
  const diff = getGitDiff();

  if (!diff.trim()) {
    console.log("⚠️ Sem diff para revisar com Claude.");
    return;
  }

  const prompt = `
Você é o Claude Code revisando alterações feitas no repositório Rails do SGTCC.

Sua responsabilidade:
- Revisar o diff atual.
- Corrigir bugs óbvios de import/require, path, sintaxe Ruby, ERB, rotas, migrations, specs e integração Rails.
- Não mudar o escopo da task.
- Não reescrever arquivos inteiros sem necessidade.
- Não fazer commit.
- Não fazer push.
- Não abrir Pull Request.
- Não alterar .env, credenciais, node_modules, vendor/bundle, tmp, log, storage, coverage ou arquivos gerados.
- Não executar comandos destrutivos.

# TASK ORIGINAL

${task}

# CONTEXTO RAILS / SGTCC

${railsContext}

# DIRETRIZ DE REFATORAÇÃO

${refactoringContext}

# DIFF ATUAL

${diff}

Revise e corrija diretamente os arquivos se encontrar problemas.
Depois responda resumindo o que foi revisado/corrigido.
`;

  runClaudeToTemp(prompt, true);
}

function generateFinalOutput({ taskPath, outputPath }) {
  const task = fs.readFileSync(taskPath, "utf-8");
  const status = getGitStatus();
  const diff = getGitDiff();
  const changedFiles = getChangedFiles();
  const untrackedPreview = getUntrackedFilesPreview();

  const prompt = `
Você é o Codex escrevendo o relatório final da implementação.

Sua responsabilidade:
- Escrever SOMENTE o conteúdo do relatório final em Markdown.
- NÃO alterar arquivos do projeto.
- NÃO fazer commit.
- NÃO fazer push.
- NÃO abrir Pull Request.
- NÃO executar comandos.
- NÃO editar arquivos.

O relatório deve ter exatamente esta estrutura:

# Implementation Summary

## General Summary

Explique de forma objetiva o que foi implementado.

## Changed Files

Para cada arquivo alterado ou criado, escreva:

### caminho/do/arquivo.ext

- O que mudou neste arquivo.
- Por que essa alteração foi necessária.
- Observações importantes, se houver.

## Review Notes

Liste pontos que o usuário deve revisar/testar.

Se não houver algo para revisar, escreva uma frase curta dizendo isso.

# TASK ORIGINAL

${task}

# AI MODE

${aiMode}

# GIT STATUS

${status || "Sem alterações listadas pelo git status."}

# CHANGED FILES

${changedFiles.length > 0 ? changedFiles.join("\n") : "Nenhum arquivo alterado detectado."}

# GIT DIFF

${diff || "Sem diff disponível."}

# UNTRACKED FILES PREVIEW

${untrackedPreview || "Nenhum arquivo novo não rastreado para pré-visualizar."}
`;

  if (aiMode === "claude") {
    runClaude(prompt, outputPath, false);
  } else {
    runCodex(prompt, outputPath, "read-only");
  }
}

function commitChanges() {
  if (!hasGitChanges()) {
    console.log("⚠️ Nenhuma mudança foi criada. Commit não será feito.");
    return false;
  }

  runCommand("git add .");
  runCommand(`git commit -m "AI: ${taskName}"`);

  return true;
}

function createPullRequest(branch, prBodyPath) {
  runCommand(`git push origin ${branch}`);

  console.log("🚀 Criando Pull Request...");

  runCommand(
    `gh pr create --title "AI: ${taskName}" --body-file ${JSON.stringify(
      prBodyPath,
    )}`,
  );

  console.log("✅ PR criado com sucesso!");
}

function buildGeminiPrompt({ system, context, rules, task }) {
  return `
${system}

${context}

# CONTEXTO RAILS / SGTCC

${railsContext}

# DIRETRIZ DE REFATORAÇÃO

${refactoringContext}

${rules}

# TASK
${task}

# FLUXO HÍBRIDO GEMINI + CODEX

Você é o Gemini nesta etapa.

Responsabilidades do Gemini:
- Criar somente arquivos novos com # CREATE.
- Para arquivos existentes, NÃO reescrever o arquivo completo.
- Para arquivos existentes, usar apenas # MANUAL_UPDATE com instruções objetivas.
- O Codex aplicará as alterações manuais nos arquivos existentes depois.
- O Codex também revisará os arquivos criados.

# CONTEXTO TÉCNICO DO PROJETO

O projeto é um sistema Rails monolítico de gestão de TCC da UTFPR Guarapuava.
Use caminhos Rails reais, como:
- app/models/
- app/controllers/
- app/services/
- app/components/
- app/helpers/
- app/views/
- app/jobs/
- app/mailers/
- app/javascript/
- config/routes.rb
- config/locales/
- db/migrate/
- lib/tasks/
- spec/
- test/

# LEMBRETE FINAL CRÍTICO

Responda APENAS usando os blocos:

# CREATE: caminho/do/arquivo.ext
conteúdo completo do arquivo novo

# MANUAL_UPDATE: caminho/do/arquivo.ext
instrução objetiva do que deve ser alterado manualmente

REGRAS:
- Use # CREATE apenas para arquivos novos.
- Use # MANUAL_UPDATE para arquivos que já existem.
- Nunca use # FILE.
- Nunca reescreva arquivos existentes.
- Nunca sobrescreva config/routes.rb inteiro.
- Nunca sobrescreva models, controllers, services, concerns, helpers, views ou specs existentes.
- Nunca altere .env, credenciais, node_modules, vendor/bundle, tmp, log, storage, coverage ou arquivos gerados.
- Não use markdown.
- Não use blocos com crase.
- Não escreva explicações fora dos blocos.
`;
}

async function runGeminiCodexFlow({ taskPath, prompt }) {
  const MODELS = ["gemini-2.5-flash", "gemini-2.5-pro"];

  for (const modelName of MODELS) {
    try {
      console.log(`\n🚀 Testando modelo: ${modelName}`);

      const model = genAI.getGenerativeModel({ model: modelName });

      const start = Date.now();

      const result = await model.generateContent({
        contents: [{ role: "user", parts: [{ text: prompt }] }],
      });

      const text = result.response.text();
      const duration = Date.now() - start;

      console.log(`\n🔥 Modelo usado: ${modelName}`);
      console.log(`⏱️ Tempo: ${duration}ms`);

      console.log("\n📦 Preview output:");
      console.log(text.slice(0, 500));

      if (!shouldApply) {
        console.log("\n✅ Modo preview. Nada foi aplicado.");
        return true;
      }

      console.log("\n⚙️ Gemini criando apenas arquivos novos...");
      applyCreatesOnly(text);

      console.log("\n🛠️ Codex aplicando alterações em arquivos existentes...");
      const manualUpdates = getManualUpdates(text);
      runCodexManualUpdates({
        manualUpdates,
        taskPath,
      });

      console.log("\n🔎 Codex revisando o resultado final...");
      runCodexReview({
        taskPath,
      });

      return true;
    } catch (err) {
      console.log(`❌ Falhou: ${modelName}`);
      console.log(`   Motivo: ${err.message}`);
    }
  }

  return false;
}

async function run() {
  await setupGeminiIfNeeded();

  const taskPath = `./ai/tasks/${taskName}.md`;
  const outputPath = `./ai/output/implementation-summary-${slugify(taskName)}.md`;

  let system;
  let context;
  let rules;
  let task;
  let geminiPrompt;

  try {
    system = fs.existsSync("./ai/system.md")
      ? fs.readFileSync("./ai/system.md", "utf-8")
      : "";

    context = fs.existsSync("./ai/context.md")
      ? fs.readFileSync("./ai/context.md", "utf-8")
      : "";

    rules = fs.existsSync("./ai/rules.md")
      ? fs.readFileSync("./ai/rules.md", "utf-8")
      : "";

    task = fs.readFileSync(taskPath, "utf-8");

    geminiPrompt = buildGeminiPrompt({ system, context, rules, task });
  } catch (err) {
    console.error("❌ Erro ao ler arquivos .md:");
    console.error(err.message);
    return;
  }

  try {
    const branch = shouldApply ? prepareGitFlow() : null;

    if (aiMode === "gemini-codex") {
      const success = await runGeminiCodexFlow({
        taskPath,
        prompt: geminiPrompt,
      });

      if (!success) {
        console.log("\n🚨 Nenhum modelo Gemini funcionou.");
        return;
      }
    }

    if (aiMode === "codex") {
      if (!shouldApply) {
        console.log(
          "\n✅ Modo preview com --ai=codex. Nada foi aplicado porque Codex executa alterações diretamente.",
        );
        console.log(
          "Use --apply --ai=codex para permitir que o Codex implemente a task.",
        );
        return;
      }

      console.log("\n🤖 Codex implementando a task inteira sem Gemini...");
      runCodexFullImplementation({ taskPath });

      console.log("\n🔎 Codex revisando o resultado final...");
      runCodexReview({ taskPath });
    }

    if (aiMode === "claude") {
      if (!shouldApply) {
        console.log(
          "\n✅ Modo preview com --ai=claude. Nada foi aplicado porque Claude executa alterações diretamente.",
        );
        console.log(
          "Use --apply --ai=claude para permitir que o Claude implemente a task.",
        );
        return;
      }

      console.log("\n🤖 Claude implementando a task inteira...");
      runClaudeFullImplementation({ taskPath });

      console.log("\n🔎 Claude revisando o resultado final...");
      runClaudeReview({ taskPath });
    }

    if (!shouldApply) {
      return;
    }

    fs.mkdirSync("./ai/output", { recursive: true });

    console.log("\n🧾 Gerando output final único...");
    generateFinalOutput({
      taskPath,
      outputPath,
    });

    console.log(`✅ Output final salvo em: ${outputPath}`);

    if (gitMode === "none") {
      console.log("\n✅ Aplicado localmente sem commit e sem PR.");
      console.log("Use git diff para revisar.");
      return;
    }

    const committed = commitChanges();

    if (!committed) return;

    if (gitMode === "commit") {
      console.log("\n✅ Branch criada e commit feito. PR não foi aberto.");
      return;
    }

    if (gitMode === "pr") {
      createPullRequest(branch, outputPath);
      return;
    }
  } catch (err) {
    console.error("❌ Erro durante execução:");
    console.error(err.message);
  }
}

run();
