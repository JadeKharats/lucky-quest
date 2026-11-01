class Home::IndexPage < MainLayout
  needs report : HomeReport

  def page_title
    "Accueil"
  end

  def content
    h1 words.greeting(current_user.name)
    report.progress.try { |progress| mount Shared::ProgressCard, report: progress, buyer: current_user.role.buy_rewards?, words: words }
    weight_shortcut if current_user.role.keep_weight_log?
    validations_shortcut if report.awaiting_validation > 0
    mount AgendaPlan::Upcoming, upcoming: report.upcoming, open_trips: report.open_trips, names: report.names
    report.raids.each do |view|
      mount Raids::Card, raid_view: view, member: current_user, names: report.names, words: words
    end
    report.agenda.try { |agenda| mount Quests::AgendaView, agenda: agenda, words: words }
    mount Shared::SkinPicker, current: current_user.skin
  end

  private def weight_shortcut
    section class: "card shortcut" do
      link "Poids : noter une pesée →", to: Weighings::Index
    end
  end

  private def validations_shortcut
    count = report.awaiting_validation
    section class: "card shortcut" do
      link "#{words.to_validate(count)} →", to: Validations::Index, flow_id: "to-validate"
    end
  end
end
