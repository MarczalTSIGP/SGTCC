
[![Maintainability](https://api.codeclimate.com/v1/badges/390307da2efc215ddb48/maintainability)](https://codeclimate.com/github/utfpr-gp-tsi/SGTCC/maintainability)

[![Test Coverage](https://api.codeclimate.com/v1/badges/390307da2efc215ddb48/test_coverage)](https://codeclimate.com/github/utfpr-gp-tsi/SGTCC/test_coverage)

[![Build Status](https://travis-ci.org/utfpr-gp-tsi/SGTCC.svg?branch=master)](https://travis-ci.org/utfpr-gp-tsi/SGTCC)

  

# Sistema de Gestão de Processos de Trabalho de Conclusão de Curso (SGTCC)

  

----

## O que é o SGTCC?

  

É um sistema de gestão de processos de trabalho de conclusão de curso de Tecnologia em Sistemas para Internet (TSI)

da UTFPR Câmpus Guarapuava.

  

----

  

## Índice

* [Sobre](#sobre)

* [Tecnologias](#tecnologias)

* [Instalação local](#instalação-local-usando-docker)

* [Rodando os testes](#rodando-os-testes)

  

## Sobre

  

O objetivo desse sistema foi aperfeiçoar o SGTCC do curso de TSI, de modo a eliminar o uso de documentos impressos e

assinaturas físicas. Para este fim, foi utilizado a assinatura eletrônica.

  

## Tecnologias

  

O projeto foi desenvolvido com as seguintes tecnologias:

  

* Ruby on Rails

* PostgreSQL

* [Bootstrap 4](https://getbootstrap.com.br/)

* [Tabler.io](https://tabler.io/) - template

  


## Instalação local usando Docker

Este sistema contém alguns requisitos para rodar localmente:

**1. Requisitos**

Primeiro é preciso instalar os seguintes pacotes

```
docker
docker compose
```

**2. Clonar o projeto**

```
$ git clone https://github.com/MarczalTSIGP/SGTCC.git
```

**3. Construção das imagens necessárias**

```
$ docker compose build --no-cache
```
Esse comando criará a imagem Docker para os serviços especificados no arquivo docker-compose.yml, sem usar nenhuma camada em cache.

**4. Instalação das dependências do Rails**

```
$ docker compose run --rm web bundle install
```
O comando executa o serviço `web` por meio de um contêiner e roda o comando `bundle install` para instalar as dependências do projeto Ruby on Rails listadas no arquivo Gemfile.lock. A opção `--rm` usado nesse comando e no próximo, instrui o Docker a remover o contêiner após a execução, fazendo com que o ambiente fique mais limpo e também economiza espaço em disco.

**5. Instalação das dependências de Javascript**
```
$ docker compose run --rm web yarn install
```
O comando executa o serviço `web` por meio de um contêiner especificado no arquivo docker-compose.yml e executa o comando `yarn install` dentro do contêiner Docker.

**6. Configurar as Variáveis de Ambiente para Aplicação**
```
$ cp config/application.yml.example config/application.yml
```
Esse comando copia o arquivo `application.yml.example` que está dentro do diretório `config` e cria uma cópia com o nome `application.yml`, ou seja, um arquivo de configuração personalizado.

**6. Configurar Mailtrap**

Editar os seguintes campos do arquivo `application.yml` conforme necessidade do projeto, como nome do host, nome de usuário e senha baseados no MailTrap.
```
mailer.smtp.username: 'username'
mailer.smtp.password: 'password'
```
**7. Criação do Banco de Dados**
```
$ docker compose run --rm web bundle exec rails db:create
```
Cria o banco de dados especificado na aplicação Rails

**8. Criação das tabelas**
```
$ docker compose run --rm web bundle exec rails db:migrate
```
Executa as migrações do banco de dados na aplicação Rails

**9. Criação dados necesssários para rodar aplicação**
```
$ docker compose run --rm web bundle exec rails db:seed
```
Executa o arquivo de seed da aplicação Rails, que preenche o banco de dados com dados iniciais da aplicação

**10. Levantar todos serviços**
```
$ docker compose up web -d
```
Iniciar o serviços específicados no `docker-compose.yml` em segundo plano.

**11. Popular a aplicação com registros fake**
```
$ docker compose exec web bundle exec rails db:populate
```

**11. Acessar a aplicação no navegador**
* Acessar o http://localhost:3000


  

## Rodando os testes

  

Primeiro, é preciso criar a base de dados para os testes

  

```

$ rails db:create RAILS_ENV=test

$ rails db:migrate RAILS_ENV=test

```

  

**Rodar testes do rspec**

  

```

$ rspec

```

  

**Qualidade do código**

  

Ruby:

```

$ rubocop

```

  

JavaScript:

```

$ yarn run lint

```