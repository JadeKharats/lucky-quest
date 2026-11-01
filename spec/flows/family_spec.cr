require "../spec_helper"

describe "Family flow", tags: "flow" do
  it "lets a parent add a daughter and send her an access link" do
    flow = BaseFlow.new
    flow.visit Members::Index, as: UserFactory.create

    flow.fill flow.el("@member-name"), with: "Lina"
    flow.select "member:role", value: "Child"
    flow.click "@add-member"
    flow.should have_element("@flash", text: "Lina fait partie de la famille.")

    lina = UserQuery.new.name("Lina").first
    flow.click "@access-link-#{lina.id}"
    url = flow.el("@access-url").value.to_s

    # Her own device: nobody is signed in there.
    flow.click "@sign-out-button"
    flow.visit URI.parse(url).path
    flow.click "@redeem-access-link"

    flow.should have_element("h1", text: "Bonjour Lina !")
  end
end
