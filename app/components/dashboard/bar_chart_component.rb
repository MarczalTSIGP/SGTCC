# app/components/dashboard/bar_chart_component.rb
class Dashboard::BarChartComponent < ViewComponent::Base
    def initialize(series:, categories:, title:, height: 350)
      @series = series
      @categories = categories
      @title = title
      @height = height
    end
  
    def chart_id
      "bar-chart-#{SecureRandom.hex(4)}"
    end
  
    def chart_options
      {
        chart: {
          type: "bar",
          height: @height,
          toolbar: { show: false }
        },
        plotOptions: {
          bar: {
            horizontal: true
          }
        },
        dataLabels: { enabled: true },
        xaxis: {
          categories: @categories,
          labels: {}
        },
        tooltip: {
          y: {}
        },
        title: { text: @title, align: "left" }
      }
    end
  
    attr_reader :series, :height
  end
  