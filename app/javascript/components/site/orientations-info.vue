<template>
  <div>
    <div
      v-for="orientation in orientations"
      :key="orientation.id"
      class="mb-4"
    >
      <a href="#">{{ orientation.title }}</a><br>

      <strong>Acadêmico:</strong>
      {{ orientation.academic.name }}<br>

      <strong>Orientador:</strong>
      {{ orientation.advisor.name }}<br>

      <strong>Coorientador(es):</strong>
      {{ supervisorsFormatted(orientation) }}<br>

      <strong>Documentos:</strong>
      <a href="#">Proposta</a>,
      <a href="#">Projeto</a>,
      <a href="#">Monografia</a>,
      <a href="#">Arquivos complementares</a>
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
      let supervisors = orientation.supervisors.map((supervisor) => {
        return supervisor.name;
      });
      return supervisors.join(',');
    },
  },
};

</script>
