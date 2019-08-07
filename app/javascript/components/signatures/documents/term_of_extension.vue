<template>
  <base-term-layout :document-id="documentId">
    <p>
      Eu, <b>{{ term.academic.name }}</b>, acadêmico(a) desta instituição,
      solicito a extensão do prazo de trabalho de conclusão de curso em 1 (um)
      semestre levito.
    </p>

    <p>
      <b>Justificativa</b>: <br>
      <span class="ml-4">
        {{ request.requester.justification }}
      </span>
    </p>
  </base-term-layout>
</template>

<script>

import baseTermData from './base_term_data';
import BaseTermLayout from './base_term_layout';

export default {
  name: 'TermOfExtension',

  components: { BaseTermLayout },

  mixins: [baseTermData],
};
</script>
