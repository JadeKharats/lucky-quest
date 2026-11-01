class CompletionFactory < Avram::Factory
  def initialize
    period_start Time.local(Household::TIME_ZONE).at_beginning_of_day
    done_at Time.utc
  end
end
