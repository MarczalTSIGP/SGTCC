<template>
  <base-term-layout :document-id="documentId">
    <p>
      Eu, <b>{{ term.advisor.name }}</b>, {{ term.advisor.label }} desta instituição,
      declaro para os devidos fins, desistir da orientação do trabalho de conclusão de
      curso intitulado <b>{{ term.orientation.title }}</b> do acadêmico
      <b>{{ term.academic.name }}</b>, RA {{ term.academic.ra }}.
    </p>

    <p>
      <b>Motivos da desistência</b>: <br>
      <span>
        <div class="ml-4">
          <vue-simple-markdown :source="request.requester.justification" />
        </div>
      </span>
    </p>

    <document-review
      :document-id="documentId"
      :can-edit="canEdit"
      :request="request"
      :has-permission="isResponsible"
    />
  </base-term-layout>
</template>

<script>

import baseTermData from './base-term-data';
import BaseTermLayout from './base-term-layout';
import DocumentReview from '../document-review';

export default {
  name: 'TermOfAbandonment',

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

    canEdit: {
      type: Boolean,
      required: false,
      default() {
        return false;
      }
    },
  },
};
</script>
