<template>
  <div
    v-show="open"
    class="card"
  >
    <div class="card-body">
      <div class="d-block w-80">
        <h2 class="text-center">
          {{ documentTitle }}
        </h2>
      </div>

      <p>
        Eu, {{ advisor.name }} professor(a) desta instituição,
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
    </div>
  </div>
</template>

<script>

export default {
  name: 'TermOfCommitment',

  props: {
    orientationTitle: {
      type: String,
      required: true
    },

    documentTitle: {
      type: String,
      required: true
    },

    academic: {
      type: Object,
      required: true
    },

    advisor: {
      type: Object,
      required: true
    },

    professorSupervisors: {
      type: Array,
      required: true
    },

    externalMemberSupervisors: {
      type: Array,
      required: true
    }
  },

  data() {
    return {
      open: true,
    };
  },

  mounted() {
    this.onTermOfCommitmentEvent();
  },

  methods: {
    hasProfessorSupervisors() {
      return this.professorSupervisors.length > 0;
    },

    hasExternalMemberSupervisors() {
      return this.externalMemberSupervisors.length > 0;
    },

    onTermOfCommitmentEvent() {
      this.$root.$on('close-term-of-commitment', () => {
        this.open = false;
      });

      this.$root.$on('open-term-of-commitment', () => {
        this.open = true;
      });
    },
  },
};
</script>
