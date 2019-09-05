<template>
  <div v-if="load && hasTccReport()">
    <div class="card">
      <div class="card-header">
        <h3 class="card-title font-weight-bold">
          Orientações
        </h3>
      </div>
      <div class="card-body">
        <div class="row">
          <div
            v-if="hasTccOneReport()"
            :class="cardResponsiveClass"
          >
            <div class="card">
              <div class="card-body">
                <orientations-chart
                  title="Orientações de TCC 1 no Total"
                  :data="report.tcc_one"
                />
              </div>
            </div>
          </div>

          <div
            v-if="hasTccTwoReport()"
            :class="cardResponsiveClass"
          >
            <div class="card">
              <div class="card-body">
                <orientations-chart
                  title="Orientações de TCC 2 no Total"
                  :data="report.tcc_two"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

import OrientationsChart from '../orientations/orientations_chart';

export default {
  name: 'ProfessorsOrientationsReport',

  components: { OrientationsChart },

  props: {
    professorId: {
      type: Number,
      required: true
    },
  },

  data() {
    return {
      load: false,
      report: {},
    };
  },

  computed: {
    url() {
      return `/professors/reports/${this.professorId}`;
    },

    cardResponsiveClass() {
      return this.hasBothTccReport() ? 'col-md-6' : 'col-12';
    },
  },

  mounted() {
    this.setReport();
  },

  methods: {
    async setReport() {
      const report = await this.$axios.get(this.url);
      this.report = report.data.orientations;
      this.load = true;
    },

    hasTccReport() {
      return this.hasTccOneReport() || this.hasTccTwoReport();
    },

    hasBothTccReport() {
      return this.hasTccOneReport() && this.hasTccTwoReport();
    },

    hasTccOneReport() {
      return this.report.tcc_one.total > 0;
    },

    hasTccTwoReport() {
      return this.report.tcc_two.total > 0;
    },
  },
};

</script>
