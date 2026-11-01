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

  # Each member only sees the pages their role may use.
  private def render_header
    role = current_user.role
    header class: "site-header" do
      link "Quest", to: Home::Index, class: "site-name"
      nav do
        link "Poids", to: Weighings::Index if role.keep_weight_log?
        link "Famille", to: Members::Index if role.manage_family?
        link "Se déconnecter", to: SignIns::Delete, flow_id: "sign-out-button"
      end
    end
  end
end
