class Charts::LineComponent < ViewComponent::Base
  def initialize(series:, categories:, title:, options: {})
    @series = series
    @categories = categories
    @title = title
    @x_axis_title = options[:x_axis_title] || ''
    @y_axis_title = options[:y_axis_title] || ''
    @colors = options[:colors] || []
    @height = options[:height] || 350
  end

  def chart_options
    {
      chart: chart_config,
      title: { text: @title, align: 'left' },
      markers: { size: 6 },
      xaxis: xaxis_config,
      yaxis: yaxis_config,
      legend: legend_config,
      series: @series,
      colors: @colors
    }
  end

  private

  def chart_config
    {
      type: 'line',
      height: @height,
      shadow: shadow_config,
      toolbar: { show: false }
    }
  end

  def shadow_config
    { enabled: true, color: '#000', top: 18, left: 7, blur: 10, opacity: 1 }
  end

  def xaxis_config
    { categories: @categories, title: { text: @x_axis_title } }
  end

  def yaxis_config
    { title: { text: @y_axis_title }, tickAmount: 3, min: 0 }
  end

  def legend_config
    { position: 'top', horizontalAlign: 'right', floating: true, offsetY: -25, offsetX: -5 }
  end
end
