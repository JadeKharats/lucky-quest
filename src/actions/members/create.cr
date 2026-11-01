class Members::Create < BrowserAction
  include Auth::RequireFamilyManager

  post "/famille" do
    CreateMember.create(params) do |operation, member|
      if member
        flash.success = "#{member.name} fait partie de la famille."
        redirect Members::Index
      else
        html_with_status IndexPage, 422, operation: operation, members: UserQuery.household.to_a
      end
    end
  end
end
