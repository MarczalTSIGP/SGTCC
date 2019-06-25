<template>
  <div
    v-show="open"
    class="container card"
  >
    <div class="card-body w-80">
      <div class="row mb-6">
        <div class="col-3">
          <img
            src="../../../../assets/images/utfpr_logo.png"
            :style="{ width: logoWidth + 'px', height: logoHeight + 'px' }"
          >
        </div>
        <div class="col-9">
          <p class="m-0">
            Ministério da Educação
          </p>
          <p class="m-0">
            Universidade Tecnológica Federal do Paraná
          </p>
          <p class="m-0">
            Câmpus Guarapuava
          </p>
          <p class="m-0">
            Curso Superior de Tecnologia em Sistemas para a Internet
          </p>
        </div>
      </div>

      <div class="d-block w-80">
        <h2 class="text-center">
          {{ documentTitle }}
        </h2>
      </div>

      <p>
        Eu, <b>{{ advisor.name }}</b>, {{ advisorLabel }} desta instituição,
        declaro para os devidos fins, estar de acordo em assumir a orientação do trabalho
        de conclusão de curso do acadêmico:
      </p>

      <p> RA: {{ academic.ra }}</p>
      <p> Nome: {{ academic.name }}</p>
      <p> E-mail: {{ academic.email }}</p>
      <p> Tema: {{ orientationTitle }}</p>

      <div v-if="hasProfessorSupervisors()">
        <p> Coorientadores da UTFPR: </p>

        <p
          v-for="professorSupervisor in professorSupervisors"
          :key="professorSupervisor.id"
        >
          Nome: {{ professorSupervisor.name }}
        </p>
      </div>

      <div v-if="hasExternalMemberSupervisors()">
        <p> Coorientadores externos: </p>

        <p
          v-for="externalMemberSupervisor in externalMemberSupervisors"
          :key="externalMemberSupervisor.id"
        >
          Nome: {{ externalMemberSupervisor.name }}
        </p>
      </div>
      <div v-if="hasInstitution()">
        <p>
          Instituição externa: {{ institution.trade_name }}
        </p>
      </div>
      <div class="float-right">
        <p>
          Guarapuava, {{ orientationDate }}.
        </p>
      </div>
      <div class="clearfix" />
      <signature-mark
        :url="urlSignaturesMark"
      />
    </div>
  </div>
</template>

<script>

import baseTerm from './base_term';

export default {
  name: 'TermOfCommitment',

  mixins: [baseTerm],

  data() {
    return {
      open: true,
      signedDocument: false,
      logoWidth: 260,
      logoHeight: 120,
    };
  },

  mounted() {
    this.onCloseTermOfCommitment();
    this.onOpenTermOfCommitment();
    this.setSignedDocument();
  },

  methods: {
    setSignedDocument() {
      this.signedDocument = this.signed;
    },

    hasProfessorSupervisors() {
      return this.professorSupervisors.length > 0;
    },

    hasExternalMemberSupervisors() {
      return this.externalMemberSupervisors.length > 0;
    },

    hasInstitution() {
      return this.institution !== null;
    },

    onCloseTermOfCommitment() {
      this.$root.$on('close-term-of-commitment', () => {
        this.open = false;
      });
    },

    onOpenTermOfCommitment() {
      this.$root.$on('open-term-of-commitment', () => {
        this.open = true;
      });
    },
  },
};
</script>
