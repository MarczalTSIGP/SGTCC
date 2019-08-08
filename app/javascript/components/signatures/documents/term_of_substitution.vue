<template>
  <base-term-layout :document-id="documentId">
    <p>
      Eu, <b>{{ term.academic.name }}</b>, acadêmico(a) desta instituição,
      solicito a substituição de orientação.
    </p>

    <b>Dados da orientação em andamento</b>
    <span class="ml-4">
      <div>
        <p>
          <span class="ml-4">
            <b>Orientador:</b>
          </span>
          <br>
          <span class="ml-6">
            {{ term.advisor.name }}
          </span>
        </p>
      </div>

      <div v-if="hasProfessorSupervisors()">
        <p>
          <span class="ml-4">
            <b>{{ professorSupervisorLabel }}:</b>
          </span>
          <br>
          <span
            v-for="professorSupervisor in term.professorSupervisors"
            :key="professorSupervisor.id"
            class="ml-6"
          >
            {{ professorSupervisor.name }} <br>
          </span>
        </p>
      </div>

      <div v-if="hasExternalMemberSupervisors()">
        <p>
          <span class="ml-4">
            <b>{{ externalMemberSupervisorLabel }}:</b>
          </span>
          <br>
          <span
            v-for="externalMemberSupervisor in term.externalMemberSupervisors"
            :key="externalMemberSupervisor.id"
            class="ml-6"
          >
            {{ externalMemberSupervisor.name }} <br>
          </span>
        </p>
      </div>
    </span>

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
  name: 'TermOfSubstitution',

  components: { BaseTermLayout },

  mixins: [baseTermData],
};
</script>
