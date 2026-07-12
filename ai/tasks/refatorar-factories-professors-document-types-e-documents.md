# Task

Refatorar internamente as factories `professors.rb`, `document_types.rb` e `documents.rb`, preservando os nomes públicos das factories e garantindo que a suíte termine verde.

# Contexto

Estamos na Task 4 do plano de refatoração das factories do SGTCC.

As tasks anteriores já foram concluídas:

- Task 1: `calendars.rb`;
- Task 2: `base_activities.rb` + `activities.rb`;
- Task 3: `academic_activities.rb` + `signatures.rb`.

Agora o foco é refatorar:

- `spec/factories/professors.rb`;
- `spec/factories/document_types.rb`;
- `spec/factories/documents.rb`.

Essas três factories foram agrupadas porque não devem mudar os nomes usados pelos testes.

Ou seja:

- os nomes públicos das factories devem permanecer os mesmos;
- os specs não devem ser migrados para novos nomes;
- o objetivo é limpar implementação interna, reduzir duplicação e melhorar clareza;
- qualquer alteração deve preservar o comportamento atual das factories.

Volume de referências estimado:

- `professors.rb`: aproximadamente 139 referências;
- `document_types.rb`: aproximadamente 52 referências;
- `documents.rb`: aproximadamente 25 referências.

Apesar do volume alto, o risco deve ser menor porque os nomes das factories permanecem iguais.

# Objetivo

Refatorar internamente as factories `professors.rb`, `document_types.rb` e `documents.rb`, preservando o comportamento atual e os nomes públicos existentes.

A task deve melhorar:

- clareza das factories;
- redução de duplicação interna;
- menor acoplamento entre factories;
- setup mais explícito;
- manutenção futura;
- legibilidade dos callbacks;
- previsibilidade dos dados criados.

Esta task NÃO deve atualizar specs apenas para mudar nomes de factories, porque os nomes públicos devem continuar iguais.

# Instrução crítica

Esta task deve alterar apenas:

- `spec/factories/professors.rb`;
- `spec/factories/document_types.rb`;
- `spec/factories/documents.rb`.

A princípio, nenhum spec deve ser alterado.

Se algum spec quebrar após a refatoração, primeiro tente preservar o comportamento anterior da factory.

Alterar spec deve ser último recurso e precisa de justificativa forte no relatório final.

Não altere código de produção.

Não altere:

- `app/`;
- `config/`;
- `db/`;
- `lib/`;
- outras factories, exceto se houver dependência direta e inevitável;
- regras de negócio;
- models;
- controllers;
- services;
- views;
- migrations.

Não faça commit.

Não faça push.

Não abra Pull Request.

As alterações devem ficar apenas no working tree para revisão manual.

# Escopo permitido

Você pode alterar:

- `spec/factories/professors.rb`;
- `spec/factories/document_types.rb`;
- `spec/factories/documents.rb`.

Você só pode alterar specs se:

- a alteração for indispensável;
- não for possível preservar o comportamento anterior ajustando a factory;
- o motivo for explicado no relatório final;
- a alteração não mudar a intenção do teste.

# Escopo proibido

Não altere:

- código de produção;
- specs sem necessidade;
- outras factories sem necessidade direta;
- `rails_helper.rb`;
- `spec_helper.rb`;
- configurações globais;
- migrations;
- schema;
- arquivos fora de `spec/`.

Se encontrar problema fora do escopo, registre no relatório final como pendência.

# Regra crítica contra renomeação

Nesta task, os nomes públicos das factories devem ser preservados.

Não remova factories usadas nos testes.

Não renomeie factories.

Não force migração de specs para novos nomes.

Não introduza aliases temporários para substituir nomes antigos, porque esta task não é uma migração de API pública.

Se alguma factory antiga estiver claramente morta, não remova automaticamente. Primeiro confirme que não existe uso. Se remover, explique no relatório final.

# Regra crítica contra correções oportunistas

Esta task deve apenas refatorar a implementação interna das factories.

Não corrija expectativas.
Não corrija iteradores.
Não corrija matchers.
Não corrija cenários aparentemente incorretos.
Não altere lógica dos testes.
Não altere dados de setup para “melhorar” o teste, exceto quando for necessário para preservar comportamento equivalente da factory.
Não remova cenários.
Não reduza cobertura.

Se encontrar um teste aparentemente incorreto, frágil ou mal escrito, registre no relatório final como pendência separada.

# Estratégia obrigatória

Antes de alterar, faça um inventário das factories atuais.

Identifique em `spec/factories/professors.rb`:

- nomes de factories existentes;
- traits já existentes, se houver;
- atributos padrão;
- callbacks;
- uso de `after(:create)`;
- duplicações internas;
- associações;
- factories aninhadas;
- roles criados ou associados;
- nomes públicos que precisam ser preservados.

Identifique em `spec/factories/document_types.rb`:

- nomes de factories existentes;
- atributos padrão;
- valores de identificador ou tipo;
- factories específicas existentes;
- duplicações internas;
- uso de `create`, `find_or_create_by`, `initialize_with` ou equivalentes;
- nomes públicos que precisam ser preservados.

Identifique em `spec/factories/documents.rb`:

- nomes de factories existentes;
- traits já existentes, se houver;
- atributos padrão;
- associações com `document_type`, `orientation`, `academic`, `professor`, `external_member` ou equivalentes;
- callbacks;
- uso de `before(:create)` ou `after(:create)`;
- criação de responsáveis/coordenadores;
- criação de assinaturas;
- geração de conteúdo JSON;
- acoplamentos com outras factories;
- nomes públicos que precisam ser preservados.

Depois, refatore apenas o necessário.

# Parte 1 — `professors.rb`

Objetivo específico:

- simplificar duplicação interna;
- melhorar clareza do setup;
- reduzir repetição em callbacks;
- preservar todos os nomes públicos das factories.

Factories de papel que devem continuar funcionando:

- `:responsible`;
- `:coordinator`;
- `:professor_tcc_one`.

Essas factories precisam continuar retornando um `Professor` com o respectivo role associado.

Ao refatorar `:responsible`, `:coordinator` e `:professor_tcc_one`, garanta que a factory sempre associe o professor ao role correspondente.

Se o role já existir, reaproveite o role existente e associe ao professor novo.

Se o role ainda não existir, crie o role e associe ao professor novo.

Atenção ao comportamento perigoso atual: não basta criar ou encontrar o role. É necessário garantir que o professor criado esteja associado a ele.

Exemplo de intenção esperada:

- `create(:responsible)` deve criar um professor com role de responsável;
- `create(:coordinator)` deve criar um professor com role de coordenador;
- `create(:professor_tcc_one)` deve criar um professor com role de professor de TCC I.

Pode usar traits somente se isso simplificar a implementação sem mudar a API pública.

Não remova factories antigas usadas em specs.

Não altere comportamento esperado das factories.

Exemplos de melhorias aceitáveis:

- centralizar atributos comuns na factory principal;
- mover variações para traits internas;
- reduzir callbacks duplicados;
- deixar associações mais explícitas;
- usar `transient` apenas se já fizer sentido no padrão atual;
- manter nomes antigos como factories públicas, se eles já existirem.

Não crie abstrações complexas.

# Parte 2 — `document_types.rb`

Objetivo específico:

- limpar estrutura interna;
- reduzir duplicação de atributos;
- preservar todos os nomes públicos das factories;
- manter identificadores e tipos exatamente como estão hoje.

Cuidado especial:

- `document_type` costuma ser usado para regras de documentos e permissões;
- identifiers ou nomes de tipos podem ser sensíveis;
- não altere valores de domínio;
- não altere traduções ou nomes esperados pelos testes;
- não altere factories como `document_type_admg`, `document_type_tco`, `document_type_tcai` ou equivalentes se elas forem usadas.

Não troque `create` por `find_or_create_by` ou `initialize_with` sem justificar claramente.

Isso é importante porque `find_or_create_by`/`initialize_with` muda a semântica da factory e pode afetar specs que esperam criação real de registros.

Se houver motivação para usar `find_or_create_by`, explique no relatório final:

- qual problema real isso resolve;
- por que não altera o comportamento esperado dos testes;
- quais specs foram executados para validar;
- por que a semântica singleton é adequada para esse tipo específico.

Na dúvida, preserve a semântica atual de criação.

Exemplos de melhorias aceitáveis:

- centralizar atributos comuns na factory principal;
- usar traits para variações internas, mantendo factories públicas existentes;
- remover repetição de campos idênticos;
- melhorar clareza dos nomes internos.

Não remova nomes públicos.

# Parte 3 — `documents.rb`

Objetivo específico:

- reduzir acoplamento interno quando for seguro;
- limpar callbacks;
- preservar todos os nomes públicos das factories;
- evitar setup implícito difícil de entender, mas sem quebrar comportamento atual.

Cuidado especial:

- `documents.rb` pode depender de `document_types.rb`;
- alguns documentos dependem de orientação, banca, assinatura ou tipo;
- callbacks `before(:create)` podem estar criando dependências implícitas necessárias;
- hoje pode existir callback criando `:responsible` e `:coordinator`;
- esse acoplamento pode ser necessário por causa de callbacks de documentos, assinaturas ou geração de conteúdo JSON.

Se simplificar o callback de `documents.rb`, confirme que a criação de documentos continua gerando:

- assinaturas equivalentes;
- conteúdo JSON equivalente;
- responsáveis/coordenadores necessários;
- associações esperadas;
- status e dados esperados pelos specs.

Não remova o setup de `:responsible` e `:coordinator` apenas por parecer acoplado.

Primeiro confirme por testes que o comportamento equivalente foi preservado.

Se não for possível simplificar com segurança, mantenha o callback e registre como pendência futura.

Exemplos de melhorias aceitáveis:

- centralizar atributos comuns na factory principal;
- usar traits internas para tipos de documentos;
- preservar factories públicas existentes;
- reduzir callbacks duplicados;
- evitar criação desnecessária quando associação já foi passada explicitamente;
- respeitar atributos sobrescritos pelo teste.

Não altere comportamento público.

# Cuidados importantes

Estas factories são bastante usadas em specs.

Ao refatorar:

- preserve nomes públicos;
- preserve atributos padrão;
- preserve associações esperadas;
- preserve callbacks necessários;
- preserve valores de identificadores;
- preserve status e tipos;
- preserve comportamento quando atributos são sobrescritos nos testes;
- preserve criação de roles em professor factories;
- preserve geração de assinaturas e JSON em document factories;
- evite gerar conflitos de validação;
- não altere expectativas dos testes para se adaptar à factory.

# Regra sobre traits

Traits podem ser criadas ou reorganizadas somente para melhorar a implementação interna.

Mas os specs não devem ser migrados para uma nova API pública nesta task.

Use traits com cuidado.

Não crie traits sem base real no domínio.

Não crie traits apenas porque parecem úteis.

Se criar traits, eles devem representar variações reais já existentes nas factories atuais.

# Regra de comparação antes/depois

Antes da alteração, registre internamente:

- nomes públicos das factories em `professors.rb`;
- nomes públicos das factories em `document_types.rb`;
- nomes públicos das factories em `documents.rb`;
- comportamento principal de cada factory;
- callbacks existentes;
- associações importantes;
- roles associados;
- geração de assinaturas/conteúdo JSON;
- arquivos principais que dependem dessas factories.

Depois da alteração, confirme:

- os mesmos nomes públicos continuam disponíveis;
- specs não precisaram migrar nomes de factories;
- factories de papel continuam associando os roles corretamente;
- document types continuam com os mesmos identificadores/tipos;
- documents continuam gerando assinaturas e conteúdo JSON equivalentes;
- comportamento das factories foi preservado;
- a suíte passa.

No relatório final, inclua um resumo da comparação antes/depois.

# Verificações obrigatórias

Após a refatoração, verifique se os nomes públicos das factories ainda existem.

Procure por referências relevantes:

```bash
grep -R "create(:professor" spec
grep -R "build(:professor" spec
grep -R "create(:responsible" spec
grep -R "create(:coordinator" spec
grep -R "create(:professor_tcc_one" spec
grep -R "create(:document_type" spec
grep -R "build(:document_type" spec
grep -R "create(:document" spec
grep -R "build(:document" spec
```

Atenção: esses comandos podem retornar nomes legítimos, traits, arquivos ou métodos.

Use o resultado com cuidado para verificar impacto real.

Se algum nome público foi removido, explique no relatório final e justifique por que não havia uso.

# Testes esperados

Primeiro rode specs diretamente relacionados, usando caminhos existentes.

Possíveis comandos:

```bash
./run rspec \
  spec/models/professors \
  spec/models/document_types \
  spec/models/documents
```

Se algum desses caminhos não existir, rode os specs reais encontrados por busca relacionados a professor, document type e document.

Depois rode specs de features que dependem fortemente dessas factories:

```bash
./run rspec \
  spec/features/professors \
  spec/features/responsible/professors \
  spec/features/responsible/documents \
  spec/features/academics/documents \
  spec/features/professors/documents \
  spec/features/external_members/documents
```

Depois rode a suíte completa:

```bash
./run rspec spec
```

Também rode RuboCop nos arquivos afetados.

Comando mínimo esperado:

```bash
./run rubocop \
  spec/factories/professors.rb \
  spec/factories/document_types.rb \
  spec/factories/documents.rb
```

Se possível, rode RuboCop nos specs alterados também.

Não use caminhos inexistentes. Se algum caminho sugerido não existir, adapte para os caminhos reais encontrados e informe no relatório final.

# Critérios de aceite

A task será considerada concluída se:

- `spec/factories/professors.rb` for refatorado internamente sem mudar nomes públicos;
- `:responsible`, `:coordinator` e `:professor_tcc_one` continuarem associando corretamente o role esperado ao professor criado;
- roles existentes forem reaproveitados e associados ao professor novo quando já existirem;
- `spec/factories/document_types.rb` for refatorado internamente sem mudar nomes públicos;
- `document_types.rb` não trocar `create` por `find_or_create_by`/`initialize_with` sem justificativa clara;
- `spec/factories/documents.rb` for refatorado internamente sem mudar nomes públicos;
- documents continuarem gerando assinaturas e conteúdo JSON equivalentes;
- nenhum spec precisar ser migrado para novos nomes de factories;
- os nomes públicos existentes continuarem disponíveis, salvo remoção comprovadamente segura;
- os cenários dos testes forem preservados;
- nenhum código de produção for alterado;
- nenhuma regra de negócio for alterada;
- nenhuma outra factory for alterada sem necessidade direta;
- a suíte completa `./run rspec spec` for executada com sucesso ou a impossibilidade for explicada claramente;
- RuboCop for executado nos arquivos afetados;
- pendências fora do escopo forem registradas no relatório final.

# Relatório final esperado

No relatório final, inclua:

## Resumo

Explique a refatoração interna feita em:

- `professors.rb`;
- `document_types.rb`;
- `documents.rb`.

## Nomes públicos preservados

Liste as factories públicas mantidas.

## Professors e roles

Explique:

- como `:responsible`, `:coordinator` e `:professor_tcc_one` foram preservadas;
- como roles existentes são reaproveitados;
- como o professor novo é associado ao role correto.

## Document types

Explique:

- se houve mudança estrutural;
- se `find_or_create_by` ou `initialize_with` foi usado;
- se foi usado, justifique claramente;
- se não foi usado, informe que a semântica de criação foi preservada.

## Documents

Explique:

- callbacks mantidos, simplificados ou reorganizados;
- como a criação de responsáveis/coordenadores foi tratada;
- como foi validado que assinaturas e conteúdo JSON continuam equivalentes.

## Mudanças internas

Explique:

- callbacks simplificados;
- traits criadas ou reorganizadas;
- duplicações removidas;
- acoplamentos reduzidos;
- ajustes em associações.

## Specs alterados

Informe se algum spec foi alterado.

Se nenhum spec foi alterado, diga explicitamente.

Se algum spec foi alterado, justifique fortemente por que não foi possível preservar o comportamento apenas pela factory.

## Factories antigas removidas

Se alguma factory foi removida, explique:

- nome removido;
- motivo;
- confirmação de que não havia referência.

## Testes executados

Liste os comandos executados e o resultado.

Inclua obrigatoriamente o resultado de:

```bash
./run rspec spec
```

ou explique por que não foi possível executar.

## RuboCop executado

Liste os comandos executados e o resultado.

## Pendências encontradas

Liste problemas encontrados que não foram corrigidos por estarem fora do escopo.

# Observação final

Esta task não deve criar commit automaticamente.

As alterações devem ficar apenas no working tree para revisão manual com:

```bash
git status
git diff
```
