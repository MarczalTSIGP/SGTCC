<template>
  <div>
    <div
      v-for="orientation in orientations"
      :key="orientation.id"
      class="mb-4"
    >
      <a href="#">{{ orientation.title }}</a><br>

      {{ orientation.academic.name }} (acadêmico)<br>

      {{ orientation.advisor.name }} (orientador) <br>

      {{ supervisorsFormatted(orientation) }} (coorientadores)<br>

      <a
        v-if="orientation.academic.final_proposal"
        :href="orientation.academic.final_proposal.pdf.url"
        target="_blank"
      >
        Proposta
      </a>
      <a
        v-if="orientation.academic.final_project"
        :href="orientation.academic.final_project.pdf.url"
        target="_blank"
      >
        , Projeto
      </a>
      <a
        v-if="orientation.academic.final_monograph"
        :href="orientation.academic.final_monograph.pdf.url"
        target="_blank"
      >
        , Monografia
      </a>
      <a
        v-if="orientation.academic.final_monograph"
        :href="orientation.academic.final_monograph.complementary_files.url"
        target="_blank"
      >
        , Arquivos complementares
      </a>
      <hr>
    </div>
  </div>
</template>

<script>

export default {
  name: 'OrientationsInfo',

  props: {
    orientations: {
      type: Array,
      required: true
    },
  },

  computed: {
    noResults() {
      return this.orientations.length === 0;
    },
  },

  methods: {
    supervisorsFormatted(orientation) {
      return orientation.supervisors.map((supervisor) => {
        return supervisor.name;
      }).join(', ');
    },
  },
};

</script>
