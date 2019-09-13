<template>
  <div class="site-table table-responsive w-100">
    <table class="table border border-gray card-table table-striped table-vcenter text-nowrap">
      <thead>
        <tr>
          <th>Acadêmico</th>
          <th>Título</th>
          <th>Orientador</th>
          <th>Coorientadores</th>
        </tr>
      </thead>

      <tbody>
        <tr v-show="noResults">
          <td
            colspan="5"
            class="text-center"
          >
            Nenhuma orientação encontrada!
          </td>
        </tr>
        <tr
          v-for="orientation in orientations"
          :key="orientation.id"
        >
          <td>{{ orientation.academic.name }}</td>
          <td>
            <span
              data-toggle="tooltip"
              :title="orientation.title"
            >
              {{ orientation.short_title }}
            </span>
          </td>
          <td>{{ orientation.advisor.name_with_scholarity }}</td>
          <td>
            <span
              v-for="supervisor in orientation.supervisors"
              :key="supervisor.id"
            >
              <p class="m-0">
                {{ supervisor.name }}
              </p>
            </span>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>

export default {
  name: 'OrientationsTable',

  props: {
    data: {
      type: Array,
      required: true
    },
  },

  data() {
    return {
      orientations: []
    };
  },

  computed: {
    noResults() {
      return this.orientations.length === 0;
    },
  },

  mounted() {
    this.updateOrientations();
  },

  methods: {
    updateOrientations(data = this.data) {
      this.orientations = data;
    },
  },
};

</script>
