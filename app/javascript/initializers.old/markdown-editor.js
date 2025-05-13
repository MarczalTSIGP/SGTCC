import SimpleMDE from 'simplemde';

export default {
  mounted() {
    this.initMarkdownEditor();
  },

  methods: {
    initMarkdownEditor() {
      const $ = window.jQuery;

      $('.markdown-editor').each(function () {
        const id = $(this).attr('id');
        new SimpleMDE({
          element: document.getElementById(id),
          spellChecker: false
        });
      });
    },
  }
};
