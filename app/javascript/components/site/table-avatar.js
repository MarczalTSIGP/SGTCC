import Vue from "vue";

export default Vue.component('table-name-avatar', {
  props: {
    url: {
      type: String,
      required: true
    }
  },
  computed: {
    spanClass() {
      return { 'backgroundImage': `url(../${this.url})` };
    },
  },
  template:'<template><span class="avatar" :style="spanClass" /></template>'
})