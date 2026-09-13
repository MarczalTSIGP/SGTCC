# Task

REF-12 — Consolidar os blocos de apresentação priorizados pela REF-11, preservando conteúdo, rotas, formulários e diferenças comprovadas entre namespaces.

# Dependência

- REF-11 — Inventariar partials e regras de apresentação repetidas.

# Objetivo

Reduzir a duplicação dos três candidatos priorizados no inventário:

1. as seis tabelas de documentos de orientação/supervisão;
2. os três templates de assinatura de documento;
3. os dois formulários de arquivo de nomeação de banca.

# Escopo obrigatório

## Tabela de documentos

- Criar um component dedicado ao shell compartilhado pelas seis listagens.
- Receber a coleção e o partial de linha explicitamente.
- Preservar a presença ou ausência das colunas `all_signed` e de ações em cada tela.
- Preservar `page_entries_info`, estado vazio, paginação, partials de linha e rotas de detalhe.
- Não transformar a tabela em uma abstração genérica para qualquer domínio.

## Assinatura de documentos

- Consolidar o template idêntico usado por acadêmicos, professores e membros externos.
- Preservar títulos, tradução por tipo documental e o `Documents::SignFormComponent` existente.
- Manter nos controllers os valores específicos de username, URL de confirmação e URL de retorno.

## Arquivo de nomeação de banca

- Consolidar os dois formulários em uma partial compartilhada.
- Receber explicitamente a banca, a nota, o campo/ID do autor, opções HTML e URL.
- Preservar `professor_id` versus `external_member_id`, o `id="appoints_form"` exclusivo do professor, upload, cache, editor markdown e botão de envio.

# Fora do escopo

- Não alterar regras acadêmicas, models, persistência, autenticação, autorização ou rotas.
- Não unificar as listagens de calendários descartadas pela REF-11.
- Não refatorar o recurso completo de TEP/TSO.
- Não remover as partials órfãs registradas pela REF-11.
- Não alterar o component de assinatura já existente.
- Não fazer commit, push ou criar branch.

# Critérios de aceite

- As seis listagens usam um único component e mantêm suas colunas e links originais.
- Os três perfis renderizam um único template de assinatura.
- Os dois perfis renderizam uma única partial de arquivo de nomeação com seus campos de autor corretos.
- Há cobertura isolada das variantes do novo component.
- Os feature specs dos fluxos afetados passam.
- A suíte completa e o RuboCop passam sem novas violações.

# Validação sugerida

```bash
bundle exec rspec spec/components/documents/orientation_table_component_spec.rb \
  spec/features/academics/orientations/orientations_documents_index_spec.rb \
  spec/features/external_members/supervisions/supervisions_documents_index_spec.rb \
  spec/features/professors/orientations/orientations_documents_index_spec.rb \
  spec/features/professors/supervisions/supervisions_documents_index_spec.rb \
  spec/features/responsible/orientations/orientations_documents_index_spec.rb \
  spec/features/tcc_one_professors/orientations/orientations_documents_index_spec.rb

bundle exec rspec
bundle exec rubocop --parallel
```
