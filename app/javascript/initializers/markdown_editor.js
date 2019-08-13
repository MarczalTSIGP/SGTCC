import SimpleMDE from 'simplemde';

export default {
  mounted() {
    this.initMarkdownEditor();
  },

  methods: {
    initMarkdownEditor() {
      const $ = window.jQuery;
      const root = this.$root;

      $('.markdown-editor').each(function () {
        const id = $(this).attr('id');
        const simplemde = new SimpleMDE({
          element: document.getElementById(id)
        });

        simplemde.codemirror.on('change', () => {
          root.$emit('markdown-editor', simplemde.value());
        });
      }, root);
    },
  }
};
