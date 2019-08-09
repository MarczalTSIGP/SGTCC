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
  name: 'TermOfAbandonment',

  components: { BaseTermLayout },

  mixins: [baseTermData],
};
</script>
