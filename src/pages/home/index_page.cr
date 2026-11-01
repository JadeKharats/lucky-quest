class Home::IndexPage < MainLayout
  needs report : HomeReport

  def page_title
    "Accueil"
  end

  def content
    h1 "Bonjour #{current_user.name} !"
    weight_shortcut if current_user.role.keep_weight_log?
    validations_shortcut if report.awaiting_validation > 0
    report.raids.each do |view|
      mount Raids::Card, raid_view: view, member: current_user, names: report.names
    end
    report.agenda.try { |agenda| mount Quests::AgendaView, agenda: agenda }
  end

  private def weight_shortcut
    section class: "card shortcut" do
      link "Poids : noter une pesée →", to: Weighings::Index
    end
  end

  private def validations_shortcut
    count = report.awaiting_validation
    section class: "card shortcut" do
      link "#{count} #{count == 1 ? "quête" : "quêtes"} à valider →", to: Validations::Index, flow_id: "to-validate"
    end
  end
end
