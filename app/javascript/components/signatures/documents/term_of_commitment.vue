<template>
  <base-term-layout
    :url-signature-mark="urlSignatureMark"
    :url-signature-code="urlSignatureCode"
    :url-signature-data="urlSignatureData"
  >
    <p>
      Eu, <b>{{ term.advisor.name }}</b>, {{ term.advisor.label }} desta instituição,
      declaro para os devidos fins, estar de acordo em assumir a orientação do trabalho
      de conclusão de curso do acadêmico <b>{{ term.academic.name }}</b>, RA {{ term.academic.ra }}.
    </p>

    <p>
      <b>Tema</b>: <br>
      <span class="ml-4">
        {{ term.orientation.title }}
      </span>
    </p>

    <div v-if="hasProfessorSupervisors()">
      <p>
        <b>{{ professorSupervisorLabel }}:</b> <br>
        <span
          v-for="professorSupervisor in term.professorSupervisors"
          :key="professorSupervisor.id"
          class="ml-4"
        >
          {{ professorSupervisor.name }} <br>
        </span>
      </p>
    </div>

    <div v-if="hasExternalMemberSupervisors()">
      <p>
        <b>{{ externalMemberSupervisorLabel }}:</b> <br>
        <span
          v-for="externalMemberSupervisor in term.externalMemberSupervisors"
          :key="externalMemberSupervisor.id"
          class="ml-4"
        >
          {{ externalMemberSupervisor.name }} <br>
        </span>
      </p>
    </div>

    <div v-if="hasInstitution()">
      <p>
        <b>TCC desenvolvido em parceria com a instituição:</b> <br>
        <span class="ml-4">
          Nome fantasia: {{ term.institution.trade_name }}
        </span><br>
        <span class="ml-4">
          Responsável: {{ term.institution.responsible }}
        </span><br>
      </p>
    </div>
  </base-term-layout>
</template>

<script>

import baseTermData from './base_term_data';
import BaseTermLayout from './base_term_layout';

export default {
  name: 'TermOfCommitment',

  components: { BaseTermLayout },

  mixins: [baseTermData],
};
</script>
