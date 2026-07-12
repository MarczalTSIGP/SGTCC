# Implementation Summary

## General Summary

Foi feita uma refatoração interna das factories `professors.rb`, `document_types.rb` e `documents.rb`, preservando os nomes públicos existentes.

A alteração centralizou dados repetidos, reduziu duplicação de callbacks e manteve a semântica pública das factories. Nenhum spec foi alterado, nenhum código de produção foi modificado e não houve renomeação ou remoção de factories públicas.

## Changed Files

### spec/factories/professors.rb

- Foi criado um mapa interno de roles para `:responsible`, `:coordinator` e `:professor_tcc_one`.
- Foi extraído um callback compartilhado para localizar ou criar o role esperado e associá-lo ao professor criado.
- A alteração foi necessária para remover duplicação entre as três factories de papel e corrigir o comportamento perigoso anterior, em que um role já existente podia impedir a associação do novo professor ao role.
- Observação importante: os nomes públicos `:professor`, `:responsible`, `:coordinator` e `:professor_tcc_one` foram preservados.

### spec/factories/document_types.rb

- Foi criado um hash interno com os identificadores e chaves de tradução dos tipos de documento.
- As factories específicas de document type passaram a ser geradas a partir desse mapa, mantendo os mesmos nomes públicos e os mesmos valores de `name` e `identifier`.
- A alteração foi necessária para reduzir repetição e deixar explícita a lista de document types suportados.
- Observação importante: não foi usado `find_or_create_by` nem `initialize_with`; a semântica de criação das factories foi preservada.

### spec/factories/documents.rb

- Foram extraídos lambdas internos para os payloads de `request` reutilizados pelas factories.
- Foram criados traits internos para documentos com request de justificativa e request de nova orientação.
- As factories `:document_tdo`, `:document_tep` e `:document_tso` passaram a reutilizar esses traits.
- A alteração foi necessária para reduzir duplicação e deixar mais claro quais documentos carregam payloads específicos de request.
- Observação importante: os nomes públicos das factories de documentos foram preservados, incluindo `:document`, `:document_tco`, `:document_tcai`, `:document_tdo`, `:document_tep`, `:document_tso` e `:document_adpp`.

## Review Notes

Revise especialmente:

- se `create(:responsible)`, `create(:coordinator)` e `create(:professor_tcc_one)` continuam associando o professor novo ao role correto quando o role já existe;
- se os identifiers dos document types continuam equivalentes;
- se documentos TDO, TEP e TSO continuam gerando o mesmo payload de `request`, assinaturas e conteúdo JSON esperado;
- se a suíte completa passa com `./run rspec spec`;
- se o RuboCop passa para os três arquivos alterados.

Não houve alteração de specs, remoção de factories públicas, commit, push ou Pull Request.