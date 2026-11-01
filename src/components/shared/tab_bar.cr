# The main navigation: a bottom tab bar on phones and the tablet, a side
# bar on the Mac. Five tabs at most; everything else is on /menu.
class Shared::TabBar < BaseComponent
  record Tab, label : String, icon : Symbol, path : String, key : String

  needs member : User
  needs words : Lexicon
  needs current_path : String

  def render
    nav class: "tab-bar", "aria-label": "Navigation" do
      link "Quest", to: Home::Index, class: "tab-bar-brand"
      tabs.each { |tab| item(tab) }
    end
  end

  # Parents and guests validate; the children shop.
  def tabs : Array(Tab)
    middle = [Tab.new("Repas", :meals, Meals::Index.path, "meals"), Tab.new("Agenda", :agenda, Schedules::Index.path, "agenda")]
    first = Tab.new("Accueil", :home, Home::Index.path, "home")
    more = Tab.new("Plus", :more, Menus::Show.path, "more")
    if member.role.validate_quests?
      [first, Tab.new("À valider", :validate, Validations::Index.path, "validate")] + middle + [more]
    else
      [first] + middle + [Tab.new(words.shop_tab, :shop, Rewards::Index.path, "shop"), more]
    end
  end

  private def item(tab : Tab)
    current = tab.path == current_path
    attrs = {"href" => tab.path, "class" => current ? "tab tab-current" : "tab", "flow-id" => "tab-#{tab.key}"}
    attrs["aria-current"] = "page" if current
    a options: attrs do
      mount Shared::Icon, name: tab.icon
      span tab.label, class: "tab-label"
    end
  end
end
