# Task

REF-05 — Reestruturar os controllers mais críticos, extraindo consultas e fluxos repetidos com contratos explícitos, sem alterar o comportamento HTTP ou as regras acadêmicas.

# Contexto

A REF-01 (`ai/output/fase-0-baseline/inventario-ref-01.md`) identificou controllers que ainda acumulam seleção de dados, regras condicionais, paginação e preparação de formulários. A REF-04 estabeleceu o padrão inicial da fase ao retirar a consulta histórica de orientações do `Responsible::OrientationsController` para `Orientations::ResponsibleListQuery`.

Os principais alvos remanescentes são:

1. `Responsible::ExaminationBoardsController`;
2. `TccOneProfessors::ExaminationBoardsController`;
3. `Professors::OrientationsController`;
4. `Professors::SupervisionsController`;
5. `ExternalMembers::SupervisionsController`.

Os dois controllers de bancas repetem:

- busca, paginação e ordenação de listagens por TCC;
- carregamento de banca simples ou com relacionamentos;
- seleção de orientações e identificadores de atividades para formulários;
- proteção de campos quando já existe ata de defesa;
- decisão de exclusão baseada na existência da ata;
- parâmetros permitidos condicionados ao estado da banca.

Os controllers de orientações e supervisões repetem:

- filtro opcional por status;
- seleção por TCC atual ou histórico;
- busca textual, preload, ordenação e paginação;
- escolha de URL de retorno conforme o calendário atual.

Esta task deve reduzir essas duplicações apenas quando houver responsabilidade clara. Não crie uma superclasse compartilhada entre namespaces nem um service genérico que receba nomes de métodos, rotas ou variáveis de instância do controller.

# Dependências

- REF-04 — Extrair a busca de orientações do responsável.

# Objetivo

Transformar os controllers priorizados em coordenadores HTTP. As actions devem se limitar a:

- receber e permitir parâmetros;
- aplicar autenticação e autorização já existentes;
- chamar objetos de consulta ou de aplicação com entradas explícitas;
- preparar somente informações de navegação e apresentação próprias da resposta;
- escolher redirect ou render conforme o resultado.

As extrações devem reduzir complexidade ou duplicação mensurável e permanecer independentes de `params`, sessão, flash, helpers, rotas e renderização.

# Instruções críticas

Preserve integralmente:

- quais bancas e orientações aparecem em cada listagem;
- filtros, busca textual, ordenação e paginação;
- permissões diferentes entre responsável e professor de TCC I;
- criação de banca TCC I/TCC II e o identificador padrão `:monograph` de TCC II;
- bloqueio de campos e limitação dos parâmetros quando existe ata de defesa;
- proibição de excluir banca que possui ata de defesa;
- mensagens flash, códigos HTTP, templates e destinos de redirecionamento;
- associação de orientações ao professor ou membro externo autenticado;
- carregamento de documentos e assinaturas nos fluxos existentes.

Não mova regras intrínsecas de `ExaminationBoard`, `Document` ou `Signature` nesta task. A reorganização desses models e de seus concerns pertence à REF-07.

Não altere o comportamento dos scopes de `Orientation` ou `ExaminationBoard`. A reorganização interna de `Orientation` pertence à REF-06.

# Escopo obrigatório

## 1. Consultas de bancas

Extrair a composição das listagens de bancas usada por:

- `Responsible::ExaminationBoardsController#tcc_one_current_semester`;
- `Responsible::ExaminationBoardsController#tcc_one`;
- `Responsible::ExaminationBoardsController#tcc_two_current_semester`;
- `Responsible::ExaminationBoardsController#tcc_two`;
- `TccOneProfessors::ExaminationBoardsController#tcc_one`;
- `TccOneProfessors::ExaminationBoardsController#tcc_two`.

O objeto deve receber parâmetros simples que expressem, no mínimo, TCC, recorte (`current` ou histórico), página, termo e contexto de preload/ordenação quando realmente houver diferença entre os namespaces.

Prefira uma interface sem nomes de scopes construídos com `send`. As combinações aceitas devem ser validadas por um mapa fechado ou por métodos explícitos.

## 2. Contexto de formulário de banca

Eliminar a repetição na seleção de:

- orientações atuais de TCC I/TCC II;
- identificadores de atividades de TCC I/TCC II;
- identificador padrão da nova banca de TCC II;
- estado de campos desabilitados quando existe ata.

A extração pode ser um objeto imutável de contexto/form data, desde que não conheça a view ou escreva variáveis de instância do controller. O controller continua atribuindo as variáveis esperadas pelos templates.

## 3. Fluxo repetido de exclusão de banca

Consolidar a decisão repetida nos dois controllers:

- banca sem ata pode ser excluída;
- banca com ata não pode ser excluída.

O objeto extraído deve retornar um resultado explícito que permita ao controller preservar mensagens e redirects específicos de cada namespace. Não passe URLs, flash ou funções de tradução para o objeto.

Se a inspeção demonstrar que `ExaminationBoard#destroy` já fornece contrato suficiente e que uma extração adicionaria apenas indireção, mantenha a decisão no controller e deduplique por outro mecanismo coeso. Registre a justificativa no relatório.

## 4. Consultas de orientações e supervisões

Extrair a composição repetida de status, TCC atual/histórico, busca, relacionamentos, ordenação e paginação dos controllers:

- `Professors::OrientationsController`;
- `Professors::SupervisionsController`;
- `ExternalMembers::SupervisionsController`.

O objeto deve começar a partir de uma relação já autorizada, como `current_professor.orientations`, `current_professor.supervisions` ou `current_external_member.supervisions`. Ele não deve receber nem procurar o usuário atual por conta própria.

Preserve as diferenças comprovadas entre listagens. Não force preloads ou ordenações idênticas quando o comportamento atual não for equivalente.

# Escopo permitido

- controllers priorizados nesta task;
- novos query objects e services em namespaces coerentes sob `app/services/`;
- extração de pequenos objetos de resultado ou contexto necessários aos contratos;
- specs unitários dos objetos extraídos;
- specs de request/feature dos controllers diretamente afetados;
- ajustes mínimos em factories e helpers para caracterizar os fluxos;
- relatório final em `ai/output/fase-2-controllers-e-consultas/`.

# Escopo proibido

- Não altere migrations, schema ou dados persistidos.
- Não altere enums, status ou transições acadêmicas.
- Não crie uma superclasse comum para controllers de namespaces diferentes.
- Não crie concerns de controller que apenas ocultem acesso a `params` ou variáveis de instância.
- Não passe `params`, controller, helpers, rotas, flash ou request para services/query objects.
- Não altere policies, autenticação ou autorização.
- Não altere callbacks, associações ou concerns de `Orientation`, `ExaminationBoard`, `Document` ou `Signature`.
- Não refatore geração de atas, documentos, assinaturas, notificações ou autenticidade documental; isso pertence à REF-07.
- Não redesenhe views, components ou partials; isso pertence à fase de apresentação.
- Não altere rotas, nomes de parâmetros, textos, traduções, paginação ou respostas HTTP.
- Não faça commit, push ou criação de branch.

# Roteiro de implementação

## 1. Medir e caracterizar antes da extração

- Registrar tamanho, ABC/Flog e offenses dos controllers priorizados.
- Mapear cada action para suas consultas, efeitos colaterais, variáveis de view, template, status HTTP, flash e redirect.
- Identificar quais blocos são semanticamente equivalentes e quais apenas se parecem visualmente.
- Confirmar a cobertura existente dos fluxos antes de editar código de produção.

Adicionar testes de caracterização somente onde houver lacuna, cobrindo pelo menos:

- quatro listagens do responsável: TCC I/TCC II, atuais e históricas;
- duas listagens de bancas do professor de TCC I;
- busca, paginação e ordenação de bancas;
- criação inválida de banca recarregando orientações e atividades corretas;
- edição de banca com e sem ata;
- exclusão permitida sem ata e bloqueada com ata nos dois namespaces;
- orientações e supervisões atuais por TCC, histórico e filtro por status;
- isolamento: um professor ou membro externo não recebe registros de outro usuário.

## 2. Extrair consultas de bancas

- Criar um objeto de consulta com combinações aceitas explícitas.
- Reutilizar scopes existentes apenas quando reproduzirem a consulta atual.
- Preservar `date: :desc` nas listagens do responsável e `recent` onde usado pelo professor de TCC I.
- Preservar `with_relationships`/includes necessários às views.
- Aplicar busca antes ou depois da paginação exatamente conforme o comportamento observável atual; não introduzir filtragem em memória.
- Garantir ausência de duplicatas e de N+1 novos nos relacionamentos exibidos.

## 3. Extrair preparação de formulário

- Definir uma interface por TCC ou identificador da banca.
- Retornar orientações e atividades, sem atribuir `@orientations` ou `@activities` internamente.
- Preservar a seleção de TCC II para bancas `monograph?` e TCC I para as demais.
- Preservar os dados recarregados após falha de validação em `create` e `update`.
- Não mover mensagens, breadcrumbs ou renderização para o objeto.

## 4. Tratar exclusão e parâmetros protegidos

- Caracterizar o comportamento de `defense_minutes.blank?` antes de deduplicar.
- Manter o controller responsável pelo flash e redirect próprios do namespace.
- Não permitir que a extração ignore callbacks ou erros de `destroy`.
- Preservar a permissão somente de `document_available_until` quando já existe ata.
- Manter `can_update_or_destroy?` do professor de TCC I e sua semântica atual.

## 5. Extrair consultas de orientações/supervisões

- Receber uma relação previamente autorizada.
- Aplicar status somente quando presente.
- Diferenciar consulta atual por `:one`/`:two` de consulta histórica.
- Aplicar `search`, `with_relationships`, `recent` e `page` apenas nos fluxos que já os utilizam.
- Substituir metaprogramação dinâmica baseada em entrada por um mapa fechado de operações aceitas.
- Manter no controller títulos, breadcrumbs, URLs de busca e variáveis da view.

## 6. Simplificar e revisar controllers

- Remover métodos privados que ficaram sem responsabilidade após as extrações.
- Não substituir métodos legíveis por wrappers que apenas encaminham argumentos.
- Manter strong parameters no controller; extraia apenas a decisão de domínio quando necessária, não o acesso a `params`.
- Confirmar que cada action ainda é compreensível como sequência de entrada, autorização, chamada e resposta.
- Remover comentários temporários e desativações de RuboCop resolvidos pela task.

## 7. Verificação final

- Executar specs unitários dos objetos novos.
- Executar todos os feature specs dos cinco controllers priorizados.
- Executar a suíte RSpec completa.
- Executar RuboCop nos arquivos alterados e, antes do merge, no projeto completo.
- Comparar métricas antes/depois e registrar qualquer controller mantido sem alteração com justificativa concreta.

# Critérios de aceite

- As actions de listagem priorizadas não encadeiam scopes, busca, ordenação e paginação diretamente.
- Objetos extraídos recebem parâmetros simples ou relações já autorizadas e não conhecem HTTP.
- Consultas não usam `send` com entrada aberta e não filtram coleções em memória.
- As quatro listagens de bancas do responsável e as duas do professor retornam os mesmos registros, na mesma ordem e com a mesma paginação.
- Formulários de TCC I/TCC II continuam recebendo as mesmas orientações, atividades, defaults e campos desabilitados.
- Falhas de criação/edição recarregam os dados necessários e mantêm `unprocessable_content`.
- Bancas sem ata continuam removíveis; bancas com ata continuam protegidas, com os mesmos flashes e redirects.
- Orientações e supervisões mantêm filtro por usuário, TCC, status, termo, histórico, ordem e paginação.
- Não há vazamento de registros entre professores ou membros externos.
- Rotas, parâmetros, templates, traduções, breadcrumbs e respostas HTTP permanecem inalterados.
- Nenhuma regra de documentos, assinaturas ou geração de ata foi movida ou alterada.
- Cada extração possui cobertura isolada e reduz complexidade ou duplicação medida.
- A suíte relacionada e a suíte completa passam; o RuboCop não registra novas violações.

# Validação sugerida

```bash
bundle exec rspec spec/services/examination_boards/ \
  spec/services/orientations/ \
  spec/features/responsible/examination_boards/ \
  spec/features/tcc_one_professors/examination_boards/ \
  spec/features/professors/orientations/ \
  spec/features/professors/supervisions/ \
  spec/features/external_members/supervisions/

bundle exec rubocop app/controllers/responsible/examination_boards_controller.rb \
  app/controllers/tcc_one_professors/examination_boards_controller.rb \
  app/controllers/professors/orientations_controller.rb \
  app/controllers/professors/supervisions_controller.rb \
  app/controllers/external_members/supervisions_controller.rb \
  app/services/ spec/services/

bundle exec rspec
bundle exec rubocop --parallel
```

Se o projeto exigir Docker, use os comandos equivalentes fornecidos por `./run`.

Falhas de ambiente não devem ser registradas como sucesso. Documente comando, mensagem e comportamentos não validados dinamicamente.

# Métricas antes/depois

Registrar, no mínimo:

- linhas e ABC/Flog por controller priorizado;
- quantidade de actions que compõem consultas diretamente;
- quantidade de blocos duplicados removidos;
- quantidade e contrato dos objetos extraídos;
- resultado dos specs focados e da suíte completa;
- offenses do RuboCop nos arquivos alterados e no projeto.

O esperado é reduzir complexidade e duplicação nos controllers sem simplesmente transferir o mesmo código para um objeto genérico e acoplado ao HTTP.

# Relatório final esperado

Criar `ai/output/fase-2-controllers-e-consultas/implementation-summary-ref-05-reestruturar-controllers-criticos.md` com:

## Resumo

Responsabilidades extraídas e controllers simplificados.

## Inventário antes da alteração

Tabela por action com consulta, regra, variáveis de view e contrato HTTP preservado.

## Arquivos alterados

Lista dos arquivos e responsabilidade de cada mudança.

## Contratos dos objetos extraídos

Entradas, saída, erros e limites de cada query object/service/contexto.

## Comportamento preservado

Evidências sobre listagens, busca, status, paginação, formulários, criação, edição, exclusão, proteção por ata e isolamento por usuário.

## Métricas antes/depois

Tabela com linhas, ABC/Flog, consultas nas actions, duplicações e offenses.

## Validação

Comandos e resultados de RSpec e RuboCop, separando regressões, falhas preexistentes e limitações ambientais.

## Riscos e próximos passos

Registrar decisões deliberadamente adiadas e confirmar que `Orientation` pertence à REF-06 e `ExaminationBoard`, documentos e assinaturas pertencem à REF-07.
