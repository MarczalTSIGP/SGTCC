# Task

REF-23 — Organizar o subsistema de notificações, que atravessou todo o roadmap sem nunca ter sido alvo de nenhuma fase.

# Dependência

- Nenhuma. Área independente das sete fases anteriores.

# Contexto

As fases do roadmap trataram dados, controllers, models, `Calendar`, apresentação, validação e métricas. **Notificações nunca entrou em nenhuma delas**, apesar de ser área explicitamente sensível segundo as regras do projeto (processo assíncrono, disparo de e-mail).

Hoje é o maior bolo de smells fora do código de seed — 44 warnings em quatro arquivos:

| Arquivo | Warnings | Linhas |
|---|---:|---:|
| `app/services/notifications/scheduler_service.rb` | 15 | 89 |
| `app/mailers/notification_mailer.rb` | 11 | 62 |
| `app/services/notifications/stop_checker.rb` | 9 | 75 |
| `app/services/notifications/processor_service.rb` | 9 | 71 |

## O que já está bom, e não deve ser mexido sem motivo

O subsistema **tem** cobertura: existem specs de `dispatcher`, `hook_helpers`, `processor_service`, `scheduler_service`, `stop_checker`, dos quatro jobs, dos models de notificação e do mailer. A lacuna é pontual: **não há spec dedicado para `app/services/notifications/hooks/`**, e `hooks/activity.rb` ficou em 62,86% na medição da REF-13D — das piores do projeto.

# Objetivo

Alinhar o subsistema ao padrão de service que o roadmap estabeleceu, corrigir um tratamento de erro que hoje falha em silêncio, e fechar a lacuna de cobertura dos hooks.

# Escopo obrigatório

## 1. `SchedulerService` — predicado com efeito colateral

```ruby
def load_and_check_template?
  @template = NotificationTemplate.find_by(key: @notification_type)
  @template&.active?
end
```

O método é nomeado como pergunta, mas **atribui `@template`**, que `schedule!` lê logo depois. Quem ler `schedule!` não tem como saber que a linha `return unless load_and_check_template?` é o que popula o template.

- Separar a busca do template da verificação, ou tornar a dependência explícita no fluxo de `schedule!`.
- Adotar `attr_reader` privados em vez de acessar `@ivars` diretamente, seguindo o padrão já usado por `Orientations::ResponsibleListQuery`, `AcademicActivityFinder` e os demais services criados pelo roadmap.

## 2. `calculate_base_time` — falha silenciosa

```ruby
begin
  return Time.zone.parse(@data[key].to_s)
rescue StandardError
  return Time.current
end
```

Qualquer erro de parse vira `Time.current` **sem nenhum registro**. O efeito prático é uma notificação agendada para o momento errado, sem rastro para diagnosticar.

- Preservar o comportamento de fallback — mudá-lo é decisão funcional, fora desta task.
- **Registrar a falha** no log, com a chave e o valor que não puderam ser interpretados.
- Estreitar o `rescue` para os erros que `Time.zone.parse` realmente levanta, em vez de `StandardError`.

## 3. Cobertura dos hooks

- Criar specs dedicados para `hooks/activity.rb`, `hooks/documents.rb` e `hooks/examination_board.rb`.
- Cobrir, no mínimo, o caminho em que o hook dispara e o caminho em que ele não dispara.
- Registrar a cobertura dos três antes e depois.

## 4. Limpeza pontual

Remover o comentário `# Correção do LineLength aqui` em `scheduler_service.rb:48` — é meta-comentário sobre formatação, não sobre o código.

# Fora do escopo

- Não alterar o agendamento, as regras de `NotificationRule` (`days_before`, `hours_before`, `hours_after`) nem o momento de disparo.
- Não mexer nos jobs nem na configuração da fila.
- Não alterar templates de e-mail nem o conteúdo enviado.
- Não refatorar `notification_mailer.rb`, `stop_checker.rb` e `processor_service.rb` nesta task — registrar o que for encontrado neles para uma segunda passada.
- Não fazer commit, push ou criar branch.

# Critérios de aceite

- `SchedulerService` não tem mais predicado que atribui estado; o fluxo de `schedule!` é legível de cima para baixo.
- Uma falha de parse em `calculate_base_time` deixa rastro no log, mantendo o mesmo fallback de hoje.
- Os três arquivos de `hooks/` têm spec dedicado, com cobertura registrada antes/depois.
- Nenhuma notificação muda de horário, destinatário ou conteúdo — comprovado pelos specs existentes de scheduler, processor, dispatcher e jobs, que devem passar **sem alteração**.
- Suíte completa e RuboCop sem novas falhas ou offenses.

# Validação sugerida

```bash
docker compose exec -T tests bundle exec rspec spec/services/notifications spec/jobs/notifications spec/models/notifications spec/mailers
docker compose exec -T tests bundle exec rspec
docker compose exec -T tests bundle exec rubocop --parallel
docker compose exec -T tests bundle exec reek app/services/notifications app/mailers | tail -1
```
