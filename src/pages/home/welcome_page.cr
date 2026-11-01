# The home of a child or a guest; quests (M4) and meals (M6) will fill it.
class Home::WelcomePage < MainLayout
  def page_title
    "Accueil"
  end

  def content
    h1 "Bonjour #{current_user.name} !"
    section class: "card" do
      para "Tes quêtes arrivent bientôt ici.", class: "empty"
    end
  end
end
