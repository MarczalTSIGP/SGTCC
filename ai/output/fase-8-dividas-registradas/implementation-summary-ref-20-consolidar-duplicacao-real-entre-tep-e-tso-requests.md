# REF-20 — Resumo de implementação

## Resumo

`Academics::TepRequestsController` e `Academics::TsoRequestsController` passam a
herdar de `Academics::RequestsController`, que concentra o esqueleto de CRUD, e
as quatro views duplicadas viram uma fonte única em `app/views/academics/requests/`.
O formulário, o `show` e a lógica de troca de orientação continuam separados,
porque ali a diferença é de domínio.

Flay nos controllers: **42 → 0**. Reek: **10 → 7** avisos.

## O mecanismo que faz a view ser única

A classe base **não** é `abstract!`, e isso é a peça central da solução.

`_prefixes` de uma subclasse é `local_prefixes + superclass._prefixes`, mas com
uma exceção: se a superclasse é abstrata, a subclasse fica só com o próprio
prefixo. Marcando a base como abstrata, `Academics::TepRequestsController`
enxergaria apenas `academics/tep_requests` e a view compartilhada nunca seria
encontrada.

Sem `abstract!`, os prefixos ficam:

```
["academics/tep_requests", "academics/requests", "academics/base", "application"]
```

Com isso, `index`, `new`, `edit` e o parcial `request` resolvem em
`academics/requests/`, enquanto `render 'form'` continua resolvendo no diretório
do recurso — `academics/tep_requests/_form` ou `academics/tso_requests/_form` —
sem nenhum condicional na view. É o mecanismo do próprio Rails fazendo o papel
que seria de um parâmetro.

## Alterações

### `app/controllers/academics/requests_controller.rb` — novo

Contém `index`, `new`, `edit`, `create`, `update`, `destroy`, os dois
`before_action`, `set_document`, `can_change` e `model_human`.

A parametrização é por gancho, não por argumento de configuração:

| Gancho | TEP | TSO |
|---|---|---|
| `requests_scope` | `current_academic.teps` | `current_academic.tsos` |
| `build_document` | `TypeFactory.new_tep` | `TypeFactory.new_tso` |
| `request_params` | só `justification` | + orientador e supervisores |
| `update_document` | padrão da base | sobrescrito |

As rotas não são passadas nem configuradas: `request_type` deriva `"tep"`/`"tso"`
de `controller_name`, e `requests_path`, `new_request_path`, `edit_request_path`
e `request_path` montam o helper a partir dele. `request_title(key)` faz o mesmo
com a chave de tradução `breadcrumbs.documents.requests.<tipo>.<key>`. Os cinco
são `helper_method`, que é como as views compartilhadas deixam de saber de qual
recurso estão falando.

`can_change` redireciona para `requests_path`, preservando o destino específico
de cada um — TEP volta para a lista de TEP, TSO para a de TSO.

### Controllers TEP e TSO

Ficam com os breadcrumbs — específicos, como a task exige — e os ganchos.
Em linhas de código, sem branco nem comentário:

| Arquivo | Antes | Depois |
|---|---:|---:|
| `tep_requests_controller.rb` | 56 | 20 |
| `tso_requests_controller.rb` | 80 | 45 |
| `requests_controller.rb` | — | 68 |
| **Total** | **136** | **133** |

O total quase não muda, e não é esse o ganho: o que era escrito duas vezes passa
a ser escrito uma. É o que o Flay mede — a duplicação de massa 42 entre os dois
`update`/`create`/`destroy` desaparece.

Os quatro métodos exclusivos do TSO (`diff_advisor?`, `diff_supervisors?`,
`can_destroy_and_update?`, `destroy_and_update`) continuam no TSO, intactos.

### `update` do TSO

O `update` da base é `if update_document ... else render :edit`. O TSO sobrescreve
o gancho:

```ruby
def update_document
  return super unless can_destroy_and_update?

  destroy_and_update
  true
end
```

O `true` é deliberado e está comentado no código. No comportamento anterior, o
ramo da troca de orientação anunciava sucesso e redirecionava **sem verificar o
retorno do `save`**; devolver o resultado de `destroy_and_update` mudaria isso
para renderizar `:edit`. A task é de refatoração, então o comportamento foi
preservado como está. Fica registrado como decisão pendente: hoje, se a recriação
do documento falhar, o acadêmico vê mensagem de sucesso.

### Views

Removidas de `academics/tep_requests/` e `academics/tso_requests/`, criadas uma
vez em `academics/requests/`: `index.html.erb`, `_request.html.erb`,
`new.html.erb`, `edit.html.erb`. De **119 para 58 linhas**.

No `index`, a variável de bloco passou de `request` para `document`, o que de
quebra desfaz o sombreamento do helper `request` do Rails dentro do laço.

`_form.html.erb` e `show.html.erb` **não** foram unificados: o `_form` do TSO tem
seleção de orientador, coorientadores professores e coorientadores membros
externos, e o `show` exibe orientador atual, novo orientador e supervisores. São
os campos do pedido de troca de orientação — conteúdo de domínio, não repetição
de apresentação. Unificar os dois exigiria um condicional por tipo dentro da
view, que é a duplicação trocada por acoplamento.

## Achado registrado, fora do escopo

`app/views/academics/tep_requests/show.html.erb` e o equivalente do TSO **são
código morto**. As rotas declaram `resources :tep_requests, except: :show` e
`resources :tso_requests, except: :show`, e nenhuma outra view os renderiza —
verificado por busca em `app/`, `config/` e `lib/`. O `show` de um pedido é
servido por `academics/documents#show`.

Não removidos aqui: a task manda manter `show` separado e o escopo é a
duplicação. Fica como candidato à mesma varredura da REF-13A.

Detalhe adicional: os dois arquivos começam com
`t('breadcrumbs.documents.requests.tep.show')` — o do TSO também usa a chave do
TEP. Erro sem efeito observável, justamente por ninguém renderizar a view.

## Validação

| Comando | Resultado |
|---|---|
| `rspec spec/features/academics/tep_requests spec/features/academics/tso_requests` | 10 exemplos, 0 falhas |
| `rspec` (suíte completa) | 1177 exemplos, 0 falhas, 1 pendente |
| `rubocop --parallel` | 819 arquivos, 0 offenses |
| `erb_lint app/views/academics/requests/` | 0 erros |
| Cobertura | 96,63% (era 96,55% ao fim da REF-21) |

Os feature specs de criação, edição e remoção dos dois pedidos passaram **sem
nenhuma alteração**, que é o critério de aceite mais forte da task: a mudança é
estrutural e nada do comportamento observável mudou.

### Métricas antes/depois

| Métrica | Antes | Depois |
|---|---:|---:|
| Flay (os controllers TEP e TSO) | 42 | 0 |
| Reek (mesmos arquivos) | 10 avisos | 7 avisos |
| Linhas de view duplicadas | 119 | 58 |
| Linhas de código dos controllers | 136 | 133 |

Os avisos que saíram do Reek: dois `DuplicateMethodCall` e um `TooManyStatements`
no `update` do TSO, e um `UtilityFunction` que existia em duplicata. Entrou um
`TooManyMethods` na base (16 métodos), que é o preço esperado de concentrar o
esqueleto em um lugar — o TSO sozinho já tinha 14 antes.

## Limites preservados

- Rotas, path helpers e o JSON de `request` gravado no documento: intactos.
- `DocumentType`, geração de documentos e fluxo de assinatura: não tocados.
- Traduções: nenhuma alterada; as chaves `tep`/`tso` existentes passaram a ser
  compostas em tempo de execução.
- Breadcrumbs específicos de cada recurso: preservados.
- Nenhum commit, push ou branch criado.
