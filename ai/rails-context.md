# Contexto técnico Rails do SGTCC

## Estrutura esperada do projeto

O SGTCC segue a estrutura típica de uma aplicação Ruby on Rails, com organização por camadas e convenções de framework. O agente deve preferir soluções alinhadas com Rails antes de criar padrões paralelos.

### Caminhos importantes

- `app/models`: models, associações, validações, enums, scopes e parte do domínio.
- `app/controllers`: entrada HTTP, autenticação, autorização implícita por área e orquestração de fluxo.
- `app/services`: serviços e objetos de aplicação para regras que não cabem bem em model/controller.
- `app/views`: templates e renderização da interface.
- `app/components`: componentes de interface com `ViewComponent`, se presentes.
- `app/helpers`: helpers de visualização e formatação.
- `app/javascript`: código front-end, `Stimulus`, integrações com Hotwire e scripts complementares.
- `config/routes.rb`: mapa de rotas, incluindo áreas públicas e áreas por perfil.
- `config/locales`: traduções e mensagens de interface, predominantemente em português.
- `db/migrate`: migrations incrementais de banco.
- `lib/tasks`: tarefas auxiliares e rake tasks.
- `spec`: suíte de testes RSpec.

## Boas práticas Rails

- Siga convenções de nomes e localização de arquivos.
- Prefira métodos pequenos, coesos e testáveis.
- Evite acoplamento excessivo entre controller, model e view.
- Antes de introduzir um service, confirme que há benefício real de organização.
- Aproveite scopes, associations e validations quando fizer sentido, mas sem esconder complexidade demais.

## Cuidados com ActiveRecord

- Revise associações antes de alterar dependências ou chaves estrangeiras.
- Tome cuidado com `dependent`, `inverse_of`, `through` e carregamento implícito.
- Evite lógica de consulta duplicada quando um escopo ou query object local resolver bem.
- Mantenha atenção a consultas que precisam preservar compatibilidade com histórico e registros legados.

## Cuidados com callbacks

- Callbacks podem disparar efeitos colaterais importantes, como geração de documentos, assinaturas ou notificações.
- Antes de alterar `after_create`, `after_commit`, `before_validation` ou similares, mapeie quem depende desse comportamento.
- Evite introduzir callbacks novos para lógica complexa quando um service explícito deixar o fluxo mais claro.

## Cuidados com scopes

- Scopes devem ser previsíveis e compostos com segurança.
- Evite scopes que escondem efeitos complexos demais sem necessidade.
- Ao refatorar scopes, preserve ordenação, filtros implícitos e compatibilidade com paginação e busca.
- Revise impactos em dashboards, páginas públicas e consultas por perfil.

## Cuidados com enums

- Não altere valores persistidos de enums sem necessidade explícita.
- Antes de renomear ou reorganizar enums, verifique uso em views, controllers, serializers, jobs e testes.
- Lembre que enums podem afetar filtros, traduções, regras de negócio e dados já salvos.

## Cuidados com migrations

- Crie migrations novas para qualquer mudança de schema.
- Evite editar migrations antigas.
- Considere defaults, nullability, índices e compatibilidade com dados existentes.
- Em mudanças delicadas, pense em rollback e em impacto sobre dados antigos.

## Cuidados com performance e N+1

- Observe consultas usadas em listagens, dashboards, páginas públicas e relatórios.
- Use `includes`, `preload` ou `joins` com critério quando necessário.
- Não adicione eager loading por reflexo; confirme onde ele resolve problema real.
- Em refatorações, preserve preloadings já existentes quando eles evitarem N+1 conhecido.

## Cuidados com autenticação Devise

- O projeto usa `Devise` com múltiplos perfis.
- Evite alterar fluxos de login, sessões, chaves de autenticação e cadastros sem necessidade clara.
- Ao mexer em controllers autenticados, revise corretamente `current_*`, filtros e namespace da área correspondente.
- Mudanças em autenticação podem ter impacto institucional alto e exigem cautela extra.

## Cuidados com CarrierWave

- Uploads podem estar ligados a documentos, anexos ou imagens de perfil.
- Preserve contratos de upload, caminhos, validações e formatos esperados.
- Não altere fluxo de arquivos sem considerar compatibilidade com dados existentes e testes.

## Cuidados com Hotwire e Stimulus

- Ao mexer em interface dinâmica, respeite o fluxo já adotado pelo projeto.
- Evite inserir JavaScript ad hoc quando um controller `Stimulus` ou resposta compatível com Turbo resolver melhor.
- Preserve comportamento progressivo e integração com renderização do Rails.

## Cuidados com ViewComponent

- Se a interface usar `ViewComponent`, mantenha a separação entre apresentação e regra de negócio.
- Componentes devem receber dados claros e evitar consultas pesadas internamente.
- Não mova lógica de domínio para componentes de apresentação.

## Cuidados com Solid Queue

- Jobs e notificações assíncronas podem afetar comportamento visível do sistema.
- Antes de refatorar jobs, revise gatilhos, retries, estados e regras de disparo.
- Preserve nomes, contratos e payloads quando houver dependência entre models, jobs e notificações.

## Diretrizes para RSpec

- Prefira ajustar testes próximos ao comportamento alterado.
- Em models, cubra validações, scopes, callbacks e regras de negócio observáveis.
- Em requests ou controllers, cubra fluxos relevantes por perfil quando a task tocar comportamento HTTP.
- Em features, use somente quando o risco justificar.
- Evite testes excessivamente acoplados à implementação interna quando o comportamento pode ser validado de forma mais estável.
- Se a task for refatoração pura, preserve a cobertura existente e adicione testes apenas quando necessário para blindar comportamento.
