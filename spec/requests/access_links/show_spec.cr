require "../../spec_helper"

describe AccessLinks::Show do
  # Messaging apps open links to draw a preview: looking must not use it up.
  it "only shows a button to come in" do
    token = issue_access_link(child("Lina"))

    response = AppClient.new.exec(AccessLinks::Show.with(token))

    response.status_code.should eq(200)
    response.body.should contain("Lina")
    response.body.should contain("Entrer")
    AccessLinkQuery.new.first.used_at.should be_nil
  end

  it "answers 404 for an unknown link" do
    response = AppClient.new.exec(AccessLinks::Show.with("unknown"))

    response.status_code.should eq(404)
  end
end
