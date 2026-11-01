class Weighing < BaseModel
  table do
    column measured_at : Time
    column kilograms : Float64
    belongs_to user : User
  end

  def to_domain : Health::Weighing
    Health::Weighing.new(measured_at: measured_at, kilograms: Health::Kilograms.new(kilograms))
  end
end
