# Domain specs load the pure domain only: no database, no server, so they
# stay fast and crytic can mutate them in isolation.
require "spec"
require "../../src/domain/health"
require "../../src/domain/family"
require "../../src/domain/quests"
require "../../src/domain/progression"
require "../../src/domain/meals"
require "../../src/domain/agenda"

PARIS = Time::Location.load("Europe/Paris")

def paris(year, month, day, hour = 8, minute = 0) : Time
  Time.local(year, month, day, hour, minute, location: PARIS)
end

def weighing(kilograms : Float64, at time : Time) : Health::Weighing
  Health::Weighing.new(measured_at: time, kilograms: Health::Kilograms.new(kilograms))
end
