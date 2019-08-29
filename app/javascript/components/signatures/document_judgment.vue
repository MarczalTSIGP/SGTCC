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
            :checked="documentAccept"
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
            :checked="documentRefuse"
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
      :value="justificationValue"
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
      <button
        id="cancel_document_judgment"
        type="button"
        class="btn btn-danger"
        @click.prevent="close()"
      >
        {{ $t('buttons.cancel') }}
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

    acceptValue: {
      type: String,
      required: false,
      default() {
        return '';
      }
    },

    justificationValue: {
      type: String,
      required: false,
      default() {
        return '';
      }
    },
  },

  data() {
    return {
      documentAccept: false,
      documentRefuse: false,
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
    this.setJustification();
    this.setRadioboxs();
  },

  methods: {
    solicitationValue() {
      const $ = window.jQuery;

      return $('input[name="document[judgment]"]:checked').val();
    },

    selectJudgmentParams() {
      return { accept: this.solicitationValue(), justification: this.justification };
    },

    async saveJudgment() {
      if (this.hasErrors()) {
        this.showErrorMessage('Preencha todos os campos!');
        return;
      }

      const response = await this.$axios.put(this.url, this.selectJudgmentParams());

      if (response.data.status) {
        this.afterSave(response.data.message);
      } else {
        this.showErrorMessage(response.data.message);
      }

      this.$root.$emit('close-document-judgment');
    },

    afterSave(message) {
      this.showSuccessMessage(message);
      this.$root.$emit('update-json-request');
      this.$root.$emit('open-signature-button');
    },

    hasErrors() {
      return this.solicitationValue() === 'undefined' || this.justification === '';
    },

    initMarkdown() {
      const simplemde = new SimpleMDE({
        element: document.getElementById('document_judgment_justification')
      });

      this.onUpdateJustification(simplemde);
    },

    onUpdateJustification(simplemde) {
      simplemde.codemirror.on('change', () => {
        this.justification = simplemde.value();
      });
    },

    setJustification() {
      this.justification = this.justificationValue;
    },

    setRadioboxs() {
      switch(this.acceptValue) {
      case 'true':
        this.documentAccept = true; break;
      case 'false':
        this.documentRefuse = true; return;
      }
    },

    close() {
      this.$root.$emit('close-document-judgment');
    },
  },
};

</script>
