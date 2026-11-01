class Members::Index < BrowserAction
  include Auth::RequireFamilyManager

  get "/famille" do
    members = UserQuery.household.to_a
    html IndexPage, operation: CreateMember.new, members: members, standings: Standings.of(members), schools: SchoolQuery.ordered.to_a
  end
end
