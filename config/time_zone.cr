# The family lives in France: days start at midnight in Paris, whatever the
# server's clock says. The production image ships this zone's tzdata.
module Quest
  TIME_ZONE = Time::Location.load("Europe/Paris")
end
