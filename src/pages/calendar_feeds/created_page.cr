# Shown once: only the digest is stored.
class CalendarFeeds::CreatedPage < MainLayout
  needs url : String

  def page_title
    "Mon calendrier"
  end

  def content
    h1 "Mon calendrier"
    section class: "card" do
      para "Sur iPhone : Réglages → Calendrier → Comptes → Ajouter un calendrier avec abonnement, puis colle ce lien. Sur Google Agenda : Autres agendas → À partir de l'URL."
      input type: "text", value: url, readonly: "readonly", class: "access-url", flow_id: "calendar-url"
      para do
        a "Ouvrir dans le calendrier de cet appareil", href: url.sub(/\Ahttps?:/, "webcal:")
      end
      para "Ce lien ne sera plus affiché. S'il se perd, crée-en un nouveau : l'ancien cessera de marcher.", class: "empty"
      link "Retour à l'agenda", to: Schedules::Index
    end
  end
end
