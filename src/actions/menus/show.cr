# What does not fit in the tab bar: the member's other pages, her skin and
# signing out.
class Menus::Show < BrowserAction
  get "/menu" do
    html ShowPage
  end
end
