<template>
  <div
    v-if="load"
    class="row"
  >
    <div class="col-md-4 col-sm-12">
      <professors-number
        label="Cadastrados no SGTCC"
        background-color="primary"
        :number="report.professors.total"
        redirect="/responsible/professors"
      />
    </div>

    <div class="col-md-4 col-sm-12">
      <professors-number
        label="Disponíveis para orientação"
        background-color="green"
        :number="report.professors.available"
        redirect="/responsible/professors/available"
      />
    </div>

    <div class="col-md-4 col-sm-12">
      <professors-number
        label="Indisponíveis para orientação"
        background-color="red"
        :number="report.professors.unavailable"
        redirect="/responsible/professors/unavailable"
      />
    </div>
    <div class="col-12">
      <orientations-report :data="report.orientations" />
    </div>
  </div>
</template>

<script>

import ProfessorsNumber from './professors/professors_number';
import OrientationsReport from './orientations/orientations_report';

export default {
  name: 'ResponsibleDashboard',

  components: {
    OrientationsReport,
    ProfessorsNumber
  },

  data() {
    return {
      url: '/responsible/reports',
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
