module Health
  # A body weight, to the nearest 100 g.
  struct Kilograms
    include Comparable(Kilograms)

    BOUNDS = 20.0..300.0
    NUMBER = /\A\d+(?:[.,]\d+)?\z/

    getter value : Float64

    def initialize(value : Float64)
      @value = value.round(1)
      unless BOUNDS.includes?(@value)
        raise ArgumentError.new("A weight must be between 20 and 300 kg, got #{@value}")
      end
    end

    # Reads what a person types: "72,4" (French) or "72.4", nil otherwise.
    def self.parse?(input : String) : Kilograms?
      text = input.strip
      return unless NUMBER.matches?(text)

      value = text.tr(",", ".").to_f
      new(value) if BOUNDS.includes?(value.round(1))
    end

    def <=>(other : Kilograms)
      value <=> other.value
    end

    def to_s(io : IO) : Nil
      io << value.format(decimal_places: 1)
    end
  end
end
