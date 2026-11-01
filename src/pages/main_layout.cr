abstract class MainLayout
  include Lucky::HTMLPage

  # Every page behind sign-in knows who is signed in.
  needs current_user : User

  abstract def content
  abstract def page_title

  def page_title
    "Quest"
  end

  def render
    html_doctype

    html lang: "fr" do
      mount Shared::LayoutHead, page_title: page_title

      body do
        render_header
        main do
          mount Shared::FlashMessages, context.flash
          content
        end
      end
    end
  end

  private def render_header
    header class: "site-header" do
      link "Quest", to: Home::Index, class: "site-name"
      nav do
        link "Poids", to: Weighings::Index
        link "Se déconnecter", to: SignIns::Delete, flow_id: "sign-out-button"
      end
    end
  end
end
