<template>
  <div :id="markdownId">
    {{ content }}
  </div>
</template>

<script>

import SimpleMDE from 'simplemde';

export default {
  name: 'MarkdownReader',

  props: {
    content: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      id: '',
    };
  },

  computed: {
    markdownId() {
      return `markdown-content-${this.id}`;
    },
  },

  created() {
    this.setId();
  },

  mounted() {
    this.formatMarkdown();
  },

  updated() {
    this.formatMarkdown();
  },

  methods: {
    setId() {
      this.id = Math.random().toString().split('.').join('');
    },

    formatMarkdown() {
      const $ = window.jQuery;
      const html = SimpleMDE.prototype.markdown(this.content);
      $(`#${this.markdownId}`).html(html);
    },
  },
};

</script>
