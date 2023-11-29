class Logics::Activity::AcademicResponse
  attr_reader :orientation

  def initialize(academic, sent, orientation)
    @academic = academic
    @sent = sent
    @orientation = orientation
  end

  def sent?
    @sent
  end

  def method_missing(method, *args, &block)
    if @academic.respond_to?(method)
      @academic.send(method, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    super
  end
end
