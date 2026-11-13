# Período acadêmico: um semestre (1 ou 2) de um ano. Imutável e comparado por valor.
#
# Concentra a aritmética que antes estava espalhada: semestre seguinte e anterior (com
# virada de ano), o semestre de uma data e o intervalo de datas de cada semestre
# (1º: janeiro a junho; 2º: julho a dezembro). Não altera o enum `semester` persistido
# (`one: 1, two: 2`); só traduz de e para ele.
#
# Definido com bloco (e não herança de `Data.define`); por isso não há constantes aqui
# dentro: elas iriam para o escopo de topo, não para a classe.
AcademicPeriod = Data.define(:year, :semester) do
  include Comparable

  def self.from_calendar(calendar)
    new(year: calendar.year, semester: Calendar.semesters.fetch(calendar.semester))
  end

  def self.from_date(date)
    new(year: date.year, semester: date.month <= 6 ? 1 : 2)
  end

  def initialize(year:, semester:)
    unless [1, 2].include?(semester)
      raise ArgumentError, "Unsupported semester: #{semester.inspect}"
    end

    super(year: Integer(year.to_s, 10), semester:)
  end

  def next
    first? ? with(semester: 2) : self.class.new(year: year + 1, semester: 1)
  end

  def previous
    first? ? self.class.new(year: year - 1, semester: 2) : with(semester: 1)
  end

  def first?
    semester == 1
  end

  # Chave do enum `semester` de `Calendar` (`:one`/`:two`).
  def semester_key
    first? ? :one : :two
  end

  def first_day
    Date.new(year, first? ? 1 : 7, 1)
  end

  def last_day
    Date.new(year, first? ? 6 : 12, -1)
  end

  def <=>(other)
    return unless other.is_a?(AcademicPeriod)

    [year, semester] <=> [other.year, other.semester]
  end

  def to_s
    "#{year}/#{semester}"
  end
end
