# Regras obrigatórias de desenvolvimento

## Limites de alteração

- Não altere `.env`, credenciais, `config/master.key`, `tmp/`, `log/`, `storage/`, `node_modules/`, `vendor/bundle/`, `coverage/` ou arquivos gerados, salvo se a task pedir explicitamente.
- Não altere arquivos fora do escopo da task sem necessidade clara.
- Não reescreva arquivos inteiros quando uma alteração localizada resolver.
- Não faça commit, push ou criação de branch, salvo instrução explícita.

## Banco de dados

- Não altere migrations antigas, exceto se a task pedir explicitamente.
- Para mudanças de schema, crie novas migrations.
- Preserve compatibilidade com dados já existentes.
- Nunca assuma que tabelas críticas podem ser recriadas ou que dados históricos podem ser descartados.

## Convenções de código

- Mantenha nomes de classes, métodos, arquivos e identificadores técnicos em inglês.
- Mantenha mensagens de interface em português quando o sistema já seguir esse padrão.
- Preserve estilo e organização já adotados no projeto, salvo quando a task pedir refatoração estrutural.
- Evite adicionar dependências novas sem necessidade clara e justificada.

## Arquitetura e organização

- Respeite a arquitetura Rails atual do projeto.
- Prefira extração para `services`, `concerns` ou objetos de domínio quando models e controllers estiverem muito grandes e a task pedir reorganização.
- Mantenha controllers enxutos e voltados a orquestração.
- Evite lógica complexa em views.
- Evite mover regra entre camadas sem necessidade concreta.

## Segurança e áreas sensíveis

- Não mude rotas públicas sem necessidade clara.
- Não altere fluxos de assinatura, autenticação documental ou validação pública sem extremo cuidado.
- Evite mexer em autenticação Devise, permissões e papéis sem necessidade explícita.
- Não remova validações sem justificativa técnica e cobertura adequada.

## Comportamento e compatibilidade

- Preserve comportamento existente em tarefas de refatoração.
- Preserve contratos públicos usados por controllers, views, serializers, jobs e testes.
- Preserve compatibilidade com dados antigos, documentos emitidos e assinaturas já registradas.
- Ao alterar enums, scopes, callbacks ou associações, considere efeitos indiretos no restante do sistema.

## Testes e validação

- Adicione ou ajuste testes quando houver alteração de regra de negócio ou comportamento observável.
- Prefira testes focados e alinhados ao escopo real da mudança.
- Ao final, rode ou sugira os testes mais relevantes para a task.
- Se não for possível rodar testes, registre isso claramente no relatório.

## Fluxo de execução do agente

- Leia primeiro a task e os arquivos prováveis antes de editar.
- Faça mudanças pequenas e revisáveis.
- Explique no relatório final o que foi alterado, por quê e quais riscos permanecem.
- Em caso de dúvida entre simplificar e preservar comportamento, preserve comportamento.
