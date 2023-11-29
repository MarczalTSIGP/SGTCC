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

  components: { apexchart: VueApexCharts },

  props: {
    data: {
      type: Array,
      required: true
    }
  },

  data() {
    return {
      series: [],
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
        colors: [
          '#85CC00',
          '#009900',
          '#FFFF00',
          '#FF9933',
          '#E35665',
          '#D9041A'
        ],
        dataLabels: {
          enabled: true
        },
        stroke: {
          curve: 'smooth'
        },
        title: {
          text: 'Ano/Semestre',
          align: 'left'
        },
        grid: {
          borderColor: '#e7e7e7',
          row: {
            colors: ['#f3f3f3', 'transparent'],
            opacity: 0.5
          }
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
            text: 'Nº de orientações'
          },
          labels: {
            formatter: function(val) {
              return parseInt(val);
            }
          },
          tickAmount: 3,
          min: 0,
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
      this.series = this.data.map(item => {
        return { name: item.label, data: item.data.total };
      });
    },

    setCategories() {
      this.chartOptions.xaxis.categories = this.data[0].data.years;
    },

    setMaxValue() {
      this.chartOptions.yaxis.max = this.getMaxValue();
    },

    getMaxValue() {
      return this.getAllValues().reduce((a, b) => {
        return Math.max(a, b);
      });
    },

    getAllValues() {
      let values = [];

      this.data.forEach(item => {
        item.data.total.forEach(value => {
          values.push(value);
        });
      });

      return values;
    }
  }
};
</script>
