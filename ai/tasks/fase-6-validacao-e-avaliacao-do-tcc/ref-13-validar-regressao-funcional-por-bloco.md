# Task

REF-13 — Validar regressão funcional por bloco de refatoração, produzindo evidência rastreável de que o comportamento do SGTCC foi preservado da REF-02 à REF-12.

# Dependência

- REF-02 a REF-12 implementadas (blocos M1 a M5 do roadmap).

# Contexto

O roadmap (`ai/roadmap.md`, Fase 6) define a REF-13 como validação **contínua**: a suíte e a análise estática devem ser executadas ao final de cada bloco, e não apenas no encerramento do projeto.

Os resumos de implementação existentes mostram que essa validação foi desigual: as fases 3 (parcial), 4 e 5 registraram execução real de RSpec/RuboCop, enquanto as REF-02, REF-03, REF-04, REF-05 e REF-08 registraram apenas verificação de sintaxe ou ausência de ambiente. Esta task fecha essa lacuna consolidando a evidência de todos os blocos sobre o estado atual do código.

# Objetivo

Executar e arquivar a validação de regressão por bloco (M1–M5), somada à suíte completa e à análise estática atual, de forma reproduzível e rastreável.

# Instrução crítica

Esta task é de **validação e documentação**. Não corrija código de produção, specs, factories ou configuração para fazer um comando passar.

Se algo falhar, registre a falha como estado atual, classifique-a (regressão da refatoração x limitação preexistente de ambiente x pendência conhecida) e relate.

# Escopo permitido

- Executar RSpec (por bloco e suíte completa) e análise estática já configurada (`rubocop`, `reek`, `brakeman`).
- Criar arquivos de evidência em `ai/output/fase-6-validacao-e-avaliacao-do-tcc/`.
- Ajustar nada além desses arquivos de resultado.

# Escopo proibido

- Não altere `app/`, `spec/`, `db/`, `config/`, `Gemfile` ou factories.
- Não corrija offenses, smells ou testes encontrados.
- Não reative a configuração comentada do SimpleCov (fora do escopo; registrar como limitação).
- Não faça commit, push ou criação de branch.

# Escopo obrigatório

## Validação por bloco

Executar e registrar, por bloco do roadmap, o conjunto de specs que cobre as regras tocadas:

| Bloco | Tasks | Foco da validação |
|---|---|---|
| M1 | REF-02, REF-03 | enums `tcc` e `semester` em calendars, populate e listagens de orientações |
| M2 | REF-04, REF-05 | queries de orientações/bancas extraídas dos controllers e buscas |
| M3 | REF-06, REF-07, REF-08 | models/concerns de orientação, banca, documento e assinatura; services |
| M4 | REF-09, REF-10 | navegação entre períodos acadêmicos, consultas e relatórios de calendar |
| M5 | REF-11, REF-12 | components e templates de apresentação consolidados |

## Fluxos críticos de homologação

Mapear os fluxos exigidos pelo roadmap — filtros de orientações, cálculo de períodos, bancas, relatórios, documentos e assinaturas — para os feature specs que os cobrem, registrando o resultado de cada um. Quando a homologação manual não for possível no ambiente, declarar isso explicitamente em vez de presumir cobertura.

## Análise estática e suíte completa

- `rspec` completo.
- `rubocop --parallel`.
- `reek app/` e `brakeman`, comparados com o baseline da REF-00.

# Critérios de aceite

- Existe evidência por bloco (comando, data, número de exemplos e falhas) em `ai/output/fase-6-validacao-e-avaliacao-do-tcc/`.
- A suíte completa e o RuboCop têm resultado registrado sobre o estado atual do código.
- Reek e Brakeman são comparados com os números do baseline da REF-00.
- Cada fluxo crítico do roadmap está associado a specs concretas ou declarado como não coberto automaticamente.
- Falhas e limitações ficam registradas como estado atual, com classificação de causa.
- Nenhum arquivo de produção, teste ou configuração foi alterado.

# Validação sugerida

```bash
./run rspec spec/models/calendar spec/services/populate spec/services/dashboard
./run rspec spec/services/orientations spec/services/examination_boards spec/controllers
./run rspec spec/models/orientations spec/models/examination_boards spec/models/documents spec/models/signatures spec/services/documents
./run rspec spec/services/calendars spec/features/responsible/calendars spec/features/tcc_one_professors/calendars
./run rspec spec/components spec/features/academics/documents spec/features/professors/documents
./run rspec
docker compose exec -T tests bundle exec rubocop --parallel
docker compose exec -T tests bundle exec reek app/
docker compose exec -T tests bundle exec brakeman -q
```
