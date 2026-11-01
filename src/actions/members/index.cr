class Members::Index < BrowserAction
  include Auth::RequireFamilyManager

  get "/famille" do
    html IndexPage, operation: CreateMember.new, members: UserQuery.household.to_a
  end
end
