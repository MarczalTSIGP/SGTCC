<template>
  <div
    v-if="load"
    class="row"
  >
    <div class="col-12">
      <professors-orientations-report :data="report.orientations" />
    </div>
  </div>
</template>

<script>

import ProfessorsOrientationsReport from './professors/professors-orientations-report';

export default {
  name: 'ProfessorDashboard',

  components: { ProfessorsOrientationsReport },

  data() {
    return {
      url: '/professors/reports',
      load: false,
      report: {},
    };
  },

  mounted() {
    this.setReport();
  },

  methods: {
    async setReport() {
      const report = await this.$axios.get(this.url);
      this.report = report.data;
      this.load = true;
    },
  },
};

</script>
