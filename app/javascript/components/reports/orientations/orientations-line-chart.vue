<template>
  <div>
    <apexchart
      type="line"
      height="350"
      :options="chartOptions"
      :series="series"
    />
  </div>
</template>

<script>

import VueApexCharts from 'vue-apexcharts';

export default {
  name: 'OrientationLineChart',

  components: { 'apexchart': VueApexCharts },

  props: {
    data: {
      type: Object,
      required: true
    },
  },

  data() {
    return {
      series: [
        {
          name: 'Aprovados TCC 2',
          data: [],
        },
      ],
      chartOptions: {
        chart: {
          shadow: {
            enabled: true,
            color: '#000',
            top: 18,
            left: 7,
            blur: 10,
            opacity: 1
          },
          toolbar: {
            show: false
          }
        },
        colors: ['#00E396'],
        dataLabels: {
          enabled: true,
        },
        stroke: {
          curve: 'smooth'
        },
        title: {
          text: 'Aprovadas por ano/semestre',
          align: 'left'
        },
        grid: {
          borderColor: '#e7e7e7',
          row: {
            colors: ['#f3f3f3', 'transparent'],
            opacity: 0.5
          },
        },
        markers: {
          size: 6
        },
        xaxis: {
          categories: [],
          title: {
            text: 'Ano'
          }
        },
        yaxis: {
          title: {
            text: 'Nº de aprovados'
          },
          labels: {
            formatter: function (val) {
              return parseInt(val);
            },
          },
          tickAmount: 3,
          min: 1,
          max: 6
        },
        legend: {
          position: 'top',
          horizontalAlign: 'right',
          floating: true,
          offsetY: -25,
          offsetX: -5
        }
      }
    };
  },

  created() {
    this.setSeries();
    this.setCategories();
    this.setMaxValue();
  },

  methods: {
    setSeries() {
      this.series[0].data = this.data.total;
    },

    setCategories() {
      this.chartOptions.xaxis.categories = this.data.years;
    },

    setMaxValue() {
      this.chartOptions.yaxis.max = this.getMaxValue();
    },

    getMaxValue() {
      return this.data.total.reduce((a, b) => {
        return Math.max(a, b);
      });
    },
  },

};
</script>
