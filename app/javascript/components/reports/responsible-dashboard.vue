<template>
  <div v-if="load" class="row">
    <div class="col-12">
      <academics-report :academics="report.academics" />
    </div>
    <div class="col-12">
      <orientations-report :data="report.orientations" />
    </div>
    <div class="col-12">
      <professors-report :professors="report.professors" />
    </div>
    <div class="col-12">
      <professors-ranking :ranking="report.orientations.ranking" />
    </div>
  </div>
</template>

<script>
import ProfessorsRanking from './professors/professors-ranking';
import ProfessorsReport from './professors/professors-report';
import OrientationsReport from './orientations/orientations-report';
import AcademicsReport from './academics/academics-report';

export default {
  name: 'ResponsibleDashboard',

  components: {
    AcademicsReport,
    OrientationsReport,
    ProfessorsRanking,
    ProfessorsReport
  },

  data() {
    return {
      url: '/responsible/reports',
      load: false,
      report: {}
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
    }
  }
};
</script>
