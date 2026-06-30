# Implementation Summary

## General Summary

Foi aplicada uma deduplicação conservadora nos specs de show de orientações e supervisões, centralizando a expectativa comum de informações básicas da orientação/supervisão em um helper/shared support específico.

A cobertura e a quantidade de exemplos foram preservadas:

- Basic information: antes 3 exemplos em 3 arquivos; depois 3 exemplos em 3 arquivos.
- TCC I: antes 3 exemplos em 3 arquivos; depois 3 exemplos em 3 arquivos.
- TCC II: antes 3 exemplos em 3 arquivos; depois 3 exemplos em 3 arquivos.
- TCC One Professors: antes 1 exemplo em 1 arquivo; depois 1 exemplo em 1 arquivo.

Cenários preservados: sim.  
Expectativas relevantes removidas: não.  
Código de produção alterado: não.  
Diferenças específicas de perfil mantidas: rotas, login/setup, breadcrumbs e permissões continuam explícitos nos specs.

## Changed Files

### spec/support/orientations/orientation_show_examples.rb

- Criado suporte específico para centralizar as expectativas comuns de informações básicas do show de orientação/supervisão.
- A alteração foi necessária para remover repetição de expectativas sobre título, acadêmico, orientador/supervisor, calendários e datas de criação/atualização.
- O suporte ficou específico para show de orientações/supervisões, evitando abstração global genérica.

### spec/features/professors/orientations/orientations_show_basic_information_spec.rb

- Substituiu o helper local duplicado por `expect_orientation_show_basic_information`.
- Necessário para reutilizar a mesma expectativa comum usada nos demais perfis.
- O fluxo de visita, histórico e rota de professor foi mantido explícito.

### spec/features/professors/orientations/orientations_show_tcc_one_spec.rb

- Substituiu o helper local duplicado pela expectativa comum extraída.
- Necessário para reduzir duplicação no cenário de show de TCC I.
- Breadcrumb e rota específicos de orientação de professor foram preservados.

### spec/features/professors/orientations/orientations_show_tcc_two_spec.rb

- Substituiu o helper local duplicado pela expectativa comum extraída.
- Necessário para reduzir duplicação no cenário de show de TCC II.
- Breadcrumb e rota específicos de orientação de professor foram preservados.

### spec/features/professors/supervisions/supervisions_show_basic_information_spec.rb

- Substituiu o helper local duplicado pela expectativa comum extraída.
- Necessário para reaproveitar as mesmas validações básicas do show.
- Fluxo de supervisão, histórico e rota de professor foram mantidos explícitos.

### spec/features/professors/supervisions/supervisions_show_tcc_one_spec.rb

- Substituiu o helper local duplicado pela expectativa comum extraída.
- Necessário para reduzir duplicação no cenário de supervisão TCC I.
- Breadcrumb e rota específicos de supervisão de professor foram preservados.

### spec/features/professors/supervisions/supervisions_show_tcc_two_spec.rb

- Substituiu o helper local duplicado pela expectativa comum extraída.
- Necessário para reduzir duplicação no cenário de supervisão TCC II.
- Breadcrumb e rota específicos de supervisão de professor foram preservados.

### spec/features/external_members/supervisions/supervisions_show_basic_information_spec.rb

- Substituiu expectativas inline duplicadas pela expectativa comum extraída.
- Necessário para alinhar o spec de membro externo com os specs de professor.
- Rota, histórico e comportamento específico de membro externo foram preservados.

### spec/features/external_members/supervisions/supervisions_show_tcc_one_spec.rb

- Substituiu expectativas inline duplicadas pela expectativa comum extraída.
- Necessário para reduzir duplicação no show de supervisão TCC I para membro externo.
- Breadcrumb e rota específicos foram mantidos.

### spec/features/external_members/supervisions/supervisions_show_tcc_two_spec.rb

- Substituiu expectativas inline duplicadas pela expectativa comum extraída.
- Necessário para reduzir duplicação no show de supervisão TCC II para membro externo.
- Breadcrumb e rota específicos foram mantidos.

### spec/features/tcc_one_professors/orientations/orientations_show_spec.rb

- Substituiu expectativas inline duplicadas pela expectativa comum extraída.
- Necessário para reaproveitar a validação básica sem dividir o arquivo em uma refatoração maior.
- O escopo do arquivo foi mantido, sem reorganização ampla.

## Review Notes

Revisar se `spec/support/orientations/orientation_show_examples.rb` está sendo carregado automaticamente pelo setup atual de RSpec.

Pontos para testar/revisar:

- Rodar RSpec nos diretórios afetados:
  ```bash
  ./run rspec \
    spec/features/professors/orientations \
    spec/features/professors/supervisions \
    spec/features/external_members/supervisions \
    spec/features/tcc_one_professors/orientations
  ```

- Rodar RuboCop nos specs afetados e no suporte criado:
  ```bash
  ./run rubocop \
    spec/features/professors/orientations \
    spec/features/professors/supervisions \
    spec/features/external_members/supervisions \
    spec/features/tcc_one_professors/orientations \
    spec/support
  ```

- Confirmar manualmente com:
  ```bash
  git status
  git diff
  ```

Não houve commit, push ou Pull Request nesta task.