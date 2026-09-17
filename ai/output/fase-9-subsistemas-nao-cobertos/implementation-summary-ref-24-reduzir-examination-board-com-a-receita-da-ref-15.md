# REF-24 — Resumo de implementação

## Resumo

`tcc_one_current_semester` e `tcc_two_current_semester` eram 14 linhas cada,
idênticas exceto por `:one`/`:two`. Passam a ser uma linha cada, delegando a um
único método de classe. O `to_sql` é idêntico nos três cenários exigidos,
incluindo encadeamento.

| Métrica | Antes | Depois |
|---|---:|---:|
| Flog do corpo da classe (`ExaminationBoard#none`) | 97,7 | **60,6** |
| Flog total do arquivo | 186,6 | 164,7 |
| Flog médio por método | 9,8 | 7,8 |
| Flay no model | 88 | **0** |
| Linhas de código (sem branco/comentário) | 131 | 121 |

O corpo da classe deixa de ser o mais complexo do projeto: os 97,7 medidos pela
REF-18 caem para 60,6, abaixo dos 89,3 em que a REF-15 deixou `Orientation`.

## A alteração

```ruby
scope :tcc_one_current_semester, -> { by_tcc_current_semester(:one) }
scope :tcc_two_current_semester, -> { by_tcc_current_semester(:two) }

def self.by_tcc_current_semester(tcc)
  current = current_calendar_by_tcc(tcc)

  return none if current.blank?

  joins(orientation: :calendars)
    .where(calendars: { id: current.id })
    .where(tcc:)
    .distinct
end

def self.current_calendar_by_tcc(tcc)
  Calendar.public_send("current_by_tcc_#{tcc}") ||
    Calendar.where(tcc:).order(year: :desc, end_date: :desc).first
end
```

`Calendar.current_by_tcc(tcc)` existe, mas é privado no concern `CurrentCalendar`
— a API pública são os dois métodos com sufixo. Como a task proíbe alterar
`Calendar`, o despacho é por `public_send`, que é o padrão já usado neste model
(`orientation.send(identifier)`).

`current_semester`, `recent`, `with_relationships`, `site_with_relationships`,
os seis concerns e o `after_commit` não foram tocados.

## Comprovação de equivalência: `to_sql` antes e depois

Capturado com um spec temporário, em três cenários e cinco consultas cada,
normalizando apenas os ids (que variam entre execuções) por substituição
posicional, para não atingir literais como `tcc = 1`.

| Cenário | Diff |
|---|---|
| A — com calendário corrente (inclui encadeamento a partir de associação) | **vazio** |
| B — sem calendário cobrindo hoje (fallback) | **vazio** |
| C — sem nenhum calendário (`none`) | **vazio** |

Consultas capturadas em cada cenário: os dois scopes isolados, `where(confirmed:
true).tcc_one_current_semester` (condição **antes** do scope),
`tcc_two_current_semester.where(place:).order(:date)` (condição **depois**) e,
no cenário A, `orientation.examination_boards.tcc_one_current_semester`.

## Cobertura

`examination_board_scopes_spec.rb` tinha 4 exemplos e cobria só o caminho feliz.
Agora tem **10**, com quatro contextos novos:

- **sem calendário cobrindo hoje** — o fallback escolhe o calendário mais recente
  do TCC;
- **sem nenhum calendário** — devolve vazio mesmo com bancas na base (calendários
  removidos depois da criação, já que uma orientação exige calendário);
- **os dois TCCs com calendário corrente** — cada scope enxerga só o seu;
- **orientação ligada aos dois calendários** — o caso de quem avançou para TCC II:
  o scope de TCC I não pode devolver a banca de monografia;
- **encadeamento** — condição antes e depois do scope.

### Validação por mutação

| Mutação | Resultado |
|---|---|
| M1 — remover `return none if current.blank?` | **pega** (1 falha) |
| M3 — remover `.where(tcc:)` | **pega** (1 falha) |
| M5 — usar sempre `current_by_tcc_one` | **pega** (1 falha) |
| M8 — tornar `by_tcc_current_semester` privado | **pega** (8 falhas) |
| M2 — remover `.distinct` | sobrevive |
| M4 — inverter a ordenação do fallback | sobrevive |
| M6 — receptor explícito `ExaminationBoard.joins(...)` | sobrevive |
| M7 — tornar `current_calendar_by_tcc` privado | sobrevive |

As quatro que sobrevivem não são buraco de cobertura. São achados, e cada um
está explicado abaixo.

## Três coisas que a medição mostrou

### 1. O fallback do model é inalcançável

`Calendar.current_by_tcc_*` **já tem fallback interno**: quando nenhum calendário
cobre a data de hoje, cai em `where(tcc:).order(end_date: :desc).first`. Então ele
só devolve `nil` quando não existe nenhum calendário daquele TCC — e nesse caso o
segundo `where` do model, que consulta o mesmo conjunto, também devolve `nil`.

O `||` do model nunca produz resultado diferente. Foi **preservado**, porque a
task manda preservá-lo, mas fica registrado: é código morto com aparência de
proteção, e por isso M4 sobrevive — inverter a ordenação de um ramo que nunca
decide nada não muda nada.

Isso também explica por que M5 só foi pega depois de um exemplo novo: com um só
TCC na base, trocar `:two` por `:one` fazia o fallback devolver o calendário certo
por acidente. Só com calendário corrente dos dois TCCs a troca aparece.

### 2. `.distinct` é inerte nesta consulta

O join filtra `calendars.id = <um id>`. Como `orientation_calendars` liga uma
orientação a um calendário uma única vez, cada banca casa com no máximo uma
linha, e não há o que deduplicar. Preservado por ordem da task; registrado que
custa um `SELECT DISTINCT` sem função.

### 3. A armadilha da REF-15 é mais estreita do que ficou documentado

A REF-15 registrou duas coisas sobre métodos de apoio chamados de dentro de um
`scope`. A medição confirma uma e não reproduz a outra.

**Confirmado — o apoio chamado direto do `scope` precisa ser público.** Tornar
`by_tcc_current_semester` privado quebra 8 dos 10 exemplos (M8). Dentro do bloco
do `scope`, `self` é a relation, que só delega métodos de classe públicos.

**Não reproduzido — "receptor explícito descarta a relation corrente".** Trocando
`joins(...)` por `ExaminationBoard.joins(...)` (M6), os dois exemplos de
encadeamento continuam passando, e o `to_sql` capturado com a mutação aplicada
**ainda contém** `"examination_boards"."confirmed" = TRUE`. O motivo é o
`scoping` do ActiveRecord: ele mantém a relation corrente ativa durante a
execução do bloco do `scope`, inclusive para consultas iniciadas na classe.

Pelo mesmo mecanismo, M7 sobrevive: dentro de `by_tcc_current_semester`, que já
foi alcançado pela delegação, `self` é a **classe**, então um método de classe
privado chamado dali funciona. A regra "precisa ser público" vale para o primeiro
salto, o que sai do bloco do `scope` — não para os seguintes.

O código continua usando receptor implícito e apoio público: é o que o resto do
projeto faz e o que não depende desse detalhe. Mas o comentário no model afirma
só o que foi verificado.

## Registrado para task própria

`Responsible::ExaminationBoardsController` continua com 16 warnings do Reek e é o
pior controller do projeto. Fora do escopo desta task, como ela mesma determina.

## Validação

| Comando | Resultado |
|---|---|
| `rspec spec/models/examination_boards spec/services/examination_boards` + features de banca | 112 exemplos, 0 falhas |
| `rspec` (suíte completa) | 1183 exemplos, 0 falhas, 1 pendente |
| `rubocop --parallel` | 819 arquivos, 0 offenses |
| `flog -d app/models/examination_board.rb` | corpo da classe 97,7 → 60,6 |
| Cobertura | 96,65% (era 96,63%) |

## Limites preservados

- `tcc_one_current_semester` e `tcc_two_current_semester` continuam existindo,
  com o mesmo comportamento nos três cenários.
- `current_semester` não foi fundido com os outros dois.
- Fallback, `return none`, `distinct` e `joins(orientation: :calendars)`
  preservados.
- `Calendar` e os seis concerns não foram tocados.
