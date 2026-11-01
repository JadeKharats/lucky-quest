class AccessLinks::Create < BrowserAction
  include Auth::RequireFamilyManager

  post "/famille/:user_id/liens" do
    member = UserQuery.find(user_id)
    IssueAccessLink.create(member: member) do |operation, link|
      raise "Access link not saved: #{operation.errors}" unless link
      html CreatedPage, member: member, url: AccessLinks::Show.with(operation.token).url
    end
  end
end
