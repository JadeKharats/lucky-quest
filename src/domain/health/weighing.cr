module Health
  # One reading of the scale (or one manual entry).
  record Weighing, measured_at : Time, kilograms : Kilograms
end
