<template>
  <div>
    <apexchart
      type="donut"
      width="270"
      :options="chartOptions"
      :series="series"
    />
  </div>
</template>

<script>

import VueApexCharts from 'vue-apexcharts';

export default {
  name: 'OrientationChart',

  components: { 'apexchart': VueApexCharts },

  props: {
    data: {
      type: Object,
      required: true
    },

    title: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      series: [],
      chartOptions: {
        labels: ['Em andamento', 'Aprovadas', 'Renovadas', 'Canceladas'],
        legend: {
          position: 'bottom',
        },
        title: {},
        responsive: [{
          breakpoint: 200,
          options: {
            chart: {
              width: 100
            },
          }
        }]
      }
    };
  },

  created() {
    this.setTitle();
  },

  mounted() {
    this.setSeries();
  },

  methods: {
    setSeries() {
      const orientations = this.data;

      this.series = [orientations.in_progress,
        orientations.approved,
        orientations.renewed,
        orientations.canceled];
    },

    setTitle() {
      this.chartOptions.title.text = this.title;
    },
  },
};

</script>
