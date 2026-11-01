# Shown once: only the digest is stored, so this link cannot be shown again.
class AccessLinks::CreatedPage < MainLayout
  needs member : User
  needs url : String

  def page_title
    "Lien d'accès"
  end

  def content
    h1 "Lien d'accès pour #{member.name}"
    section class: "card" do
      para "Envoie ce lien à #{member.name} par SMS ou WhatsApp. Il marche une seule fois, pendant 48 heures, sur l'appareil où il est ouvert."
      input type: "text", value: url, readonly: "readonly", class: "access-url", id: "access-url", flow_id: "access-url"
      para "Il ne sera plus affiché : s'il se perd, crée un nouveau lien.", class: "empty"
      link "Retour à la famille", to: Members::Index
    end
  end
end
