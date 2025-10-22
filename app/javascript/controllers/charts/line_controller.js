import { Controller } from "@hotwired/stimulus"
import ApexCharts from "apexcharts"

export default class extends Controller {
  static values = { options: Object }

  connect() {
    if (!this.optionsValue) {
      console.error("Chart options missing!")
      return
    }

    const options = this.optionsValue

    if (!options.dataLabels) options.dataLabels = {}
    options.dataLabels.formatter = function(val, opts) {
      return opts.w.config.series[opts.seriesIndex].data ? opts.w.config.series[opts.seriesIndex].data[opts.dataPointIndex] : val
    }

    if (options.yaxis) {
      if (!options.yaxis.labels) options.yaxis.labels = {}
      options.yaxis.labels.formatter = function(val) { return parseInt(val) }
    }

    this.chart = new ApexCharts(this.element, options)
    this.chart.render()
  }

  disconnect() {
    if (this.chart) this.chart.destroy()
  }
}
