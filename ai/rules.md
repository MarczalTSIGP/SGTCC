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
- Mantenha controllers enxutos e voltados a orquestração.
- Evite lógica complexa em views.
- Evite mover regra entre camadas sem necessidade concreta.
- Ao extrair código de models ou controllers, escolha a camada pelo **papel** do objeto, nunca por conveniência. `app/services/` não é depósito genérico (Fase 10, REF-25 a REF-32):

| Papel | Pergunta que responde | Local |
|---|---|---|
| Model domain behavior | Qual é o estado, a associação, o scope ou a invariante local deste registro? | `app/models/` |
| Service Object | Como executar esta operação de negócio (vários models, transação, efeito externo, passos ordenados)? | `app/services/` |
| Query Object | Quais registros satisfazem esta consulta? Somente leitura; um método `call`; preload faz parte do contrato | `app/queries/` |
| Policy Object | Este usuário pode fazer isto com este registro? | `app/policies/` |
| Value Object | Qual é o valor deste conceito imutável e como ele se combina? | `app/value_objects/` |
| Form Object | Esta entrada do usuário (multi-model, busca, não persistida) é válida e o que ela pede? | `app/forms/` |
| Presenter | Como exibir este recurso ou coleção (rótulos, valores formatados, links)? Não altera registros nem decide permissão | `app/presenters/` |
| Decorator | Que comportamento de exibição acrescentar a um objeto existente, delegando o resto (`SimpleDelegator`)? | `app/decorators/` |
| ViewComponent | Markup reutilizável e estilo condicional, com dados prontos | `app/components/` |

- Predicados de estado persistido (`viewed?`, `signed?`, `role?`) ficam no model; a Policy os compõe numa decisão de acesso. O controller mantém o redirect e o flash.
- Policies, Presenters, Forms e Value Objects são POROs: não adicione Pundit, Draper ou gems equivalentes sem necessidade justificada.
- Rotinas de dados de desenvolvimento ficam em `lib/tasks/db/populate/` (`Db::Populate::*`), carregadas por `require` dentro da task, nunca em `app/`.
- Ao mover ou renomear uma classe, procure também referências por **texto** (`constantize`, nomes de classe em strings, caminhos de arquivo em specs, `.rubocop.yml` e `spec/support/simplecov.rb`), não só pela constante.
- Rode `bin/rails zeitwerk:check` depois de qualquer movimentação de arquivo em `app/`.

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
