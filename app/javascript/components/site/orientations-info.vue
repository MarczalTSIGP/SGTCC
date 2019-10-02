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

      <a href="#">Proposta</a>,
      <a href="#">Projeto</a>,
      <a href="#">Monografia</a>,
      <a href="#">Arquivos complementares</a>
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
