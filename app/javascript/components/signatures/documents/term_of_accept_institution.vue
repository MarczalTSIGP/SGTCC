<template>
  <base-term-layout
    :url-signature-mark="urlSignatureMark"
    :url-signature-code="urlSignatureCode"
    :url-signature-data="urlSignatureData"
    :url-signature-image="urlSignatureImage"
    :url-header-image="urlHeaderImage"
  >
    <p>
      Eu, <b>{{ term.institution.responsible }}</b>, como representante da instituição
      <b>{{ term.institution.trade_name }}</b>, afirmo que o acadêmico <b>{{ term.academic.name }}</b>,
      RA {{ term.academic.ra }}, do curso de Tecnolgia em Sistemas para Internet da Universidade
      Tecnológica Federal do Paraná do Câmpus Guarapuava, orientado pelo professor
      <b>{{ term.advisor.name }}</b>, possa realizar as atividades de seu trabalho
      de conclusão de curso nesta instituição, sem prejuízo desde que ambas as partes preservem a ética
      necessária.
    </p>

    <p>
      Por meio deste termo a empresa autoriza a divulgação do seu nome para fins de desenvolvimento e
      publicação do TCC. Além disso, o aluno se compromete em não divulgar dados sigilosos da empresa
      que foram necessários para a realização do TCC.
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
  </base-term-layout>
</template>

<script>

import baseTermData from './base_term_data';
import BaseTermLayout from './base_term_layout';

export default {
  name: 'TermOfAcceptInstitution',

  components: { BaseTermLayout },

  mixins: [baseTermData],
};
</script>
