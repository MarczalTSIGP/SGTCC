<template>
  <div v-if="hasJudgment()">
    <document-judgment :document-id="documentId" />
  </div>
  <div v-else>
    <p>
      <b>Solicitação:</b>
      {{ solicitationLabel() }}
    </p>

    <p>
      <b>Justificativa:</b>
    </p>
    <vue-markdown-preview>
      {{ request.judgment.responsible.justification }}
    </vue-markdown-preview>
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
  },

  methods: {
    solicitationLabel() {
      const accept = this.request.judgment.responsible.accept;
      return accept ? 'Deferido' : 'Indeferido';
    },

    hasJudgment() {
      return typeof this.request['judgment'] !== 'object';
    },
  },
};

</script>
