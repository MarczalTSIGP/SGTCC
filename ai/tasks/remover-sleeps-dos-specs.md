# Task

Remover `sleep` dos specs e helpers de teste, substituindo por waits explícitos do Capybara ou por expectativas estáveis.

# Contexto

A etapa pesada de divisão e deduplicação dos specs já está bem encaminhada.

Agora a prioridade é melhorar a estabilidade e a velocidade da suíte de testes.

Foram identificados alguns `sleep` em specs e helpers, que podem deixar os testes lentos, frágeis e dependentes de tempo fixo.

Arquivos apontados:

- `spec/features/responsible/orientations/orientations_search_spec.rb` — contém `sleep 20`;
- `spec/features/responsible/documents/documents_review_spec.rb` — contém `sleep 1`;
- `spec/features/responsible/activities/activities_index_spec.rb` — contém `sleep 0.5`;
- `spec/support/helpers/form.rb` — contém `sleep 0.2`.

O objetivo desta task é remover esses sleeps e trocar por waits apropriados, como:

- `expect(page).to have_text(...)`;
- `expect(page).to have_css(...)`;
- `expect(page).to have_selector(...)`;
- `expect(page).to have_current_path(...)`;
- `expect(page).to have_no_css(...)`;
- `expect(page).to have_button(...)`;
- `expect(page).to have_link(...)`;
- outros matchers do Capybara que esperem a condição real da tela.

# Objetivo

Remover sleeps explícitos dos testes e helpers listados, tornando os specs mais rápidos e menos frágeis.

A task deve melhorar:

- estabilidade da suíte;
- velocidade dos testes;
- clareza das esperas;
- redução de flakiness;
- dependência menor de tempo fixo;
- uso correto dos waits automáticos do Capybara.

# Instrução crítica

Esta task deve alterar apenas os arquivos necessários para remover `sleep`.

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

# Escopo permitido

Você pode alterar apenas estes arquivos:

- `spec/features/responsible/orientations/orientations_search_spec.rb`
- `spec/features/responsible/documents/documents_review_spec.rb`
- `spec/features/responsible/activities/activities_index_spec.rb`
- `spec/support/helpers/form.rb`

# Escopo proibido

Não altere arquivos fora do escopo permitido.

Não altere:

- factories;
- código de produção;
- outros specs;
- `rails_helper.rb`;
- `spec_helper.rb`;
- configurações globais de Capybara;
- configurações globais de RSpec.

Se algum outro `sleep` for encontrado fora dos arquivos permitidos, não altere nesta task. Apenas registre no relatório final como pendência.

# Regra crítica contra correções oportunistas

Esta task deve apenas remover sleeps e substituir por waits equivalentes.

Não corrija expectativas.
Não corrija iteradores.
Não corrija matchers não relacionados ao sleep.
Não corrija cenários aparentemente incorretos.
Não altere lógica dos testes.
Não altere dados de setup para “melhorar” o teste.
Não transforme um teste frágil em outro teste diferente.
Não remova expectativas para facilitar a correção.

Se encontrar um teste aparentemente incorreto, frágil, duplicado, mal escrito ou com problema de matcher/iteração, registre no relatório final como pendência separada.

A prioridade é preservar o mesmo comportamento, removendo apenas dependência de tempo fixo.

# Estratégia obrigatória

Antes de alterar cada `sleep`, identifique qual condição o teste realmente precisava esperar.

Exemplos:

- se o teste esperava uma busca terminar, use expectativa sobre resultado da busca;
- se o teste esperava uma página carregar, use `have_current_path`, `have_text`, `have_css` ou elemento esperado;
- se o teste esperava um modal aparecer, use `have_css` ou `have_selector` do modal;
- se o teste esperava um modal desaparecer, use `have_no_css` ou `have_no_selector`;
- se o teste esperava uma mensagem flash, use `have_text` ou seletor específico da flash;
- se o teste esperava atualização de tabela, use expectativa sobre linha, texto ou ausência/presença de item;
- se o helper esperava o campo ficar pronto, use condição real do campo, botão ou formulário.

Não substitua `sleep` por outro tempo fixo menor.

Não use `Capybara.default_max_wait_time` nesta task.

Não use `using_wait_time` salvo se houver justificativa clara e local.

Prefira waits naturais do Capybara.

# Arquivos e orientações

## `spec/features/responsible/orientations/orientations_search_spec.rb`

Esse arquivo contém um `sleep 20`, que é o principal alvo da task.

Analise qual busca ou atualização assíncrona o teste espera.

Substitua o `sleep 20` por uma expectativa que aguarde o resultado real da busca.

Possíveis alternativas:

- esperar o texto do resultado aparecer;
- esperar o item filtrado aparecer;
- esperar o item que não deveria aparecer sumir;
- esperar a tabela/lista ser atualizada;
- esperar o path ou parâmetro da busca, se fizer sentido;
- esperar algum indicador visual da busca, se existir.

Não altere o cenário além do necessário.

## `spec/features/responsible/documents/documents_review_spec.rb`

Esse arquivo contém `sleep 1`.

Substitua por uma espera explícita relacionada ao fluxo de revisão de documento.

Possíveis alternativas:

- esperar mensagem de sucesso ou erro;
- esperar mudança de status;
- esperar botão aparecer/desaparecer;
- esperar redirecionamento;
- esperar conteúdo atualizado da página.

## `spec/features/responsible/activities/activities_index_spec.rb`

Esse arquivo contém `sleep 0.5`.

Substitua por uma expectativa real sobre o estado final esperado no index de atividades.

Possíveis alternativas:

- esperar atividade aparecer na listagem;
- esperar filtro ser aplicado;
- esperar texto sumir/aparecer;
- esperar tabela/lista atualizar.

## `spec/support/helpers/form.rb`

Esse helper contém `sleep 0.2`.

Remova o sleep apenas se for possível substituí-lo por uma espera clara e segura.

Se o helper estiver esperando um campo ou formulário ficar disponível, use algo como:

- `find(...)`;
- `has_field?(...)`;
- `expect(page).to have_field(...)`, se o contexto permitir;
- `expect(page).to have_css(...)`, se o helper já depender de `page`;
- espera pelo botão ou campo que será usado em seguida.

Se não for possível substituir com segurança sem entender melhor todos os usos do helper, registre no relatório final e mantenha o menor escopo possível.

Não altere a API pública do helper, a menos que seja indispensável.

# Regras de implementação

Preserve o comportamento dos testes existentes.

Não remova cenários.

Não remova expectativas.

Não simplifique expectativas se isso reduzir cobertura.

Não altere a intenção dos testes.

Não altere setup de dados sem necessidade.

Não altere factories.

Não altere código de produção.

Não introduza abstrações novas.

Não crie helpers novos.

Não altere configurações globais.

Não troque `sleep` por outro mecanismo de espera fixa.

Cada arquivo afetado deve continuar rodando individualmente.

# Verificação obrigatória

Após as alterações, confirme que não restou `sleep` nos arquivos do escopo permitido.

Use algo equivalente a:

```bash
grep -R "sleep " \
  spec/features/responsible/orientations/orientations_search_spec.rb \
  spec/features/responsible/documents/documents_review_spec.rb \
  spec/features/responsible/activities/activities_index_spec.rb \
  spec/support/helpers/form.rb
```

Se algum `sleep` permanecer, explique no relatório final por que ele não foi removido.

# Testes esperados

Após remover os sleeps, rode os testes diretamente afetados usando o padrão do projeto.

Comando principal esperado:

```bash
./run rspec \
  spec/features/responsible/orientations/orientations_search_spec.rb \
  spec/features/responsible/documents/documents_review_spec.rb \
  spec/features/responsible/activities/activities_index_spec.rb
```

Também rode RuboCop nos arquivos afetados:

```bash
./run rubocop \
  spec/features/responsible/orientations/orientations_search_spec.rb \
  spec/features/responsible/documents/documents_review_spec.rb \
  spec/features/responsible/activities/activities_index_spec.rb \
  spec/support/helpers/form.rb
```

Se algum comando falhar por problema de ambiente, explique no relatório final.

Se algum teste falhar, investigue se a falha foi causada pela remoção do sleep.

Corrija apenas problemas nos arquivos do escopo permitido quando a correção for estritamente necessária para preservar o comportamento após remover o sleep.

Não corrija código de produção nesta task.

# Critérios de aceite

A task será considerada concluída se:

- os sleeps dos arquivos permitidos forem analisados;
- sleeps forem removidos quando houver substituição segura por waits do Capybara;
- nenhum sleep for substituído por outro tempo fixo;
- as condições reais esperadas pelos testes forem usadas como waits;
- nenhum código de produção for alterado;
- nenhum arquivo fora do escopo permitido for alterado;
- `spec/factories`, `rails_helper.rb` e `spec_helper.rb` não forem alterados;
- os testes afetados forem executados ou a impossibilidade for explicada claramente;
- o RuboCop for executado nos arquivos afetados ou a impossibilidade for explicada claramente;
- qualquer sleep mantido for justificado no relatório final;
- problemas encontrados fora do escopo forem registrados como pendência, não corrigidos oportunisticamente.

# Relatório final esperado

No relatório final, inclua:

## Resumo

Explique quais sleeps foram removidos e qual espera substituiu cada um.

## Arquivos alterados

Liste os arquivos alterados.

## Sleeps removidos

Para cada sleep removido, informe:

- arquivo;
- sleep original;
- condição real usada como espera;
- motivo da substituição.

## Sleeps mantidos

Se algum sleep foi mantido, explique:

- arquivo;
- motivo;
- sugestão para task futura.

## Pendências encontradas

Liste problemas encontrados que não foram corrigidos por estarem fora do escopo, especialmente:

- outros sleeps fora do escopo;
- expectativas suspeitas;
- matchers frágeis;
- cenários aparentemente incorretos;
- necessidade futura de ajuste em helper.

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
