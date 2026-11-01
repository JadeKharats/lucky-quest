abstract class MainLayout
  include Lucky::HTMLPage

  # Every page behind sign-in knows who is signed in.
  needs current_user : User

  abstract def content
  abstract def page_title

  def page_title
    "Quest"
  end

  # The game's words in the viewer's skin.
  def words : Lexicon
    Lexicon.for(current_user.skin)
  end

  def render
    html_doctype

    skin = current_user.skin
    html lang: "fr", "data-skin": skin.to_s.downcase do
      mount Shared::LayoutHead, page_title: page_title, color_scheme: color_scheme(skin)

      body do
        div class: "app" do
          mount Shared::TabBar, member: current_user, words: words, current_path: context.request.path
          main do
            mount Shared::FlashMessages, context.flash
            content
          end
        end
      end
    end
  end

  private def color_scheme(skin : Appearance::Skin) : String
    return "light dark" if skin.follows_device?
    skin.always_dark? ? "dark" : "light"
  end
end
