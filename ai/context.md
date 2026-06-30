# Contexto do SGTCC

## Visão geral

O SGTCC é o Sistema de Gestão de Processos de Trabalho de Conclusão de Curso da UTFPR Guarapuava. Ele foi construído para digitalizar e organizar o ciclo de TCC do curso, centralizando cadastro de orientações, calendários acadêmicos, atividades com prazo, bancas, documentos formais e assinaturas eletrônicas.

O sistema substitui processos baseados em papel, coleta manual de assinaturas e validações informais por um fluxo digital rastreável. Isso reduz retrabalho administrativo, melhora a visibilidade para alunos e professores e oferece validação pública de autenticidade dos documentos emitidos.

## Problema que o sistema resolve

Antes de um fluxo digital como este, o processo de TCC tende a depender de planilhas, documentos isolados, assinaturas físicas, comunicação descentralizada e conferência manual. Isso gera atrasos, risco de perda de informações, inconsistência de histórico e dificuldade de auditoria.

O SGTCC resolve esse problema ao:

- centralizar informações acadêmicas do TCC;
- controlar calendários e prazos por semestre e por etapa;
- registrar quem participa de cada orientação;
- organizar bancas e avaliadores;
- gerar documentos formais do processo;
- coletar assinaturas eletrônicas;
- permitir validação pública da autenticidade de documentos.

## Perfis de usuário

O sistema é multi-perfil e separa responsabilidades por área.

### Responsável / coordenação

É o perfil administrativo principal. Gerencia:

- alunos;
- professores;
- membros externos;
- instituições;
- orientações;
- calendários;
- atividades-base e atividades de calendário;
- bancas;
- documentos anexos;
- páginas do site;
- relatórios e visão geral do processo.

Esse perfil exige mais cuidado porque suas ações afetam cadastros centrais, histórico acadêmico, documentos e fluxos institucionais.

### Professor

Professores participam como orientadores, supervisores, responsáveis ou avaliadores, dependendo de seus papéis no sistema. Eles acompanham orientações, acessam documentos relacionados, participam de bancas e podem interagir com partes do fluxo acadêmico e documental.

### Aluno

O aluno acompanha sua orientação atual, visualiza calendários, envia entregas de atividades, consulta reuniões e bancas e assina documentos quando necessário. Para esse perfil, a previsibilidade do fluxo e a preservação do histórico são essenciais.

### Membro externo

Membros externos participam principalmente como supervisores ou avaliadores de banca. Eles também podem precisar acessar documentos e assinar itens específicos do processo.

### Público geral

Há uma área pública com conteúdo institucional e dados publicados, como calendário, professores, orientações aprovadas e bancas. Essa área também expõe a validação pública de autenticidade de documentos.

## Módulos principais

### Orientações

Representam o TCC em andamento ou concluído. Uma orientação conecta aluno, orientador, calendários, status, reuniões, bancas e documentos. Esse é o centro do domínio acadêmico.

### Calendários e atividades

Calendários definem ano, semestre, etapa de TCC I ou TCC II e intervalo de datas. Atividades definem entregas, janelas de submissão e prazos associados a esses calendários.

### Bancas

As bancas organizam defesa, avaliadores, notas, situação e atas. Elas se conectam diretamente ao estágio da orientação e aos documentos acadêmicos correspondentes.

### Documentos

O sistema gera e organiza documentos formais do processo de TCC. Esses documentos podem depender de contexto da orientação, de papéis específicos e de justificativas, conforme o tipo documental.

### Assinaturas

Assinaturas eletrônicas representam os participantes que precisam assinar cada documento. Esse fluxo é sensível porque interfere na validade formal do processo e na autenticação pública.

### Notificações

Há suporte a notificações e jobs assíncronos, usados para avisos, criação e disparo de eventos relacionados ao fluxo acadêmico.

### Site público

O sistema também serve conteúdo institucional, páginas configuráveis, calendário, docentes, orientações aprovadas e bancas publicadas.

### API pública

Existe uma API JSON simples voltada a consumo externo de listas de orientações aprovadas e estados publicados correlatos.

## Models centrais

### `Orientation`

Representa o TCC em si. Faz a ligação entre aluno, orientador, calendários, reuniões, bancas, documentos e supervisores. Também concentra parte importante das regras de status, filtros, relatórios e transições entre TCC I e TCC II.

É um model sensível porque:

- possui regras acadêmicas;
- influencia documentos e assinaturas;
- afeta relatórios e dashboards;
- carrega histórico institucional do processo.

### `Calendar`

Representa um recorte acadêmico com ano, semestre, tipo de TCC e datas. É a base para organizar orientações ativas, atividades disponíveis e recortes temporais de relatórios.

### `Activity`

Representa uma atividade com prazo, normalmente vinculada a um calendário. Serve para controlar etapas, submissões, janelas de entrega e acompanhamento por parte dos participantes.

### `ExaminationBoard`

Representa a banca de avaliação. Guarda informações sobre data, local, participantes, notas, situação e atas, além da relação com a orientação correspondente.

### `Document`

Representa um documento formal emitido ou controlado pelo sistema. Pode exigir justificativas, gerar conteúdo estruturado, possuir código público de validação e disparar assinatura e notificação.

### `Signature`

Representa cada assinatura eletrônica necessária em um documento. Liga usuário, papel no fluxo e status de assinatura. É uma peça crítica para a formalidade do processo.

## Fluxo geral do TCC dentro do sistema

Em alto nível, o fluxo costuma seguir esta lógica:

1. O sistema mantém calendários por semestre e por etapa de TCC.
2. Alunos e professores se vinculam a uma orientação.
3. A orientação passa por estados acadêmicos ao longo do processo.
4. Atividades e prazos são disponibilizados conforme o calendário.
5. Alunos submetem entregas e interagem com o fluxo de atividades.
6. Bancas são cadastradas e associadas à orientação adequada.
7. Documentos formais são gerados e distribuídos para assinatura.
8. As assinaturas eletrônicas registram concordância e formalização.
9. Documentos finalizados podem ser validados publicamente por código.

Esse fluxo pode variar conforme tipo documental, status da orientação, etapa de TCC e perfil do usuário envolvido.

## Importância de documentos e assinaturas

Documentos e assinaturas não são apenas anexos auxiliares. Eles fazem parte do núcleo formal do sistema.

Por isso, qualquer mudança nessas áreas deve considerar:

- validade institucional;
- preservação de conteúdo já emitido;
- integridade de assinaturas existentes;
- compatibilidade com validação pública;
- risco de quebrar fluxos de autenticação ou aprovação.

## Área pública do site

A área pública cumpre dupla função:

- comunicação institucional do processo de TCC;
- transparência de informações publicadas.

Ela pode exibir páginas customizáveis, calendário, lista de professores, orientações aprovadas e agenda de bancas. Também expõe o fluxo de autenticação pública de documentos.

## API pública

A API pública fornece dados de orientações publicadas em formato JSON. Mesmo sendo simples, ela deve ser tratada com cuidado porque pode alimentar integrações, páginas externas ou consumidores institucionais.

## Cuidados obrigatórios de domínio

- Regras acadêmicas não devem ser alteradas por refatoração acidental.
- Histórico e rastreabilidade precisam ser preservados.
- Dados legados devem continuar válidos.
- Status, transições e filtros precisam manter compatibilidade.
- Mudanças em documentos, bancas e assinaturas exigem cautela extra.
- Em caso de dúvida, prefira preservar comportamento existente e reduzir o escopo da alteração.
