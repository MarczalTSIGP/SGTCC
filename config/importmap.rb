# Pin npm packages by running ./bin/importmap

pin "application", preload: true

pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.7.1/dist/jquery.js"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@4.3.1/dist/js/bootstrap.js"
pin "popper.js", to: "https://ga.jspm.io/npm:popper.js@1.16.1/dist/umd/popper.js"
pin "@hotwired/turbo-rails", to: "https://ga.jspm.io/npm:@hotwired/turbo-rails@8.0.0-beta.1/app/javascript/turbo/index.js"
pin "@hotwired/turbo", to: "https://ga.jspm.io/npm:@hotwired/turbo@8.0.0-beta.1/dist/turbo.es2017-esm.js"
pin "@rails/actioncable/src", to: "https://ga.jspm.io/npm:@rails/actioncable@7.1.2/src/index.js"
pin "vue", to: "https://ga.jspm.io/npm:vue@2.5.21/dist/vue.runtime.common.js"
pin "process", to: "https://ga.jspm.io/npm:@jspm/core@2.0.1/nodelibs/browser/process-production.js"
