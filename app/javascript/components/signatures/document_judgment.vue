<template>
  <div>
    <div class="form-group radio_button_tabler required document_judgment">
      <div class="custom-controls-stacked">
        <div class="form-label">
          Solicitação
        </div>
        <label class="custom-control custom-radio custom-control-inline">
          <input
            id="document_accept"
            type="radio"
            value="accept"
            name="document[judgment]"
            class="custom-control-input"
          >
          <span class="custom-control-label">Deferir</span>
        </label>
        <label class="custom-control custom-radio custom-control-inline">
          <input
            id="document_refuse"
            type="radio"
            value="refuse"
            name="document[judgment]"
            class="custom-control-input"
          >
          <span class="custom-control-label">Indeferir</span>
        </label>
      </div>
    </div>
    <label class="form-label">
      Parecer
      <abbr :title="$t('labels.required')">
        *
      </abbr>
    </label>
    <textarea
      id="document_judgment_justification"
      class="form-control markdown-editor"
      rows="5"
    />
    <div class="mt-4 float-right">
      <button
        id="save_document_judgment"
        type="button"
        class="btn btn-primary"
        @click.prevent="saveJudgment()"
      >
        {{ $t('buttons.save') }}
      </button>
    </div>
    <div class="clearfix" />
  </div>
</template>

<script>

import sweetAlert from '../shared/helpers/sweet_alert';

export default {
  name: 'DocumentJudgment',

  mixins: [sweetAlert],

  data() {
    return {
      justification: '',
    };
  },

  watch: {
    justification() {},
  },

  mounted() {
    this.listenMarkdownEditor();
  },

  methods: {
    listenMarkdownEditor() {
      this.$root.$on('markdown-editor', (val) => {
        this.justification = val;
      });
    },

    solicitationValue() {
      const $ = window.jQuery;

      return $('input[name="document[judgment]"]:checked').val();
    },

    async saveJudgment() {
      if (this.hasErrors()) {
        this.showErrorMessage('Preencha todos os campos!');
      }
    },

    hasErrors() {
      return this.solicitationValue() === 'undefined' || this.justification === '';
    },
  },
};

</script>
