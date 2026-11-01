class Members::List < BaseComponent
  needs members : Array(User)

  def render
    section class: "card members" do
      h2 "Membres"
      ul do
        members.each { |member| mount Members::Row, member: member }
      end
    end
  end
end
