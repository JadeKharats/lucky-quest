class AccessLinks::ShowPage < AuthLayout
  needs token : String
  needs member : User

  def page_title
    "Bienvenue"
  end

  def content
    h1 "Bienvenue #{member.name}"
    para "Appuie sur Entrer pour ouvrir Quest sur cet appareil."
    form_for AccessLinks::Redeem.with(token) do
      submit "Entrer", flow_id: "redeem-access-link"
    end
  end
end
