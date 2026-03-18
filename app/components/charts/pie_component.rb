class Charts::PieComponent < ViewComponent::Base
  def initialize(series:, title:, labels:, options: {})
    @series = series
    @title = title
    @labels = labels
    @colors = options[:colors] || []
    @links = options[:links] || []
    @width = options[:width] || '90%'
    @height = options[:height] || 280
    @legend_position = options[:legend_position] || 'right'
  end

  private

  attr_reader :series, :title, :labels, :colors, :links, :width, :height, :legend_position

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
      responsive: responsive_config
    }
  end

  def responsive_config
    [
      {
        breakpoint: 1000,
        options: { chart: { width: 200 }, legend: { position: 'bottom' } }
      }
    ]
  end
end
