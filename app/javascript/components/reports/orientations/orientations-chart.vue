<template>
  <div>
    <div>
      <apexchart
        type="pie"
        width="90%"
        height="280"
        :options="chartOptions"
        :series="series"
      />
    </div>
    <a
      ref="redirect"
      href="#"
    />
  </div>
</template>

<script>
import VueApexCharts from 'vue-apexcharts';

export default {
  name: 'OrientationChart',

  components: { apexchart: VueApexCharts },

  props: {
    data: {
      type: Object,
      required: true
    },

    title: {
      type: String,
      required: true
    }
  },

  data() {
    return {
      series: [],
      chartOptions: {
        labels: ['Em andamento', 'Aprovadas', 'Renovadas', 'Canceladas'],
        legend: {
          position: 'right'
        },
        title: {},
        chart: {
          events: {
            legendClick: (event, seriesIndex) => {
              const link = this.$refs.redirect;
              link.href = this.data.links[seriesIndex];
              link.click();
            }
          }
        },
        dataLabels: {
          formatter: (val, { seriesIndex, w }) => {
            return w.config.series[seriesIndex];
          }
        },
        responsive: [
          {
            breakpoint: 1000,
            options: {
              chart: {
                width: 200
              },
              legend: {
                position: 'bottom'
              }
            }
          }
        ]
      }
    };
  },

  created() {
    this.setTitle();
    this.setSeries();
  },

  methods: {
    setSeries() {
      const orientations = this.data;

      this.series = [
        orientations.in_progress,
        orientations.approved,
        orientations.renewed,
        orientations.canceled
      ];
    },

    setTitle() {
      this.chartOptions.title.text = `${this.data.total} ${this.title}`;
    }
  }
};
</script>
