class Members::List < BaseComponent
  needs members : Array(User)
  needs standings : Hash(Int64, Progression::Standing)

  def render
    section class: "card members" do
      h2 "Membres"
      ul do
        members.each { |member| mount Members::Row, member: member, standing: standings[member.id]? }
      end
    end
  end
end
