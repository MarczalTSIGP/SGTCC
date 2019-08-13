<template>
  <div v-if="notHasJudgment() && hasPermission">
    <document-judgment :document-id="documentId" />
  </div>
  <div v-else-if="hasJudgment()">
    <p>
      <b>Solicitação:</b>
      {{ solicitationLabel() }}
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
  },

  methods: {
    solicitationLabel() {
      const accept = this.request.judgment.responsible.accept;
      return accept ? 'Deferido' : 'Indeferido';
    },

    notHasJudgment() {
      return typeof this.request['judgment'] !== 'object';
    },

    hasJudgment() {
      return typeof this.request['judgment'] === 'object';
    },
  },
};

</script>
