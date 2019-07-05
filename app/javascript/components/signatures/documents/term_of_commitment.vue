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
            {{ documentTitle.toUpperCase() }}
          </h4>
        </div>

        <p>
          Eu, <b>{{ advisorScholarity.abbr }} {{ advisor.name }}</b>, {{ advisorLabel }} desta instituição,
          declaro para os devidos fins, estar de acordo em assumir a orientação do trabalho
          de conclusão de curso do acadêmico <b>{{ academic.name }}</b>, RA {{ academic.ra }}.
        </p>

        <p>
          Tema: <b>{{ orientationTitle }}</b>
        </p>

        <div v-if="hasProfessorSupervisors()">
          <p>
            <b>{{ professorSupervisorLabel }}:</b> <br>
            <span
              v-for="professorSupervisor in professorSupervisors"
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
              v-for="externalMemberSupervisor in externalMemberSupervisors"
              :key="externalMemberSupervisor.id"
              class="ml-4"
            >
              {{ externalMemberSupervisor.name }} <br>
            </span>
          </p>
        </div>

        <div v-if="hasInstitution()">
          <p>
            <b>TCC Desenvolvido em Parceria com a Instituição:</b> <br>
            <span class="ml-4">
              Nome fantasia: {{ institution.trade_name }}
            </span><br>
            <span class="ml-4">
              Responsável: {{ institutionResponsible.name }}
            </span><br>
          </p>
        </div>
        <div class="float-right">
          <p :style="{ 'margin-top': marginTitle + 'px', 'margin-bottom': marginTitle + 'px' }">
            Guarapuava, {{ orientationDate }}.
          </p>
        </div>
        <div class="clearfix" />
        <signature-mark
          :url="urlSignaturesMark"
        />
      </div>
    </div>
    <signature-status
      :url="urlSignaturesStatus"
    />
  </div>
</template>

<script>

import baseTerm from './base_term';
import TermHeader from './partials/term_header';
import SignatureStatus from '../signature_status';

export default {
  name: 'TermOfCommitment',

  components: { TermHeader, SignatureStatus },

  mixins: [baseTerm],
};
</script>
