# Diretriz de Refatoração do SGTCC

## Propósito deste arquivo

Este arquivo define que o principal intuito deste fluxo de IA no SGTCC é apoiar a **refatoração segura do sistema**, tomando como base o projeto acadêmico **“Refatoração do Sistema SGTCC para Melhoria da Qualidade do Código com Base em Boas Práticas de Engenharia de Software”**.

Ele deve ser lido como uma diretriz complementar aos arquivos:

- `ai/system.md`
- `ai/context.md`
- `ai/rules.md`
- `ai/rails-context.md`

## Intenção central

O foco deste fluxo não é reescrever o sistema por completo nem alterar regras acadêmicas já estabelecidas. O foco é **melhorar a qualidade interna do SGTCC sem alterar seu comportamento funcional**, tornando a aplicação mais:

- organizada;
- modular;
- compreensível;
- testável;
- manutenível;
- preparada para evolução contínua.

## Base conceitual

Esta diretriz se apoia no conteúdo do projeto enviado pelo usuário, que descreve o SGTCC como um sistema que evoluiu de forma incremental ao longo dos anos e, por isso, passou a acumular problemas estruturais típicos de software em manutenção contínua.

Entre os problemas destacados no material-base estão:

- alto acoplamento entre componentes;
- duplicação de lógica;
- inconsistências na representação de dados;
- concentração excessiva de responsabilidade em `models`, `controllers` e `concerns`;
- dificuldade de manutenção e evolução;
- testes com redundância e organização frágil.

## Objetivo da refatoração

As tasks guiadas por este fluxo devem contribuir para:

- melhorar a manutenibilidade do sistema;
- reduzir complexidade estrutural;
- padronizar representações de dados;
- separar melhor responsabilidades entre camadas;
- reduzir duplicações;
- tornar testes mais claros, concisos e confiáveis;
- facilitar futuras evoluções do SGTCC.

## Princípio mais importante

Toda refatoração deve preservar as funcionalidades existentes.

Isso significa que o agente deve atuar sobre a **estrutura interna** do código, e não sobre o comportamento esperado pelos usuários, salvo quando a task pedir explicitamente uma mudança funcional.

## Frentes prioritárias de refatoração

Com base no projeto acadêmico, as tarefas devem priorizar, quando fizer sentido:

### 1. Padronização de dados

- Unificar representações inconsistentes de enums e valores de domínio.
- Evitar cenários em que o mesmo conceito apareça ora como texto, ora como número, ora como símbolo sem critério claro.
- Preservar compatibilidade com dados existentes.

### 2. Reestruturação de controllers

- Reduzir lógica de negócio dentro de controllers.
- Manter controllers como camada de orquestração HTTP.
- Extrair regras complexas para componentes mais adequados.

### 3. Reorganização de models e concerns

- Reduzir acúmulo excessivo de responsabilidade em models centrais.
- Revisar uso de concerns quando eles estiverem servindo apenas como extensão informal de classes grandes.
- Extrair responsabilidades quando isso melhorar coesão e leitura.

### 4. Uso criterioso de services e classes de domínio

- Introduzir `services` quando houver fluxos de negócio ou operações que não pertençam claramente ao controller nem ao model.
- Considerar classes de domínio específicas quando isso deixar regras mais explícitas e testáveis.
- Evitar abstração desnecessária.

### 5. Reestruturação de testes

- Reduzir duplicação de cenários.
- Melhorar legibilidade e previsibilidade.
- Reorganizar arquivos de teste quando eles estiverem excessivamente grandes ou misturando responsabilidades.
- Usar recursos já presentes no projeto, como `shoulda-matchers`, quando isso simplificar cobertura de validações e associações.

### 6. Evolução segura de classes centrais

Classes centrais como `Orientation`, `Calendar`, `Document`, `Signature` e `ExaminationBoard` exigem atenção especial porque concentram regras importantes do domínio acadêmico e do fluxo documental.

Mudanças nesses pontos devem ser:

- pequenas;
- graduais;
- bem testadas;
- justificadas;
- fáceis de revisar.

## Relação com o domínio acadêmico

O projeto-base deixa claro que o SGTCC não é apenas um sistema administrativo. Ele é também um sistema institucional, com valor histórico e acadêmico, que centraliza:

- orientações;
- calendários;
- atividades;
- bancas;
- documentos formais;
- assinaturas eletrônicas;
- dados de períodos anteriores.

Por isso, refatorar o SGTCC exige cuidado para não comprometer:

- histórico de dados;
- rastreabilidade;
- autenticidade documental;
- regras acadêmicas;
- fluxos públicos de consulta e validação.

## Como o agente deve interpretar este arquivo

Sempre que uma task estiver ambígua, assuma que:

1. a prioridade é refatorar com segurança;
2. a funcionalidade atual deve ser preservada;
3. a mudança deve ser incremental;
4. a organização do código importa tanto quanto a correção;
5. testes fazem parte da refatoração, não são detalhe opcional.

## Resultado esperado

Ao seguir esta diretriz, espera-se que o agente contribua para uma evolução sustentável do SGTCC, reduzindo dívida técnica acumulada e melhorando a qualidade interna do sistema sem comprometer sua operação acadêmica.
