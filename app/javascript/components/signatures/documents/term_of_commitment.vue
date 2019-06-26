<template>
  <div
    v-show="open"
    class="container card"
  >
    <div class="card-body signature-document w-80">
      <div class="row mb-6">
        <div class="col-md-4 col-sm-12">
          <img
            class="img-fluid mb-2"
            alt="logo_utfpr"
            src="../../../../assets/images/utfpr_logo.png"
          >
        </div>
        <div class="col-md-8 col-sm-12">
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

      <div
        class="d-block w-80"
        :style="{ 'margin-top': marginTitle + 'px', 'margin-bottom': marginTitle + 'px' }"
      >
        <h2 class="text-center">
          {{ documentTitle }}
        </h2>
      </div>

      <p>
        Eu, <b>{{ advisor.name }}</b>, {{ advisorLabel }} desta instituição,
        declaro para os devidos fins, estar de acordo em assumir a orientação do trabalho
        de conclusão de curso do acadêmico:
      </p>

      <p>
        Nome: {{ academic.name }}<br>
        RA: {{ academic.ra }}<br>
        E-mail: {{ academic.email }}
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
          >
            Nome: {{ professorSupervisor.name }} <br>
          </span>
        </p>
      </div>

      <div v-if="hasExternalMemberSupervisors()">
        <p>
          <b>{{ externalMemberSupervisorLabel }}:</b> <br>
          <span
            v-for="externalMemberSupervisor in externalMemberSupervisors"
            :key="externalMemberSupervisor.id"
          >
            Nome: {{ externalMemberSupervisor.name }} <br>
          </span>
        </p>
      </div>
      <div v-if="hasInstitution()">
        <p>
          <b>Instituição externa:</b> <br>
          {{ institution.trade_name }}
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
      marginTitle: 50,
    };
  },

  computed: {
    externalMemberSupervisorLabel() {
      return this.externalMemberSupervisors.length === 1
        ? 'Coorientador externo'
        : 'Coorientadores externos';
    },

    professorSupervisorLabel() {
      return this.professorSupervisors.length === 1
        ? 'Coorientador da UTFPR'
        : 'Coorientadores da UTFPR';
    },
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
