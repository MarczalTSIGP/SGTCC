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
import ProfileImagePreview from './professors/profile_image_preview';
import TurbolinksAdapter from 'vue-turbolinks';
import { messages } from '../i18n/messages';

Vue.use(TurbolinksAdapter)
Vue.use(VueI18n)

const i18n = new VueI18n({
  locale: 'pt-BR',
  messages,
})

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    i18n,
    el: '#app',
    components: { ProfileImagePreview }
  })
})
