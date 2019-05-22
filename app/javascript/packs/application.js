import Vue from 'vue/dist/vue.esm';
import VueI18n from 'vue-i18n';
import TurbolinksAdapter from 'vue-turbolinks';

import {axios} from '../utils/axios/axios-config';
import {messages} from '../utils/i18n/messages';
import {components} from './components';

import menu from '../initializers/menu';
import markdown from '../initializers/markdown_editor';
import selectize from '../initializers/selectize';
import datetimepicker from '../initializers/datetimepicker';
import tooltip from '../initializers/tooltip';

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
    mixins: [markdown, selectize, datetimepicker, menu, tooltip],
  });
});
