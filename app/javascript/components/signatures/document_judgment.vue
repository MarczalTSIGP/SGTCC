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
            value="true"
            name="document[judgment]"
            class="custom-control-input"
          >
          <span class="custom-control-label">Deferir</span>
        </label>
        <label class="custom-control custom-radio custom-control-inline">
          <input
            id="document_refuse"
            type="radio"
            value="false"
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
      class="form-control"
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
import SimpleMDE from 'simplemde';

export default {
  name: 'DocumentJudgment',

  mixins: [sweetAlert],

  props: {
    documentId: {
      type: Number,
      required: true
    },
  },

  data() {
    return {
      justification: '',
    };
  },

  computed: {
    url() {
      return `/responsible/documents/${this.documentId}/judgment`;
    },
  },

  watch: {
    justification() {},
  },

  mounted() {
    this.initMarkdown();
  },

  methods: {
    solicitationValue() {
      const $ = window.jQuery;

      return $('input[name="document[judgment]"]:checked').val();
    },

    async saveJudgment() {
      if (this.hasErrors()) {
        this.showErrorMessage('Preencha todos os campos!');
        return;
      }

      const params = { accept: this.solicitationValue(), justification: this.justification };
      const response = await this.$axios.put(this.url, params);

      if (response.data) {
        this.showSuccessMessage('Documento atualizado com sucesso!');
        this.$root.$emit('update-json-request');
      }
    },

    hasErrors() {
      return this.solicitationValue() === 'undefined' || this.justification === '';
    },

    initMarkdown() {
      const simplemde = new SimpleMDE({
        element: document.getElementById('document_judgment_justification')
      });

      simplemde.codemirror.on('change', () => {
        this.justification = simplemde.value();
      });
    },
  },
};

</script>
