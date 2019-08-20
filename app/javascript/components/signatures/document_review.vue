<template>
  <div v-if="showDocumentJudgment()">
    <document-judgment
      :document-id="documentId"
      :accept-value="getJudgmentAcceptValue()"
      :justification-value="getJudgmentJustificationValue()"
    />
  </div>
  <div v-else-if="hasJudgment()">
    <p>
      <b>Solicitação:</b>
      {{ solicitationLabel() }}
      <button
        v-if="showEditButtonJudment()"
        id="edit_button_judgment"
        class="btn btn-outline-primary btn-sm"
        @click="editDocumentJudgment()"
      >
        Editar
      </button>
    </p>

    <p>
      <b>Justificativa:</b>
    </p>
    <div>
      <vue-simple-markdown :source="request.judgment.responsible.justification" />
    </div>
  </div>
  <div v-else>
    <p>
      <b>Solicitação:</b>
      Em análise pelo professor responsável do TCC
    </p>
  </div>
</template>

<script>

import DocumentJudgment from './document_judgment';

export default {
  name: 'DocumentReview',

  components: { DocumentJudgment },

  props: {
    documentId: {
      type: Number,
      required: true
    },

    request: {
      type: Object,
      required: true
    },

    hasPermission: {
      type: Boolean,
      required: false,
      default() {
        return false;
      }
    },

    canEdit: {
      type: Boolean,
      required: false,
      default() {
        return false;
      }
    },
  },

  data() {
    return {
      showEditButton: false,
      showJudgment: false,
    };
  },

  mounted() {
    this.setShowEditButton();
    this.onCloseDocumentJudgment();
    this.onCloseEditButton();
  },

  updated() {
    this.onShowDocumentJudgment();
  },

  methods: {
    onShowDocumentJudgment() {
      if (this.hasPermission && this.notHasJudgment()) {
        this.$root.$emit('close-signature-button');
      }
    },

    setShowEditButton() {
      this.showEditButton = this.canEdit;
    },

    onCloseEditButton() {
      this.$root.$on('close-edit-button', () => {
        this.showEditButton = false;
      });
    },

    solicitationLabel() {
      const accept = this.request.judgment.responsible.accept;
      return accept === 'true' ? 'Deferido' : 'Indeferido';
    },

    showDocumentJudgment() {
      return (this.notHasJudgment() && this.hasPermission) || this.showJudgment;
    },

    showEditButtonJudment() {
      return this.hasPermission && this.canEdit && this.showEditButton;
    },

    notHasJudgment() {
      return typeof this.request['judgment'] !== 'object';
    },

    hasJudgment() {
      return typeof this.request['judgment'] === 'object';
    },

    getJudgmentAcceptValue() {
      if (this.hasJudgment()) {
        return this.request.judgment.responsible.accept;
      }
    },

    getJudgmentJustificationValue() {
      if (this.hasJudgment()) {
        return this.request.judgment.responsible.justification;
      }
    },

    editDocumentJudgment() {
      this.showJudgment = true;
    },

    onCloseDocumentJudgment() {
      this.$root.$on('close-document-judgment', () => {
        this.showJudgment = false;
      });
    },
  },
};

</script>
