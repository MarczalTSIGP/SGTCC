import { Controller } from "@hotwired/stimulus";
import ApexCharts from "apexcharts";

export default class extends Controller {
  static values = {
    series: Array,
    options: Object,
    height: Number
  };

  connect() {
    if (!this.seriesValue || !this.optionsValue) {
      console.error("Series or options are missing for bar chart!");
      return;
    }

    const options = JSON.parse(JSON.stringify(this.optionsValue));

    // Garantir funções reais (não strings do Ruby)
    if (!options.dataLabels) options.dataLabels = {};
    options.dataLabels.formatter = function (val) {
      return parseInt(val);
    };

    if (!options.xaxis) options.xaxis = {};
    if (!options.xaxis.labels) options.xaxis.labels = {};
    options.xaxis.labels.formatter = function (val) {
      return parseInt(val);
    };

    if (!options.tooltip) options.tooltip = {};
    if (!options.tooltip.y) options.tooltip.y = {};
    options.tooltip.y.formatter = function (val) {
      return parseInt(val);
    };

    // Adicionar série
    options.series = this.seriesValue;

    this.chart = new ApexCharts(this.element, options);
    this.chart.render();
  }

  disconnect() {
    if (this.chart) this.chart.destroy();
  }
}
