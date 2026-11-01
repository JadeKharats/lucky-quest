class WeighingFactory < Avram::Factory
  def initialize
    measured_at Time.utc
    kilograms 72.0
  end
end
