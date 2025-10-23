class Charts::LineChartComponent < ViewComponent::Base
    def initialize(series:, categories:, title:, xAxisTitle:, yAxisTitle:, colors: [], height: 350)
      @series = series
      @categories = categories
      @title = title
      @xAxisTitle = xAxisTitle
      @yAxisTitle = yAxisTitle
      @colors = colors
      @height = height
    end
  
    def chart_options
      {
        chart: {
          type: "line",
          height: @height,
          shadow: {
            enabled: true,
            color: "#000",
            top: 18,
            left: 7,
            blur: 10,
            opacity: 1
          },
          toolbar: { show: false }
        },
        title: { text: @title, align: "left" },
        markers: { size: 6 },
        xaxis: {
          categories: @categories,
          title: { text: @xAxisTitle }
        },
        yaxis: {
          title: { text: @yAxisTitle },
          tickAmount: 3,
          min: 0
        },
        legend: {
          position: "top",
          horizontalAlign: "right",
          floating: true,
          offsetY: -25,
          offsetX: -5
        },
        series: @series,
        colors: @colors
      }
    end
  end
  