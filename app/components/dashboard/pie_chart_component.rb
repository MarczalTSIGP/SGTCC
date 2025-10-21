class Dashboard::PieChartComponent < ViewComponent::Base
  def initialize(series:, title:, labels:, colors: [], links: [], width: '90%', height: 280, legend_position: 'right', **kwargs)
    @series = series
    @title = title
    @labels = labels
    @colors = colors
    @links = links
    @width = width
    @height = height
    @legend_position = legend_position
    @kwargs = kwargs
  end

  private

  attr_reader :series, :title, :labels, :colors, :links, :width, :height, :legend_position, :kwargs

  def chart_title
    total = series.sum
    "#{total} #{title}"
  end

  def chart_options
    {
      labels: labels,
      colors: colors,
      legend: { position: legend_position },
      title: { text: chart_title },
      responsive: [
        {
          breakpoint: 1000,
          options: {
            chart: { width: 200 },
            legend: { position: 'bottom' }
          }
        }
      ]
    }
  end
end
