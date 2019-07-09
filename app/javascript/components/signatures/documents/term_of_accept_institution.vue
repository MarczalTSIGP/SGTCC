<template>
  <div class="container">
    <div
      v-show="open"
      id="term"
      class="card"
    >
      <div
        ref="term"
        class="card-body signature-document w-80"
      >
        <term-header />
        <div
          class="d-block w-80"
          :style="{ 'margin-top': marginTitle + 'px', 'margin-bottom': marginTitle + 'px' }"
        >
          <h4 class="text-center">
            {{ term.title }}
          </h4>
        </div>

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
          Por meio deste Termo a empresa autoriza a divulgação do seu nome para fins da realização do TCC.
          Além disso, o aluno se compromete em não divulgar dados sigilosos da empresa que foram necessários para
          a realização do TCC.
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

        <div class="float-right">
          <p :style="{ 'margin-top': marginTitle + 'px', 'margin-bottom': marginTitle + 'px' }">
            Guarapuava, {{ term.orientation.date }}.
          </p>
        </div>
        <div class="clearfix" />
        <signature-mark
          :url="urlSignatureMark"
          :url-signature-code="urlSignatureCode"
        />
      </div>
    </div>
  </div>
</template>

<script>

import baseTerm from './base_term';
import TermHeader from './partials/term_header';

export default {
  name: 'TermOfAcceptInstitution',

  components: { TermHeader },

  mixins: [baseTerm],
};
</script>
