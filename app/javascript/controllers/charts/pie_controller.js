import { Controller } from "@hotwired/stimulus";
import ApexCharts from "apexcharts";

export default class extends Controller {
  static values = { 
    series: Array,
    options: Object,
    links: Array,
    width: String,
    height: Number
  };
  
  connect() {
    if (!this.seriesValue || !this.optionsValue) return;

    const chartOptions = {
      series: this.seriesValue,
      chart: {
        type: "pie",
        width: this.widthValue,
        height: this.heightValue,
        events: {
          dataPointSelection: (event, chartContext, { dataPointIndex }) => {
            const link = this.linksValue?.[dataPointIndex];
            if (link) window.location.href = link;
          }
        }
      },
      dataLabels: {
        formatter: (val, { seriesIndex, w }) => {
          return w.config.series[seriesIndex];
        }
      },
      ...this.optionsValue
    };

    this.chart = new ApexCharts(this.element, chartOptions);
    this.chart.render();
  }

  disconnect() {
    if (this.chart) this.chart.destroy();
  }
}
