# The role is chosen once: a parent cannot lock themselves out by mistake.
class UpdateMember < User::SaveOperation
  param_key :member
  include MemberDetails

  permit_columns name, school_id

  before_save do
    check_school
  end

  def self.form_for(member : User) : self
    new(member, last_day: member.access_window.last_day.try(&.to_s(DATE_FORMAT)) || "")
  end

  # Only a daughter has a school, and it must exist.
  private def check_school
    if !role.value.try(&.child?)
      school_id.value = nil
    elsif (id = school_id.value) && SchoolQuery.new.id(id).first?.nil?
      school_id.add_error "Cette école n'existe pas."
    end
  end
end
