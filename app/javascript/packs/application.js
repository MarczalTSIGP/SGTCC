import Vue from 'vue/dist/vue.esm';
import VueI18n from 'vue-i18n';
import TurbolinksAdapter from 'vue-turbolinks';
import VueSwal from 'vue-swal';
import VueHtmlToPaper from 'vue-html-to-paper';
import VueClipboard from 'vue-clipboard2';
import 'babel-polyfill';

import { axios } from '../utils/axios/axios-config';
import { messages } from '../utils/i18n/messages';
import { components } from './components';

import menu from '../initializers/menu';
import markdown from '../initializers/markdown-editor';
import selectize from '../initializers/selectize';
import datetimepicker from '../initializers/datetimepicker';
import tooltip from '../initializers/tooltip';
import sidebarScroll from '../initializers/sidebar-scroll';
import fileInput from '../initializers/file-input';
import rangeInput from '../initializers/range-input';
import hideShowActivityFields from '../initializers/hide-show-activity-fields';

Vue.prototype.$axios = axios;
Vue.use(TurbolinksAdapter);
Vue.use(VueI18n);
Vue.use(VueSwal);
Vue.use(VueClipboard);

const options = {
  name: '_blank',
  specs: ['fullscreen=yes', 'titlebar=no', 'scrollbars=yes'],
  styles: [
    'https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css',
    'https://unpkg.com/kidlat-css/css/kidlat.css'
  ]
};

Vue.use(VueHtmlToPaper, options);

const i18n = new VueI18n({
  locale: 'pt-BR',
  messages
});

document.addEventListener('turbolinks:load', () => {
  new Vue({
    i18n,
    el: '#app',
    components,
    mixins: [
      datetimepicker,
      fileInput,
      markdown,
      menu,
      selectize,
      sidebarScroll,
      tooltip,
      rangeInput,
      hideShowActivityFields
    ]
  });
});
