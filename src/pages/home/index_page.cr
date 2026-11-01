class Home::IndexPage < MainLayout
  needs report : HomeReport
  needs today : Time

  def page_title
    "Accueil"
  end

  def content
    hello
    report.progress.try { |progress| mount Shared::ProgressCard, report: progress, buyer: current_user.role.buy_rewards?, words: words }
    weight_shortcut if current_user.role.keep_weight_log?
    validations_shortcut if report.awaiting_validation > 0
    report.agenda.try { |agenda| mount Quests::AgendaView, agenda: agenda, words: words, rewards: report.rewards }
    report.raids.each do |view|
      mount Raids::Card, raid_view: view, member: current_user, names: report.names, words: words
    end
    mount AgendaPlan::Upcoming, upcoming: report.upcoming, open_trips: report.open_trips, names: report.names
  end

  private def hello
    header class: "hello" do
      avatar
      div class: "hello-text" do
        span French.weekday_date(today), class: "hello-date"
        h1 words.greeting(current_user.name)
      end
      streak
    end
  end

  private def avatar
    if current_user.skin.animals?
      raw Shared::Art::CAT
    else
      span current_user.name[0, 1].upcase, class: "avatar", "aria-hidden": "true"
    end
  end

  private def streak
    days = report.progress.try(&.streak) || 0
    return if days.zero?
    span class: "streak" do
      raw Shared::Art::PAW if current_user.skin.animals?
      mount Shared::Icon, name: :flame, size: 18 if current_user.skin.classic?
      text words.streak(days)
    end
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
