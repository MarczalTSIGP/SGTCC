# Implementation Summary

## General Summary

Foi feita uma deduplicação conservadora dos 12 specs de documentos de `academics`, `professors` e `external_members`, separando fluxos comuns de visualização e assinatura em shared examples/helpers específicos de documentos.

Os cenários foram preservados: specs de `show` continuam cobrindo documento pendente, documento assinado e acesso não autorizado; specs de `sign` continuam cobrindo assinatura com sucesso e senha inválida. As diferenças de perfil, rota, usuário autenticado, tipo de documento, credenciais, mensagens e datas esperadas permaneceram explícitas nos próprios specs.

## Changed Files

### spec/features/academics/documents/term_of_commitment/documents_show_spec.rb

- Substituiu expectativas repetidas de página pendente, página assinada e acesso não autorizado por shared examples de documentos.
- A alteração foi necessária para reduzir duplicação entre specs de `show`.
- Antes: 3 exemplos. Depois: 3 exemplos. Cenários preservados: sim.

### spec/features/academics/documents/term_of_commitment/documents_sign_spec.rb

- Centralizou o fluxo comum de assinatura válida e inválida em shared examples, mantendo credenciais e seletor de formulário específicos no spec.
- A alteração foi necessária para reaproveitar o fluxo comum de assinatura.
- Antes: 2 exemplos. Depois: 2 exemplos. Cenários preservados: sim.

### spec/features/academics/documents/term_of_accept_institution/documents_show_spec.rb

- Aplicou shared examples para documento pendente, assinado e acesso não autorizado.
- A alteração foi necessária para alinhar a estrutura com os demais specs de `show`.
- Antes: 3 exemplos. Depois: 3 exemplos. Cenários preservados: sim.

### spec/features/academics/documents/term_of_accept_institution/documents_sign_spec.rb

- Aplicou shared examples para assinatura com sucesso e senha inválida.
- A alteração foi necessária para remover repetição do clique, preenchimento e validação de mensagem.
- Antes: 2 exemplos. Depois: 2 exemplos. Cenários preservados: sim.

### spec/features/professors/documents/term_of_commitment/documents_show_spec.rb

- Extraiu expectativas comuns de visualização para shared examples, preservando rota, data esperada e papel do professor.
- A alteração foi necessária para reduzir duplicação com os demais perfis.
- Antes: 3 exemplos. Depois: 3 exemplos. Cenários preservados: sim.

### spec/features/professors/documents/term_of_commitment/documents_sign_spec.rb

- Reaproveitou o fluxo comum de assinatura, mantendo `professor.username` e senha esperada no spec.
- A alteração foi necessária para centralizar o comportamento repetido de assinatura.
- Antes: 2 exemplos. Depois: 2 exemplos. Cenários preservados: sim.

### spec/features/professors/documents/term_of_accept_institution/documents_show_spec.rb

- Aplicou shared examples de visualização pendente, assinada e acesso não autorizado.
- A alteração foi necessária para manter consistência entre tipos de documento.
- Antes: 3 exemplos. Depois: 3 exemplos. Cenários preservados: sim.

### spec/features/professors/documents/term_of_accept_institution/documents_sign_spec.rb

- Centralizou o fluxo de assinatura válida e inválida em shared examples.
- A alteração foi necessária para evitar repetição do mesmo fluxo de formulário e mensagens.
- Antes: 2 exemplos. Depois: 2 exemplos. Cenários preservados: sim.

### spec/features/external_members/documents/term_of_commitment/documents_show_spec.rb

- Substituiu blocos repetidos de visualização por shared examples, mantendo setup específico de membro externo.
- A alteração foi necessária para reaproveitar expectativas comuns entre perfis.
- Antes: 3 exemplos. Depois: 3 exemplos. Cenários preservados: sim.

### spec/features/external_members/documents/term_of_commitment/documents_sign_spec.rb

- Aplicou shared examples para assinatura com sucesso e senha inválida, preservando uso de e-mail e mensagens em `div.swal-text`.
- A alteração foi necessária para deduplicar o fluxo de assinatura.
- Antes: 2 exemplos. Depois: 2 exemplos. Cenários preservados: sim.

### spec/features/external_members/documents/term_of_accept_institution/documents_show_spec.rb

- Aplicou shared examples de página pendente, página assinada e acesso não autorizado.
- A alteração foi necessária para reduzir duplicação com os specs equivalentes.
- Antes: 3 exemplos. Depois: 3 exemplos. Cenários preservados: sim.

### spec/features/external_members/documents/term_of_accept_institution/documents_sign_spec.rb

- Reaproveitou shared examples de assinatura, mantendo credenciais e estratégia de mensagem específicas do perfil.
- A alteração foi necessária para centralizar comportamento repetido de assinatura.
- Antes: 2 exemplos. Depois: 2 exemplos. Cenários preservados: sim.

### spec/support/documents/

- Foram criados suportes específicos de documentos com shared examples/helpers para `show` e `sign`.
- A alteração foi necessária para centralizar expectativas comuns sem alterar código de produção nem configuração global.
- Observação: os arquivos de suporte ficam restritos ao domínio de documentos.

## Review Notes

- Revisar os shared examples em `spec/support/documents/` para confirmar se a granularidade ficou clara e não genérica demais.
- Rodar/verificar: `./run rspec spec/features/academics/documents spec/features/professors/documents spec/features/external_members/documents`.
- Rodar/verificar: `./run rubocop spec/features/academics/documents spec/features/professors/documents spec/features/external_members/documents spec/support`.
- Validar manualmente com `git status` e `git diff`; nenhum commit, push ou PR foi criado.
- Pendência: o relatório não indica correção de expectativas frágeis ou cenários suspeitos, apenas deduplicação preservando comportamento.