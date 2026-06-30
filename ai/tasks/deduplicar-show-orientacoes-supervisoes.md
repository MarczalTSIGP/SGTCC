# Task

Deduplicar os specs de show de orientações e supervisões entre perfis, mantendo o mesmo comportamento testado e sem alterar código de produção.

# Contexto

As etapas anteriores de refatoração e deduplicação já foram concluídas para:

- specs grandes de models;
- specs grandes/misturados de features;
- specs de documentos por perfil/tipo;
- specs de show de bancas.

O próximo grupo com duplicação clara está nos specs de show de orientações e supervisões.

Esses arquivos possuem cenários muito parecidos entre perfis, especialmente para:

- informações básicas;
- TCC I;
- TCC II;
- dados da orientação/supervisão;
- dados do acadêmico;
- dados do orientador/supervisor;
- documentos;
- atividades;
- reuniões;
- bancas;
- ações disponíveis;
- permissões de visualização.

Arquivos prioritários:

- `spec/features/professors/orientations/orientations_show_basic_information_spec.rb`
- `spec/features/professors/orientations/orientations_show_tcc_one_spec.rb`
- `spec/features/professors/orientations/orientations_show_tcc_two_spec.rb`
- `spec/features/professors/supervisions/supervisions_show_basic_information_spec.rb`
- `spec/features/professors/supervisions/supervisions_show_tcc_one_spec.rb`
- `spec/features/professors/supervisions/supervisions_show_tcc_two_spec.rb`
- `spec/features/external_members/supervisions/supervisions_show_basic_information_spec.rb`
- `spec/features/external_members/supervisions/supervisions_show_tcc_one_spec.rb`
- `spec/features/external_members/supervisions/supervisions_show_tcc_two_spec.rb`
- `spec/features/tcc_one_professors/orientations/orientations_show_spec.rb`

# Objetivo

Reduzir duplicação entre os specs de show de orientações e supervisões, mantendo os cenários existentes e preservando as diferenças específicas de cada perfil.

A task deve melhorar:

- manutenção dos specs;
- consistência entre perfis;
- clareza dos cenários de show;
- reaproveitamento de expectativas comuns;
- redução de setup repetido;
- facilidade para evoluir as telas de orientação e supervisão no futuro.

Esta task NÃO deve alterar comportamento dos testes.

Esta task NÃO deve alterar código de produção.

# Instrução crítica

Esta task deve apenas deduplicar e reorganizar testes existentes.

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

Esta task deve apenas deduplicar e reorganizar exemplos.

Não corrija expectativas.
Não corrija iteradores.
Não corrija matchers.
Não corrija cenários aparentemente incorretos.
Não altere lógica dos testes.
Não altere dados de setup para “melhorar” o teste.
Não transforme um teste frágil em outro teste diferente.
Não remova expectativas para facilitar a deduplicação.

Se encontrar um teste aparentemente incorreto, frágil, duplicado, mal escrito ou com problema de matcher/iteração, registre no relatório final como pendência separada.

A prioridade é preservar o mesmo comportamento e a mesma cobertura, apenas reduzindo duplicação.

# Escopo permitido

Você pode alterar arquivos apenas dentro destas pastas:

- `spec/features/professors/orientations/`
- `spec/features/professors/supervisions/`
- `spec/features/external_members/supervisions/`
- `spec/features/tcc_one_professors/orientations/`

Você também pode criar ou alterar arquivos de suporte somente se forem específicos para deduplicação dos specs de show de orientações/supervisões.

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
- specs fora dos diretórios permitidos;
- shared examples não relacionados a show de orientações/supervisões;
- suporte global genérico demais.

Não altere arquivos globais de configuração de teste.

Se algum ajuste global parecer necessário, não faça nesta task. Apenas registre no relatório final.

# Ordem de prioridade

Siga esta ordem:

1. Inspecionar os specs de `orientations_show_basic_information_spec.rb` e `supervisions_show_basic_information_spec.rb`.
2. Mapear duplicações claras de setup, login, visita à página e expectativas comuns.
3. Deduplicar primeiro os fluxos de informações básicas.
4. Inspecionar os specs de `orientations_show_tcc_one_spec.rb` e `supervisions_show_tcc_one_spec.rb`.
5. Deduplicar apenas duplicações claras de TCC I.
6. Inspecionar os specs de `orientations_show_tcc_two_spec.rb` e `supervisions_show_tcc_two_spec.rb`.
7. Deduplicar apenas duplicações claras de TCC II.
8. Analisar `spec/features/tcc_one_professors/orientations/orientations_show_spec.rb`.
9. Se esse arquivo ainda misturar responsabilidades, deduplicar apenas o que for seguro sem criar uma refatoração grande de divisão.
10. Manter diferenças específicas de perfil explícitas.
11. Rodar RSpec e RuboCop nos arquivos afetados.

Se a task ficar grande demais, priorize somente os arquivos de `basic_information` e registre no relatório final o que ficou para depois.

# Arquivos prioritários

## Basic information

- `spec/features/professors/orientations/orientations_show_basic_information_spec.rb`
- `spec/features/professors/supervisions/supervisions_show_basic_information_spec.rb`
- `spec/features/external_members/supervisions/supervisions_show_basic_information_spec.rb`

## TCC I

- `spec/features/professors/orientations/orientations_show_tcc_one_spec.rb`
- `spec/features/professors/supervisions/supervisions_show_tcc_one_spec.rb`
- `spec/features/external_members/supervisions/supervisions_show_tcc_one_spec.rb`

## TCC II

- `spec/features/professors/orientations/orientations_show_tcc_two_spec.rb`
- `spec/features/professors/supervisions/supervisions_show_tcc_two_spec.rb`
- `spec/features/external_members/supervisions/supervisions_show_tcc_two_spec.rb`

## TCC One Professors

- `spec/features/tcc_one_professors/orientations/orientations_show_spec.rb`

# Regra de comparação antes/depois

Antes de alterar cada grupo de arquivos, registre internamente:

- quantidade de exemplos existentes por arquivo;
- nomes dos `describe`, `context`, `it` ou `scenario`;
- principais fluxos cobertos;
- expectativas relevantes;
- setup específico do perfil;
- diferenças específicas entre perfis.

Após a deduplicação, confirme que:

- a quantidade de exemplos foi preservada;
- os mesmos cenários continuam presentes;
- nenhuma expectativa relevante foi removida;
- nenhum cenário teve sua intenção alterada;
- cada spec continua rodando isoladamente;
- as diferenças entre perfis continuam explícitas.

No relatório final, inclua um resumo da comparação antes/depois para cada grupo de arquivos.

Exemplo esperado no relatório:

- `orientations/supervisions show basic information`
  - Antes: X exemplos distribuídos entre Y arquivos.
  - Depois: X exemplos distribuídos entre Y arquivos.
  - Cenários preservados: sim.
  - Deduplicação aplicada: shared example/local helper/etc.
  - Observações: nenhuma expectativa removida.

# Estratégia de deduplicação

A deduplicação deve ser conservadora.

Prefira extrair apenas padrões claramente repetidos, como:

- login do perfil correto;
- criação de orientação;
- criação de supervisão;
- criação de acadêmico;
- criação de professor/orientador/supervisor;
- visita à página de show;
- expectativas comuns de informações básicas;
- expectativas comuns de TCC I;
- expectativas comuns de TCC II;
- expectativas comuns de documentos;
- expectativas comuns de atividades;
- expectativas comuns de reuniões;
- expectativas comuns de bancas;
- ausência/presença de seções comuns;
- mensagens ou textos comuns da página.

Não esconda diferenças importantes em abstrações difíceis de ler.

Não transforme os specs em uma estrutura excessivamente genérica.

Não crie metaprogramação complexa.

Não use loops grandes para gerar cenários se isso prejudicar legibilidade ou dificultar o diagnóstico de falhas.

Evite `each` para gerar muitos exemplos, a menos que o padrão já exista no projeto e a falha continue fácil de identificar.

Se usar shared examples, eles devem ter nomes claros, por exemplo:

- `shared_examples "orientation show basic information"`
- `shared_examples "supervision show basic information"`
- `shared_examples "tcc one show information"`
- `shared_examples "tcc two show information"`

Os nomes finais devem seguir o idioma e o padrão já usados no projeto.

# Regras específicas por grupo

## Basic information

Os specs de basic information podem repetir:

- dados da orientação/supervisão;
- título;
- dados do acadêmico;
- dados do orientador/supervisor;
- situação/status;
- ano/semestre;
- TCC I/TCC II;
- links principais;
- seções comuns da página.

Deduplicate apenas o que for realmente comum.

Mantenha explícito no spec:

- perfil autenticado;
- rota usada;
- permissão esperada;
- diferenças de visualização entre perfis;
- qualquer expectativa específica do perfil.

## TCC I

Os specs de TCC I podem repetir:

- orientação ou supervisão de TCC I;
- calendário de TCC I;
- atividades de TCC I;
- documentos esperados;
- banca/proposta, se aplicável;
- links ou ações específicas.

Deduplicate apenas o fluxo comum.

Mantenha explícito no spec:

- quem acessa;
- se é orientação ou supervisão;
- quais informações de TCC I devem aparecer;
- quais diferenças existem por perfil.

## TCC II

Os specs de TCC II podem repetir:

- orientação ou supervisão de TCC II;
- calendário de TCC II;
- atividades de TCC II;
- documentos esperados;
- banca/projeto/monografia, se aplicável;
- links ou ações específicas.

Deduplicate apenas o fluxo comum.

Mantenha explícito no spec:

- quem acessa;
- se é orientação ou supervisão;
- quais informações de TCC II devem aparecer;
- quais diferenças existem por perfil.

## TCC One Professors

O arquivo `spec/features/tcc_one_professors/orientations/orientations_show_spec.rb` pode ainda estar menos dividido do que os demais.

Nesta task, não transforme esse arquivo em uma grande refatoração de divisão se isso aumentar demais o escopo.

Faça apenas deduplicações seguras com os padrões já extraídos, quando isso for simples e preservar legibilidade.

Se a divisão desse arquivo for necessária antes da deduplicação, registre como pendência para uma task separada.

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

Os nomes devem indicar claramente que o suporte pertence a show de orientações/supervisões.

Exemplos aceitáveis, se seguirem o padrão do projeto:

- `orientation_show_examples.rb`
- `supervision_show_examples.rb`
- `orientation_supervision_show_examples.rb`
- `tcc_show_examples.rb`

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
  spec/features/professors/orientations \
  spec/features/professors/supervisions \
  spec/features/external_members/supervisions \
  spec/features/tcc_one_professors/orientations
```

Também rode RuboCop nos arquivos/pastas afetados:

```bash
./run rubocop \
  spec/features/professors/orientations \
  spec/features/professors/supervisions \
  spec/features/external_members/supervisions \
  spec/features/tcc_one_professors/orientations
```

Se arquivos em `spec/support/` forem criados ou alterados, inclua também esses arquivos no RuboCop:

```bash
./run rubocop \
  spec/features/professors/orientations \
  spec/features/professors/supervisions \
  spec/features/external_members/supervisions \
  spec/features/tcc_one_professors/orientations \
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

- os specs de show de orientações/supervisões forem analisados entre os perfis;
- duplicações claras de basic information forem reduzidas com segurança;
- duplicações claras de TCC I forem reduzidas com segurança, se fizer sentido;
- duplicações claras de TCC II forem reduzidas com segurança, se fizer sentido;
- diferenças entre perfis continuarem explícitas;
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

- deduplicar activities show entre perfis;
- deduplicar orientations_activities_show entre perfis;
- deduplicar documents_show de supervisões/orientações;
- deduplicar create de bancas;
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
