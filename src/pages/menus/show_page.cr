class Menus::ShowPage < MainLayout
  def page_title
    "Plus"
  end

  def content
    h1 "Plus"
    links = entries
    unless links.empty?
      section class: "card menu" do
        ul class: "menu-links" do
          links.each do |(label, icon, path, key)|
            li do
              a href: path, class: "menu-link", flow_id: "menu-#{key}" do
                mount Shared::Icon, name: icon
                span label
                mount Shared::Icon, name: :chevron, size: 18
              end
            end
          end
        end
      end
    end
    mount Shared::SkinPicker, current: current_user.skin
    link to: SignIns::Delete, class: "menu-sign-out", flow_id: "sign-out-button" do
      mount Shared::Icon, name: :sign_out
      text "Se déconnecter"
    end
  end

  private def entries : Array(Tuple(String, Symbol, String, String))
    role = current_user.role
    list = [] of Tuple(String, Symbol, String, String)
    list << {"Menu de la cantine", :canteen, Canteen::Index.path, "canteen"} if role.enter_canteen_menu?
    list << {words.quests, :quests, Quests::Index.path, "quests"} if role.manage_family?
    list << {words.shop, :shop, Rewards::Index.path, "shop"} if role.manage_family?
    list << {"Poids", :weight, Weighings::Index.path, "weight"} if role.keep_weight_log?
    list << {"Famille", :family, Members::Index.path, "family"} if role.manage_family?
    list
  end
end
