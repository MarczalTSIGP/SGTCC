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
          <markdown-reader :content="request.requester.justification" />
        </div>
      </span>
    </p>

    <document-review
      :document-id="documentId"
      :request="request"
      :can-edit="canEdit"
      :has-permission="isResponsible"
    />
  </base-term-layout>
</template>

<script>

import baseTermData from './base-term-data';
import BaseTermLayout from './base-term-layout';
import DocumentReview from '../document-review';
import MarkdownReader from '../../shared/markdown-reader';

export default {
  name: 'TermOfExtension',

  components: { BaseTermLayout, DocumentReview, MarkdownReader },

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
