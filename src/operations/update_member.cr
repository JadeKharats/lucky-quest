# The role is chosen once: a parent cannot lock themselves out by mistake.
class UpdateMember < User::SaveOperation
  param_key :member
  include MemberDetails

  permit_columns name

  def self.form_for(member : User) : self
    new(member, last_day: member.access_window.last_day.try(&.to_s(DATE_FORMAT)) || "")
  end
end
