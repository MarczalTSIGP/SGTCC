<template>
  <base-term-layout :document-id="documentId">
    <p>
      Eu, <b>{{ term.academic.name }}</b>, acadêmico(a) desta instituição,
      solicito a extensão do prazo de trabalho de conclusão de curso em 1 (um)
      semestre levito.
    </p>

    <p>
      <b>Justificativa</b>:
      <span>
        <div class="ml-4">
          <vue-simple-markdown :source="request.requester.justification" />
        </div>
      </span>
    </p>

    <document-review
      :document-id="documentId"
      :request="request"
      :has-permission="isResponsible"
    />
  </base-term-layout>
</template>

<script>

import baseTermData from './base_term_data';
import BaseTermLayout from './base_term_layout';
import DocumentReview from '../document_review';

export default {
  name: 'TermOfExtension',

  components: { BaseTermLayout, DocumentReview },

  mixins: [baseTermData],

  props: {
    isResponsible: {
      type: Boolean,
      required: false,
      default() {
        return false;
      }
    },
  },
};
</script>
