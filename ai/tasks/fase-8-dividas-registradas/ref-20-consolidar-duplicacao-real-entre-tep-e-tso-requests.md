# Task

REF-20 — Consolidar a duplicação **real** entre `tep_requests` e `tso_requests`, preservando as diferenças de domínio entre os dois pedidos.

# Dependência

- REF-11, que registrou o achado, e REF-12, que o deixou fora do escopo.

# Contexto e correção do inventário

O inventário da REF-11 registrou que `tep_requests`/`tso_requests` "são o mesmo recurso duplicado em dois controllers/namespaces". **Isso está parcialmente errado** e a medição feita agora mostra por quê:

| Arquivo | Linhas divergentes no `diff` | Leitura |
|---|---:|---|
| `_request.html.erb` | 4 | duplicação real |
| `new.html.erb` | 7 | duplicação real |
| `edit.html.erb` | 8 | duplicação real |
| `index.html.erb` | 10 | duplicação real |
| `show.html.erb` | 48 | **diferença de domínio** |
| `_form.html.erb` | 57 | **diferença de domínio** |

Os controllers têm 73 (TEP) e 101 (TSO) linhas. O TSO tem quatro métodos privados que o TEP não tem: `diff_advisor?`, `diff_supervisors?`, `can_destroy_and_update?` e `destroy_and_update`.

A razão é de domínio: o TEP é um pedido com **justificativa apenas**, enquanto o TSO é um pedido de **troca de orientação**, e por isso seu formulário tem seleção de orientador, coorientadores professores e coorientadores membros externos, e seu `show` exibe orientador atual, novo orientador e supervisores. Não são o mesmo recurso — são dois recursos que compartilham o esqueleto de CRUD e a listagem.

**Tratar os dois como um só achataria uma regra acadêmica real.**

# Objetivo

Remover a duplicação comprovada — listagem, linha da listagem, `new`, `edit` e o esqueleto de CRUD dos controllers — mantendo formulário, `show` e a lógica de troca de orientação separados.

# Escopo obrigatório

## Camada de apresentação

- Consolidar `index`, `_request`, `new` e `edit` em partials ou component compartilhado, parametrizado por: chave de tradução (`tep`/`tso`), rotas do recurso e partial de linha.
- **Não** unificar `_form.html.erb` nem `show.html.erb`. As diferenças ali são de conteúdo de domínio, não de apresentação repetida.

## Controllers

- Extrair o esqueleto comum de CRUD para um `concern` ou controller base, parametrizado pelo tipo de documento e pelas rotas.
- Preservar em `Academics::TsoRequestsController` os quatro métodos exclusivos e toda a lógica de comparação de orientador e supervisores.
- Preservar os breadcrumbs específicos de cada um.

# Fora do escopo

- Não unificar os dois recursos em um só com um campo "tipo".
- Não alterar rotas públicas, nomes de path helper ou o formato do JSON de `request` gravado no documento.
- Não mexer em `DocumentType`, na geração de documentos nem no fluxo de assinatura.
- Não alterar traduções.
- Não fazer commit, push ou criar branch.

# Critérios de aceite

- `index`, `_request`, `new` e `edit` de TEP e TSO renderizam a partir de uma fonte única.
- `_form` e `show` continuam separados, e o relatório explica por quê.
- O esqueleto de CRUD aparece uma vez; os quatro métodos exclusivos do TSO permanecem nele.
- Os feature specs de criação, edição e remoção dos dois pedidos passam sem alteração.
- Suíte completa e RuboCop sem novas falhas ou offenses.

# Validação sugerida

```bash
docker compose exec -T tests bundle exec rspec \
  spec/features/academics/tep_requests spec/features/academics/tso_requests
docker compose exec -T tests bundle exec rspec
docker compose exec -T tests bundle exec rubocop --parallel
```
