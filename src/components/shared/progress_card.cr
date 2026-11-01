# Rank, XP, streak and balance of the signed-in member. Words of the
# "System" skin (M9 makes them switchable).
class Shared::ProgressCard < BaseComponent
  needs report : ProgressReport
  needs buyer : Bool

  def render
    standing = report.standing
    section class: "card progress" do
      div class: "progress-head" do
        strong "Rang #{standing.rank}", class: "progress-rank"
        span "#{standing.xp} XP", class: "progress-xp"
      end
      next_rank(standing)
      streak
      shop_link if buyer?
      recent
    end
  end

  private def next_rank(standing : Progression::Standing)
    up = standing.next_rank
    if up
      div class: "bar" do
        div class: "bar-fill", style: "width: #{(standing.progress * 100).to_i}%"
      end
      para "encore #{standing.xp_to_next} XP pour le rang #{up}", class: "quest-state"
    else
      para "Rang maximal atteint !", class: "quest-state"
    end
  end

  private def streak
    days = report.streak
    return if days.zero?
    para "Série : #{days} #{days == 1 ? "jour" : "jours"} 🔥", class: "progress-streak"
  end

  private def shop_link
    link "Boutique : #{report.wallet.balance} XP à dépenser →", to: Rewards::Index, class: "progress-shop"
  end

  private def recent
    return if report.recent.empty?
    ul class: "progress-recent" do
      report.recent.each do |entry|
        li "+#{entry.amount} #{entry.label} · #{French.date(entry.earned_at.in(Household::TIME_ZONE))}"
      end
    end
  end
end
