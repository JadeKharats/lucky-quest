# What a parent fills in for a member: a name, and for a guest the last day
# she may come in (inclusive, Paris time).
module MemberDetails
  DATE_FORMAT = "%F"

  macro included
    attribute last_day : String
    before_save check_member_details
  end

  private def check_member_details
    validate_required name, message: "Indiquez un prénom."
    if role.value.try(&.time_limited?)
      end_access_after_last_day
    else
      access_ends_at.value = nil
    end
  end

  private def end_access_after_last_day
    if day = parse_last_day
      access_ends_at.value = Family::AccessWindow.through(day).ends_at
    else
      last_day.add_error "Indiquez le dernier jour d'accès."
    end
  end

  private def parse_last_day : Time?
    Time.parse(last_day.value.to_s.strip, DATE_FORMAT, Household::TIME_ZONE)
  rescue Time::Format::Error
    nil
  end
end
