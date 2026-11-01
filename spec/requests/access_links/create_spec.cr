require "../../spec_helper"

describe AccessLinks::Create do
  it "shows a parent the link to send, and keeps only its digest" do
    parent = UserFactory.create
    member = child

    response = AppClient.new.exec(AccessLinks::Create.with(member.id), backdoor_user_id: parent.id)

    response.status_code.should eq(200)
    token = response.body.match!(%r{/entrer/([A-Za-z0-9_-]+)})[1]
    link = AccessLinkQuery.new.user_id(member.id).first
    link.token_digest.should eq(AccessLink.digest(token))
    link.token_digest.should_not eq(token)
    link.used_at.should be_nil
  end

  it "does not exist for a child" do
    member = child

    response = AppClient.new.exec(AccessLinks::Create.with(member.id), backdoor_user_id: member.id)

    response.status_code.should eq(404)
    AccessLinkQuery.new.select_count.should eq(0)
  end
end
