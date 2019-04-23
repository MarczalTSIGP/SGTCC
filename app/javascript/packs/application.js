/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Vue from 'vue/dist/vue.esm';
import VueI18n from 'vue-i18n';
import TurbolinksAdapter from 'vue-turbolinks';
import SimpleMDE from 'simplemde';

import {axios} from '../utils/axios/axios-config';
import {messages} from '../utils/i18n/messages';
import {components} from './components';

Vue.prototype.$axios = axios;

Vue.use(TurbolinksAdapter);
Vue.use(VueI18n);

const i18n = new VueI18n({
  locale: 'pt-BR',
  messages,
});

document.addEventListener('turbolinks:load', () => {
  new Vue({
    i18n,
    el: '#app',
    components,
    mounted() {
      this.initMarkdownEditor();
      this.initSelectize();
      this.initCalendarSelectize();
      this.initHeaderMenuCollapse();
    },

    methods: {
      initMarkdownEditor() {
        const $ = window.jQuery;

        $('.markdown-editor').each(function () {
          const id = $(this).attr('id');
          new SimpleMDE({
            element: document.getElementById(id)
          });
        });
      },

      initSelectize() {
        const $ = window.jQuery;
        const selects = $('*[data="selectize"]');

        if (selects.length > 0) {
          selects.selectize();
          this.fixSelectizePlaceholder();
        }
      },

      initCalendarSelectize() {
        const $ = window.jQuery;
        const select = $('*[data="calendar-selectize"]');

        if (select.length > 0) {
          select.selectize({
            onChange: function() {
              $('input[name="commit"]').click();
            }
          });
        }
        this.fixSelectizePlaceholder();
      },

      fixSelectizePlaceholder() {
        const $ = window.jQuery;
        $('.selectize-input input[placeholder]').attr('style', 'width: 100%;');
      },

      initHeaderMenuCollapse() {
        const $ = window.jQuery;

        $('[data-toggle="collapse"]').click(function() {
          $('html, body').animate({ scrollTop: 0 }, 'slow');
        });
      },
    },
  });
});
