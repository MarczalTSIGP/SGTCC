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

  components: { apexchart: VueApexCharts },

  props: {
    ranking: {
      type: Array,
      required: true
    }
  },

  data() {
    return {
      series: [
        {
          name: 'Número de orientações concluídas',
          data: []
        }
      ],
      chartOptions: {
        title: {
          text: 'Número de orientações concluídas'
        },
        plotOptions: {
          bar: {
            horizontal: true
          }
        },
        dataLabels: {
          formatter: function(val) {
            return parseInt(val);
          }
        },
        xaxis: {
          categories: [],
          labels: {
            formatter: function(val) {
              return parseInt(val);
            }
          }
        },
        tooltip: {
          y: {
            formatter: function(val) {
              return parseInt(val);
            }
          }
        }
      }
    };
  },

  created() {
    this.setOrientations();
    this.setProfessors();
  },

  methods: {
    setProfessors() {
      this.chartOptions.xaxis.categories = this.ranking.map((item, index) => {
        return `${index + 1}º ${item[0]}`;
      });
    },

    setOrientations() {
      const data = this.ranking.map(item => {
        return item[1];
      });

      const name = 'Número de orientações concluídas';
      this.series = [{ name: name, data: data }];
    }
  }
};
</script>
