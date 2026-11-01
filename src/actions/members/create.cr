class Members::Create < BrowserAction
  include Auth::RequireFamilyManager

  post "/famille" do
    CreateMember.create(params) do |operation, member|
      if member
        flash.success = "#{member.name} fait partie de la famille."
        redirect Members::Index
      else
        members = UserQuery.household.to_a
        html_with_status IndexPage, 422, operation: operation, members: members, standings: Standings.of(members)
      end
    end
  end
end
