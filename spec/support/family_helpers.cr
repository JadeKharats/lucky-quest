# Creates an access link for a member and returns the token only the text
# message carries.
def issue_access_link(member : User) : String
  IssueAccessLink.create(member: member) do |operation, link|
    raise "Access link not saved: #{operation.errors}" unless link
    operation.token
  end
end

def child(name = "Lina") : User
  UserFactory.create(&.name(name).role(Family::Role::Child).without_password)
end

def guest(last_day : Time = Time.local(Household::TIME_ZONE).shift(days: 7)) : User
  ends_at = Family::AccessWindow.through(last_day).ends_at
  UserFactory.create(&.name("Mamie").role(Family::Role::Guest).access_ends_at(ends_at).without_password)
end

# The session cookie a response set, to send it back on the next request.
def session_cookie(response) : String
  response.headers["Set-Cookie"].split(";").first
end

def today_in_paris : Time
  Time.local(Household::TIME_ZONE)
end

def earn(member : User, amount : Int32, label = "Bonus") : XpEntry
  XpEntry::SaveOperation.create!(user_id: member.id, amount: amount, label: label, earned_at: Time.utc)
end

def xp_of(member : User) : Int64
  XpEntryQuery.new.user_id(member.id).to_a.sum(&.amount.to_i64)
end

WEEKDAYS_MASK = 0b0011111 # Monday to Friday

def school(name = "École du Parc", mask = WEEKDAYS_MASK) : School
  School::SaveOperation.create!(name: name, days_mask: mask)
end

def pupil(name : String, school : School) : User
  member = child(name)
  User::SaveOperation.update!(member, school_id: school.id)
end

def next_monday : Time
  today_in_paris.at_beginning_of_week.shift(days: 7)
end
