<template>
  <div>
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
  name: 'TermOfCommitment',

  components: { TermHeader },

  mixins: [baseTerm],
};
</script>
