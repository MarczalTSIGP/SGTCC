# Task

Deduplicar os specs de visualização de bancas (`examination_boards_show_*`) entre diferentes perfis, mantendo o mesmo comportamento testado e sem alterar código de produção.

# Contexto

A etapa de divisão dos specs grandes e com responsabilidades misturadas já foi concluída.

Depois da deduplicação dos specs de documentos, o próximo grupo prioritário de duplicação está nos specs de show de bancas.

Há forte repetição entre perfis nos specs de:

- informações básicas da banca;
- apontamentos;
- atividade acadêmica.

Os principais arquivos envolvidos são:

- `spec/features/academics/examination_boards/examination_boards_show_basic_information_spec.rb`
- `spec/features/professors/examination_boards/examination_boards_show_basic_information_spec.rb`
- `spec/features/responsible/examination_boards/examination_boards_show_basic_information_spec.rb`
- `spec/features/tcc_one_professors/examination_boards/examination_boards_show_basic_information_spec.rb`
- `spec/features/external_members/examination_boards/examination_boards_show_basic_information_spec.rb`

Também existem duplicações nos equivalentes:

- `examination_boards_show_appointments_spec.rb`
- `examination_boards_show_academic_activity_spec.rb`

Esta task deve focar somente na deduplicação dos specs de bancas.

# Objetivo

Reduzir duplicação entre os specs de visualização de bancas, mantendo os cenários existentes e preservando as diferenças específicas de cada perfil.

A task deve melhorar:

- manutenção dos specs;
- consistência entre perfis;
- clareza dos cenários de show de banca;
- reaproveitamento de expectativas comuns;
- redução de setup repetido;
- facilidade para alterar a tela de banca no futuro.

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

- `spec/features/academics/examination_boards/`
- `spec/features/professors/examination_boards/`
- `spec/features/responsible/examination_boards/`
- `spec/features/tcc_one_professors/examination_boards/`
- `spec/features/external_members/examination_boards/`

Você também pode criar ou alterar arquivos de suporte somente se forem específicos para deduplicação dos specs de show de bancas.

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
- specs fora dos diretórios de `examination_boards`;
- shared examples não relacionados a bancas;
- suporte global genérico demais.

Não altere arquivos globais de configuração de teste.

Se algum ajuste global parecer necessário, não faça nesta task. Apenas registre no relatório final.

# Ordem de prioridade

Siga esta ordem:

1. Inspecionar os specs de `examination_boards_show_basic_information_spec.rb` entre os perfis.
2. Mapear duplicações claras de setup, login, visita à página e expectativas comuns.
3. Deduplicar os specs de `basic_information`.
4. Inspecionar os specs de `examination_boards_show_appointments_spec.rb` entre os perfis.
5. Deduplicar apenas duplicações claras de apontamentos.
6. Inspecionar os specs de `examination_boards_show_academic_activity_spec.rb` entre os perfis.
7. Deduplicar apenas duplicações claras de atividade acadêmica.
8. Manter diferenças específicas de perfil explícitas.
9. Rodar RSpec e RuboCop nos arquivos afetados.

Se a task ficar grande demais, priorize somente `examination_boards_show_basic_information_spec.rb` entre os cinco perfis e registre no relatório final o que ficou para depois.

# Arquivos prioritários

## Basic information

- `spec/features/academics/examination_boards/examination_boards_show_basic_information_spec.rb`
- `spec/features/professors/examination_boards/examination_boards_show_basic_information_spec.rb`
- `spec/features/responsible/examination_boards/examination_boards_show_basic_information_spec.rb`
- `spec/features/tcc_one_professors/examination_boards/examination_boards_show_basic_information_spec.rb`
- `spec/features/external_members/examination_boards/examination_boards_show_basic_information_spec.rb`

## Appointments

Analise arquivos com este nome nos perfis acima, quando existirem:

- `examination_boards_show_appointments_spec.rb`

## Academic activity

Analise arquivos com este nome nos perfis acima, quando existirem:

- `examination_boards_show_academic_activity_spec.rb`

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

- `examination_boards_show_basic_information_spec.rb`
  - Antes: X exemplos distribuídos entre 5 perfis.
  - Depois: X exemplos distribuídos entre 5 perfis.
  - Cenários preservados: sim.
  - Deduplicação aplicada: shared example/local helper/etc.
  - Observações: nenhuma expectativa removida.

# Estratégia de deduplicação

A deduplicação deve ser conservadora.

Prefira extrair apenas padrões claramente repetidos, como:

- login do perfil correto;
- criação da banca;
- criação da orientação;
- visita à página de show da banca;
- expectativas comuns de dados básicos;
- expectativas comuns de avaliadores;
- expectativas comuns de apontamentos;
- expectativas comuns de atividade acadêmica;
- ausência/presença de seções comuns;
- mensagens ou textos comuns da página.

Não esconda diferenças importantes em abstrações difíceis de ler.

Não transforme os specs em uma estrutura excessivamente genérica.

Não crie metaprogramação complexa.

Não use loops grandes para gerar cenários se isso prejudicar legibilidade ou dificultar o diagnóstico de falhas.

Evite `each` para gerar muitos exemplos, a menos que o padrão já exista no projeto e a falha continue fácil de identificar.

Se usar shared examples, eles devem ter nomes claros, por exemplo:

- `shared_examples "examination board basic information"`
- `shared_examples "examination board appointments"`
- `shared_examples "examination board academic activity"`

Os nomes finais devem seguir o idioma e o padrão já usados no projeto.

# Regras específicas por grupo

## Basic information

Os specs de basic information podem repetir:

- dados da banca;
- título da banca;
- tipo de TCC;
- dados da orientação;
- dados do acadêmico;
- dados do orientador;
- datas e horários;
- local;
- informações de status.

Deduplicate apenas o que for realmente comum.

Mantenha explícito no spec:

- perfil autenticado;
- rota usada;
- permissão esperada;
- diferenças de visualização entre perfis;
- qualquer expectativa específica do perfil.

## Appointments

Os specs de appointments podem repetir:

- criação de apontamentos;
- exibição de apontamentos;
- ausência de apontamentos;
- avaliador relacionado;
- visibilidade por perfil.

Deduplicate apenas o fluxo comum.

Mantenha explícito no spec:

- quem acessa;
- quais apontamentos devem aparecer;
- quais apontamentos não devem aparecer, se houver diferença por perfil.

## Academic activity

Os specs de academic activity podem repetir:

- criação de atividade acadêmica;
- exibição de carga horária;
- exibição de tipo/descrição;
- vínculo com banca/orientação;
- visibilidade por perfil.

Deduplicate apenas o fluxo comum.

Mantenha explícito no spec:

- perfil autenticado;
- atividade esperada;
- permissões ou diferenças específicas.

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

Os nomes devem indicar claramente que o suporte pertence a bancas.

Exemplos aceitáveis, se seguirem o padrão do projeto:

- `examination_board_show_examples.rb`
- `examination_board_basic_information_examples.rb`
- `examination_board_appointments_examples.rb`
- `examination_board_academic_activity_examples.rb`

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
  spec/features/academics/examination_boards \
  spec/features/professors/examination_boards \
  spec/features/responsible/examination_boards \
  spec/features/tcc_one_professors/examination_boards \
  spec/features/external_members/examination_boards
```

Também rode RuboCop nos arquivos/pastas afetados:

```bash
./run rubocop \
  spec/features/academics/examination_boards \
  spec/features/professors/examination_boards \
  spec/features/responsible/examination_boards \
  spec/features/tcc_one_professors/examination_boards \
  spec/features/external_members/examination_boards
```

Se arquivos em `spec/support/` forem criados ou alterados, inclua também esses arquivos no RuboCop:

```bash
./run rubocop \
  spec/features/academics/examination_boards \
  spec/features/professors/examination_boards \
  spec/features/responsible/examination_boards \
  spec/features/tcc_one_professors/examination_boards \
  spec/features/external_members/examination_boards \
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

- os specs de `examination_boards_show_basic_information_spec.rb` forem analisados entre os perfis;
- duplicações claras de basic information forem reduzidas com segurança;
- os specs de `examination_boards_show_appointments_spec.rb` forem analisados quando existirem;
- duplicações claras de appointments forem reduzidas com segurança, se fizer sentido;
- os specs de `examination_boards_show_academic_activity_spec.rb` forem analisados quando existirem;
- duplicações claras de academic activity forem reduzidas com segurança, se fizer sentido;
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

- deduplicar show de orientações/supervisões;
- deduplicar activities show entre perfis;
- deduplicar orientations_activities_show entre perfis;
- deduplicar documents_show de supervisões/orientações;
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
