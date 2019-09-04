<template>
  <div
    id="chart"
    class="card"
  >
    <div class="card-header">
      <div class="card-title font-weight-bold">
        Ranking dos professores
      </div>
    </div>
    <div class="card-body">
      <apexchart
        type="bar"
        height="350"
        :options="chartOptions"
        :series="series"
      />
    </div>
  </div>
</template>

<script>

import VueApexCharts from 'vue-apexcharts';

export default {
  name: 'ProfessorsRanking',

  components: { 'apexchart': VueApexCharts },

  props: {
    ranking: {
      type: Array,
      required: true
    },
  },

  data() {
    return {
      series: [{
        name: 'Número de orientações concluídas',
        data: [],
      }],
      chartOptions: {
        title: {
          text: 'Número de orientações concluídas',
        },
        plotOptions: {
          bar: {
            horizontal: true,
          }
        },
        xaxis: {
          categories: [],
        }
      },
    };
  },

  created() {
    this.setOrientations();
    this.setProfessors();
  },

  methods: {
    setProfessors() {
      this.chartOptions.xaxis.categories = this.ranking.map((item) => {
        return item.professor;
      });
    },

    setOrientations() {
      const data = this.ranking.map((item) => {
        return item.approved_orientations;
      });

      const name = 'Número de orientações concluídas';
      this.series = [{name: name, data: data}];
    },
  },
};

</script>
