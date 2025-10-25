class Charts::BarChartComponent < ViewComponent::Base
  def initialize(series:, categories:, title:, height: 350)
    @series = series
    @categories = categories
    @title = title
    @height = height
  end

  def chart_options
    {
      chart: chart_config,
      plotOptions: plot_options_config,
      dataLabels: { enabled: true },
      xaxis: xaxis_config,
      tooltip: { y: {} },
      title: { text: @title, align: 'left' }
    }
  end

  private

  def chart_config
    { type: 'bar', height: @height, toolbar: { show: false } }
  end

  def plot_options_config
    { bar: { horizontal: true } }
  end

  def xaxis_config
    { categories: @categories, labels: {} }
  end

  attr_reader :series, :height
end
