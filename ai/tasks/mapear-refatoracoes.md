# Task

Realizar um diagnóstico técnico de refatoração do sistema SGTCC com base em inspeção real do código e gerar um relatório em Markdown dentro da pasta `ai/output/`.

# Instrução crítica

Você PODE ler e inspecionar arquivos do projeto.

Você NÃO PODE alterar, apagar, mover, renomear ou formatar nenhum arquivo do sistema.

A única criação permitida nesta task é o arquivo de relatório final em:

`ai/output/relatorio-refatoracao-sgtcc.md`

Não implemente nada.
Não corrija código.
Não crie migrations.
Não crie testes.
Não altere arquivos de código.
Não altere arquivos de configuração do Rails.
Não altere rotas.
Não atualize dependências.
Não faça commit.
Não faça push.
Não abra Pull Request.

Sua única responsabilidade é analisar o código existente e escrever um relatório técnico em Markdown no arquivo:

`ai/output/relatorio-refatoracao-sgtcc.md`

# Contexto

O SGTCC é um sistema web de gestão de TCC da UTFPR Guarapuava, feito em Ruby on Rails.

O sistema centraliza o ciclo completo do TCC, incluindo:

- orientações;
- calendários acadêmicos;
- atividades e prazos;
- bancas;
- documentos formais;
- assinaturas eletrônicas;
- validação pública de autenticidade;
- áreas separadas para responsável, professores, alunos e membros externos;
- área pública do site;
- API JSON simples para orientações aprovadas.

Os principais núcleos de domínio são:

- `Orientation`;
- `Calendar`;
- `Activity`;
- `ExaminationBoard`;
- `Document`;
- `Signature`;
- usuários/perfis/autenticação;
- documentos e assinatura eletrônica;
- área pública e relatórios.

# Objetivo

Analisar o código real do projeto e produzir um relatório priorizado de refatoração.

O relatório deve indicar os pontos que mais precisam de refatoração, organizando do mais crítico para o menos crítico.

A análise deve considerar:

- complexidade excessiva;
- models com responsabilidades demais;
- controllers grandes ou com regra de negócio;
- duplicação de lógica;
- callbacks perigosos ou difíceis de entender;
- scopes complexos;
- queries com risco de N+1;
- regras de negócio espalhadas;
- concerns com responsabilidade confusa;
- services ausentes ou mal definidos;
- views com lógica excessiva;
- helpers com regra de negócio;
- rotas muito acopladas;
- documentos e assinaturas com fluxo sensível;
- validações frágeis;
- enums inconsistentes;
- testes ausentes, frágeis ou pouco determinísticos;
- risco de quebrar dados históricos;
- pontos que dificultam manutenção futura.

# Escopo permitido

Você pode ler e analisar arquivos do projeto, especialmente:

- `app/models/`;
- `app/controllers/`;
- `app/services/`;
- `app/concerns/`;
- `app/helpers/`;
- `app/views/`;
- `app/components/`;
- `app/jobs/`;
- `app/mailers/`;
- `config/routes.rb`;
- `config/locales/`;
- `db/schema.rb`;
- `db/migrate/`;
- `lib/tasks/`;
- `spec/`;
- `test/`;
- `README.md`;
- `Gemfile`.

# Escopo de escrita permitido

Você pode criar apenas este arquivo:

`ai/output/relatorio-refatoracao-sgtcc.md`

Se a pasta `ai/output/` não existir, você pode criá-la.

Nenhum outro arquivo pode ser criado, alterado, removido, movido ou renomeado.

# Fora do escopo

Não implemente nenhuma refatoração agora.

Não altere nenhum arquivo de código.

Não crie migrations.

Não crie testes.

Não renomeie classes, métodos, arquivos ou rotas.

Não corrija bugs.

Não atualize dependências.

Não altere autenticação, permissões, assinatura digital, geração de documentos ou validação pública.

Não faça sugestões genéricas sem apontar evidências no código.

# Formato obrigatório do relatório

Escreva o relatório final em Markdown no arquivo:

`ai/output/relatorio-refatoracao-sgtcc.md`

O relatório deve seguir exatamente esta estrutura:

# Relatório de Refatoração do SGTCC

## Resumo Geral

Explique em poucas linhas o estado geral do código e quais áreas parecem mais críticas.

## Critérios de Priorização

Explique quais critérios foram usados para ordenar os pontos do mais crítico para o menos crítico.

Considere pelo menos:

- risco para regra de negócio;
- risco para dados históricos;
- dificuldade de manutenção;
- acoplamento;
- duplicação;
- complexidade;
- impacto em documentos/assinaturas;
- impacto em calendários, orientações e bancas;
- cobertura ou fragilidade de testes.

## Ranking de Pontos de Refatoração

Liste os pontos em ordem de prioridade, começando pelo mais crítico.

Para cada item, use exatamente este formato:

### 1. Título do problema

**Prioridade:** Crítica / Alta / Média / Baixa

**Arquivos relacionados:**

- `caminho/do/arquivo.rb`
- `outro/caminho.rb`

**Problema identificado:**

Explique o problema com clareza.

**Por que isso é crítico:**

Explique o impacto para manutenção, regra de negócio, risco de bug ou evolução do sistema.

**Evidências no código:**

Aponte métodos, classes, padrões ou trechos observados. Não copie grandes blocos de código. Cite nomes de métodos, classes, associações, callbacks, scopes, rotas ou specs quando possível.

**Sugestão de refatoração futura:**

Explique como esse ponto poderia ser refatorado em uma task futura.

**Cuidados antes de refatorar:**

Liste riscos, testes necessários e partes do sistema que podem ser afetadas.

Repita esse formato para todos os pontos relevantes encontrados.

## Refatorações Recomendadas por Fase

Organize uma sugestão de plano em fases:

### Fase 1 — Refatorações críticas e seguras

Liste mudanças que deveriam ser feitas primeiro.

### Fase 2 — Organização de domínio

Liste mudanças relacionadas a models, services, concerns e regras de negócio.

### Fase 3 — Controllers, views e fluxo de interface

Liste mudanças relacionadas a controllers, views, helpers, componentes e rotas.

### Fase 4 — Testes e segurança de manutenção

Liste melhorias de testes, factories, specs e validações.

## Sugestão de Primeiras Tasks

Crie uma lista de tasks pequenas e seguras que poderiam ser executadas depois desta análise.

Cada task deve ter:

- nome sugerido;
- objetivo;
- arquivos prováveis;
- risco;
- testes recomendados.

## Conclusão

Explique qual deveria ser o primeiro foco de refatoração e por quê.

# Regras da análise

Seja específico.

Não diga apenas “melhorar organização” ou “reduzir complexidade”. Sempre aponte onde, por quê e qual seria a melhoria.

Priorize pontos reais encontrados no código.

Não invente arquivos, classes ou métodos que não existem.

Se alguma área parecer importante, mas você não conseguir confirmar pelo código, marque como “necessita investigação”.

O relatório deve ser baseado em inspeção real do código.

Não faça alterações no projeto em hipótese alguma, exceto criar o arquivo `ai/output/relatorio-refatoracao-sgtcc.md`.

Ao final, responda apenas informando que o relatório foi criado em:

`ai/output/relatorio-refatoracao-sgtcc.md`
