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

    title: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      series: [
        {
          name: 'Aprovados TCC 2',
          data: [3, 1, 1, 5, 4, 3, 3]
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
          categories: ['2013/1', '2014/1', '2015/1', '2015/2', '2016/1', '2016/2', '2017/1'],
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
};

</script>
