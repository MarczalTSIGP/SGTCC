# Task

Deduplicar os specs de documentos por perfil e tipo, começando pelos `documents_show_spec.rb` e `documents_sign_spec.rb` de `academics`, `professors` e `external_members`.

# Contexto

A etapa de divisão de specs grandes e com responsabilidades misturadas foi concluída.

O principal problema restante agora não é mais divisão de arquivos grandes, mas sim duplicação entre specs parecidos.

O grupo mais claro e seguro para começar a deduplicação é o dos specs de documentos por perfil e tipo.

Esses specs repetem a mesma estrutura geral, mudando principalmente:

- perfil autenticado;
- rota usada;
- tipo de documento;
- usuário que assina;
- permissões;
- mensagens esperadas;
- estado do documento, como pendente ou assinado.

Arquivos prioritários:

- `spec/features/academics/documents/term_of_commitment/documents_show_spec.rb`
- `spec/features/academics/documents/term_of_commitment/documents_sign_spec.rb`
- `spec/features/academics/documents/term_of_accept_institution/documents_show_spec.rb`
- `spec/features/academics/documents/term_of_accept_institution/documents_sign_spec.rb`
- `spec/features/professors/documents/term_of_commitment/documents_show_spec.rb`
- `spec/features/professors/documents/term_of_commitment/documents_sign_spec.rb`
- `spec/features/professors/documents/term_of_accept_institution/documents_show_spec.rb`
- `spec/features/professors/documents/term_of_accept_institution/documents_sign_spec.rb`
- `spec/features/external_members/documents/term_of_commitment/documents_show_spec.rb`
- `spec/features/external_members/documents/term_of_commitment/documents_sign_spec.rb`
- `spec/features/external_members/documents/term_of_accept_institution/documents_show_spec.rb`
- `spec/features/external_members/documents/term_of_accept_institution/documents_sign_spec.rb`

# Objetivo

Reduzir duplicação entre os specs de documentos, mantendo exatamente o mesmo comportamento testado.

A task deve melhorar:

- manutenção dos specs;
- clareza dos cenários;
- reaproveitamento de expectativas comuns;
- redução de setup repetido;
- consistência entre perfis e tipos de documento;
- facilidade para adicionar novos testes de documentos no futuro.

Esta task deve focar apenas nos specs de documentos listados acima.

# Instrução crítica

Esta task deve alterar apenas specs e suporte de teste relacionado a documentos.

Não altere código de produção.

Não altere:

- `app/`;
- `config/`;
- `db/`;
- `lib/`;
- `spec/models/`;
- `spec/controllers/`;
- `spec/requests/`;
- `spec/factories/`;
- specs fora do escopo permitido.

Não corrija bugs de produção.

Não mude regras de negócio.

Não mude rotas.

Não altere controllers, views, helpers, models ou services.

Não atualize dependências.

Não faça commit.

Não faça push.

Não abra Pull Request.

As alterações devem ficar apenas no working tree para revisão manual.

# Regra crítica contra correções oportunistas

Esta task deve apenas deduplicar e reorganizar testes existentes.

Não corrija expectativas.
Não corrija iteradores.
Não corrija matchers.
Não corrija cenários aparentemente incorretos.
Não altere lógica dos testes.
Não altere dados de setup para “melhorar” o teste.
Não transforme um teste frágil em outro teste diferente.

Se encontrar um teste aparentemente incorreto, frágil, duplicado, mal escrito ou com problema de matcher/iteração, registre no relatório final como pendência separada.

A prioridade é preservar o mesmo comportamento e a mesma cobertura, apenas reduzindo duplicação.

# Escopo permitido

Você pode alterar os seguintes arquivos:

- `spec/features/academics/documents/term_of_commitment/documents_show_spec.rb`
- `spec/features/academics/documents/term_of_commitment/documents_sign_spec.rb`
- `spec/features/academics/documents/term_of_accept_institution/documents_show_spec.rb`
- `spec/features/academics/documents/term_of_accept_institution/documents_sign_spec.rb`
- `spec/features/professors/documents/term_of_commitment/documents_show_spec.rb`
- `spec/features/professors/documents/term_of_commitment/documents_sign_spec.rb`
- `spec/features/professors/documents/term_of_accept_institution/documents_show_spec.rb`
- `spec/features/professors/documents/term_of_accept_institution/documents_sign_spec.rb`
- `spec/features/external_members/documents/term_of_commitment/documents_show_spec.rb`
- `spec/features/external_members/documents/term_of_commitment/documents_sign_spec.rb`
- `spec/features/external_members/documents/term_of_accept_institution/documents_show_spec.rb`
- `spec/features/external_members/documents/term_of_accept_institution/documents_sign_spec.rb`

Você também pode criar ou alterar arquivos de suporte somente se forem específicos para deduplicação desses specs de documentos, preferencialmente seguindo o padrão já existente no projeto.

Antes de criar suporte novo, verifique se o projeto já possui convenção em:

- `spec/support/`
- `spec/support/shared_examples/`
- `spec/features/support/`, se existir;
- outros arquivos de shared examples já existentes.

Se o projeto já tiver padrão de shared examples, siga esse padrão.

Se `spec/support/**/*.rb` não for carregado automaticamente pelo projeto, não altere `rails_helper.rb` ou `spec_helper.rb` nesta task. Nesse caso, prefira deduplicação local nos próprios specs afetados e registre no relatório final que a extração global ficou para uma task posterior.

# Escopo proibido

Não altere:

- `spec/factories/`;
- `rails_helper.rb`;
- `spec_helper.rb`;
- código de produção;
- specs fora dos 12 arquivos listados;
- shared examples não relacionados a documentos.

Não altere arquivos globais de configuração de teste.

Se algum ajuste global parecer necessário, não faça nesta task. Apenas registre no relatório final.

# Ordem de prioridade

Siga esta ordem:

1. Inspecionar os 12 specs de documentos.
2. Mapear duplicações entre `documents_show_spec.rb`.
3. Mapear duplicações entre `documents_sign_spec.rb`.
4. Deduplicar primeiro os fluxos de `show`.
5. Deduplicar depois os fluxos de `sign`.
6. Manter diferenças específicas de perfil e tipo de documento explícitas e fáceis de entender.
7. Rodar RSpec e RuboCop nos arquivos afetados.

# Regra de comparação antes/depois

Antes de alterar cada arquivo, registre internamente:

- quantidade de exemplos existentes;
- nomes dos `describe`, `context`, `it` ou `scenario`;
- principais fluxos cobertos;
- expectativas relevantes;
- setup específico do perfil;
- setup específico do tipo de documento.

Após a deduplicação, confirme que:

- a quantidade de exemplos foi preservada;
- os mesmos cenários continuam presentes;
- nenhuma expectativa relevante foi removida;
- nenhum cenário teve sua intenção alterada;
- cada spec continua rodando isoladamente;
- as diferenças entre perfis continuam explícitas.

No relatório final, inclua um resumo da comparação antes/depois para cada grupo de arquivos.

Exemplo esperado no relatório:

- `academics/term_of_commitment/documents_show_spec.rb`
  - Antes: X exemplos.
  - Depois: X exemplos.
  - Cenários preservados: sim.
  - Deduplicação aplicada: shared example/local helper/etc.
  - Observações: nenhuma expectativa removida.

# Estratégia de deduplicação

A deduplicação deve ser conservadora.

Prefira extrair apenas padrões claramente repetidos, como:

- visualização de documento permitido;
- visualização de documento pendente;
- visualização de documento assinado;
- acesso não autorizado, se repetido;
- botão de assinatura;
- preenchimento de credenciais;
- assinatura com sucesso;
- assinatura com senha inválida;
- redirecionamento após assinatura;
- mensagens comuns de sucesso ou erro;
- conteúdo comum esperado na página.

Não esconda diferenças importantes em abstrações difíceis de ler.

Não transforme os specs em uma estrutura excessivamente genérica.

Não crie metaprogramação complexa.

Não use loops grandes para gerar cenários se isso prejudicar legibilidade ou dificultar o diagnóstico de falhas.

Evite `each` para gerar muitos exemplos, a menos que o padrão já exista no projeto e a falha continue fácil de identificar.

Se usar shared examples, eles devem ter nomes claros, como:

- `shared_examples "document show page"`
- `shared_examples "document signature flow"`
- `shared_examples "unauthorized document access"`

Os nomes finais devem seguir o idioma e o padrão já usados no projeto.

# Regras para `documents_show_spec.rb`

Os specs de show costumam repetir:

- criação de orientação;
- criação do documento;
- login do usuário correto;
- visita à página do documento;
- conteúdo esperado do documento;
- estado pendente ou assinado;
- permissão de acesso;
- redirecionamento quando não autorizado.

Deduplicate apenas o que for realmente comum.

Mantenha explícito no spec:

- perfil testado;
- tipo de documento;
- rota usada;
- usuário autenticado;
- expectativa específica daquele perfil ou documento.

# Regras para `documents_sign_spec.rb`

Os specs de assinatura costumam repetir:

- login do usuário correto;
- visita à página de assinatura;
- clique no botão de assinatura;
- preenchimento de usuário/senha;
- sucesso na assinatura;
- erro de senha inválida;
- mudança de status da assinatura;
- mensagens de sucesso ou erro.

Deduplicate apenas o fluxo comum.

Mantenha explícito no spec:

- quem está assinando;
- qual tipo de documento está sendo assinado;
- qual rota é usada;
- quais credenciais são usadas;
- qual mensagem é esperada;
- qual efeito no documento/assinatura é esperado.

# Regras de implementação

Preserve o comportamento dos testes existentes.

Não remova cenários sem justificativa clara.

Não simplifique expectativas se isso reduzir cobertura.

Não altere a intenção dos testes.

Não altere setup de dados sem necessidade.

Não altere factories.

Não altere código de produção.

Não tente deduplicar agressivamente.

Não introduza abstrações difíceis de entender.

Não crie shared examples genéricos demais.

Não use nomes ambíguos.

Não altere `rails_helper.rb` ou `spec_helper.rb`.

Cada arquivo de spec afetado deve continuar podendo rodar individualmente.

Se um spec ficar menos legível após a extração, prefira manter duplicação local.

# Regra sobre nomes de arquivos

Se criar arquivos de suporte, use nomes em `snake_case`.

Os nomes devem indicar claramente que o suporte pertence a documentos.

Exemplos aceitáveis, se seguirem o padrão do projeto:

- `document_show_examples.rb`
- `document_sign_examples.rb`
- `document_signature_examples.rb`
- `document_access_examples.rb`

Evite nomes genéricos como:

- `shared_examples.rb`
- `helpers.rb`
- `common.rb`
- `utils.rb`

Se o projeto já tiver outro padrão de nomes, siga o padrão existente.

# Testes esperados

Após a deduplicação, rode os testes diretamente afetados usando o padrão do projeto.

Comando principal esperado:

```bash
./run rspec \
  spec/features/academics/documents \
  spec/features/professors/documents \
  spec/features/external_members/documents
```

Também rode RuboCop nos arquivos/pastas afetados:

```bash
./run rubocop \
  spec/features/academics/documents \
  spec/features/professors/documents \
  spec/features/external_members/documents
```

Se arquivos em `spec/support/` forem criados ou alterados, inclua também esses arquivos no RuboCop:

```bash
./run rubocop \
  spec/features/academics/documents \
  spec/features/professors/documents \
  spec/features/external_members/documents \
  spec/support
```

Se o comando completo de RSpec for muito demorado ou falhar por problema de ambiente, rode os arquivos/pastas menores afetados e explique no relatório final.

Se o RuboCop apontar apenas problemas nos arquivos alterados por esta task, corrija esses problemas.

Se o RuboCop apontar problemas antigos fora do escopo da task, não corrija nesta task. Apenas registre no relatório final.

Se algum teste falhar, investigue se a falha foi causada pela deduplicação.

Corrija apenas problemas nos arquivos de spec ou suporte alterados quando a correção for estritamente necessária para manter o mesmo comportamento após a deduplicação.

Não corrija código de produção nesta task.

# Critérios de aceite

A task será considerada concluída se:

- os 12 specs de documentos forem analisados;
- duplicações claras entre `documents_show_spec.rb` forem reduzidas com segurança;
- duplicações claras entre `documents_sign_spec.rb` forem reduzidas com segurança;
- diferenças entre perfis e tipos de documento continuarem explícitas;
- a quantidade de exemplos e cenários for preservada;
- nenhum código de produção for alterado;
- `spec/factories`, `rails_helper.rb` e `spec_helper.rb` não forem alterados;
- nenhum spec fora do escopo for alterado;
- cada arquivo afetado continuar rodando individualmente;
- os testes afetados forem executados ou a impossibilidade for explicada claramente;
- o RuboCop for executado nas pastas afetadas ou a impossibilidade for explicada claramente;
- problemas encontrados em expectativas, iteradores, matchers ou cenários aparentemente incorretos forem registrados como pendência em vez de corrigidos oportunisticamente.

# Relatório final esperado

No relatório final, inclua:

## Resumo

Explique quais duplicações foram reduzidas e por quê.

## Comparação antes/depois

Para cada grupo de arquivos, informe:

- quantidade de exemplos antes;
- quantidade de exemplos depois;
- cenários preservados;
- diferenças específicas mantidas;
- estratégia de deduplicação usada.

## Arquivos alterados

Liste os arquivos de spec alterados.

## Arquivos de suporte criados ou alterados

Liste arquivos de suporte criados/alterados, se houver.

Se nenhum suporte novo foi criado, informe isso.

## Duplicações reduzidas

Liste as duplicações removidas ou centralizadas.

## O que foi mantido duplicado

Liste duplicações que foram mantidas por segurança ou legibilidade.

## Pendências encontradas

Liste problemas encontrados que não foram corrigidos por estarem fora do escopo, especialmente:

- expectativas suspeitas;
- iteradores ou blocos `.each` problemáticos;
- matchers frágeis;
- cenários aparentemente incorretos;
- necessidade futura de shared examples adicionais;
- necessidade futura de helper ou suporte global.

## O que ficou para depois

Liste possíveis próximas tasks, como:

- deduplicar specs de bancas show;
- deduplicar specs de atividades show entre perfis;
- deduplicar specs de orientação/supervisão show;
- deduplicar CRUDs do responsible.

## Testes executados

Liste os comandos executados e o resultado.

Inclua o resultado do RSpec.

## RuboCop executado

Liste o comando executado e o resultado.

Se algum comando não foi executado, explique o motivo.

# Observação final

Esta task não deve criar commit automaticamente.

As alterações devem ficar apenas no working tree para revisão manual com:

```bash
git status
git diff
```
