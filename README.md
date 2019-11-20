[![Maintainability](https://api.codeclimate.com/v1/badges/390307da2efc215ddb48/maintainability)](https://codeclimate.com/github/utfpr-gp-tsi/SGTCC/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/390307da2efc215ddb48/test_coverage)](https://codeclimate.com/github/utfpr-gp-tsi/SGTCC/test_coverage)
[![Build Status](https://travis-ci.org/utfpr-gp-tsi/SGTCC.svg?branch=development)](https://travis-ci.org/utfpr-gp-tsi/SGTCC)

# Sistema de Gestão de Processos de Trabalho de Conclusão de Curso (SGTCC)

----
## O que é o SGTCC?

É um sistema de gestão de processos de trabalho de conclusão de curso de Tecnologia em Sistemas para Internet (TSI)
da UTFPR Câmpus Guarapuava.

----

## Índice
* [Sobre](#sobre)
* [Tecnologias](#tecnologias)
* [Instalação local](#instalação-local)
* [Rodando os testes](#rodando-os-testes)

## Sobre

O objetivo desse sistema foi aperfeiçoar o SGTCC do curso de TSI, de modo a eliminar o uso de documentos impressos e
assinaturas físicas. Para este fim, foi utilizado a assinatura eletrônica.

## Tecnologias

O projeto foi desenvolvido com as seguintes tecnologias:

* Ruby on Rails
* PostgreSQL
* [@rails/webpacker](https://github.com/rails/webpacker)
* [Vue 2](https://vuejs.org/)
* [Bootstrap 4](https://getbootstrap.com.br/)
* [Tabler.io](https://tabler.io/) - template

## Instalação local

Este sistema contém alguns requisitos para rodar localmente:

**1. Requisitos**

Primeiro é preciso instalar os seguintes pacotes

```
nodejs
libpq-dev
postgresql
postgresql-contrib
imagemagick
yarn
```

Também é necessário instalar o Bundler e o Rails
```
$ gem install bundler
$ gem install rails
```

**2. Clonar o projeto**

```
$ git clone https://github.com/utfpr-gp-tsi/SGTCC.git
```

**3. Acessar a pasta do projeto**

```
cd SGTCC
```

**4. Instalar as dependências**

Instalar as gems do ruby
```
$ bundle install
```

Instalar os pacotes JavaScript
```
$ yarn install
```

**5. Configurar o PostgreSQL**

Criar um arquivo chamado **"application.yml"** usando o examplo **"appplication.yml.example"**

```
$ cp config/appplication.yml.example config/application.yml
```

Nesse arquivo é preciso alterar o **username** e o **password** conforme seu usuário e senha do PostgreSQL
```
database: &database
	db.username: postgres
	db.password: postgres
	db.host: localhost
```

**6. Configurar o envio de emails**

No "application.yml" é preciso alterar o **username** e **password**.
Nesse projeto está sendo usado o [mailtrap](https://mailtrap.io) para enviar emails.

```
mailer: &mailer
  mailer.smtp.username: 'username'
  mailer.smtp.password: 'password'
```

**7. Criar o banco de dados e as tabelas**

```
$ rails db:create
$ rails db:migrate
```

**8. Popular a aplicação para testes**

```
$ rails db:populate
```

**9. Rodar a aplicação**

```
$ rails s
```

e em outro terminal rodar o servidor do webpack:
```
$ yarn run webpack
```

**10. Acessar a aplicação no navegador**

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
