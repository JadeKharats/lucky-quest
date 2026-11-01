# Rank, XP, streak and balance of the signed-in member, in her skin's words.
class Shared::ProgressCard < BaseComponent
  needs report : ProgressReport
  needs buyer : Bool
  needs words : Lexicon

  def render
    standing = report.standing
    section class: "card progress" do
      div class: "progress-head" do
        strong words.rank(standing.rank), class: "progress-rank"
        span words.points(standing.xp), class: "progress-xp"
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
      para words.next_rank(standing.xp_to_next, up), class: "quest-state"
    else
      para words.top_rank, class: "quest-state"
    end
  end

  private def streak
    days = report.streak
    return if days.zero?
    para words.streak(days), class: "progress-streak"
  end

  private def shop_link
    link "#{words.shop} : #{words.points(report.wallet.balance)} à dépenser →", to: Rewards::Index, class: "progress-shop"
  end

  private def recent
    return if report.recent.empty?
    ul class: "progress-recent" do
      report.recent.each do |entry|
        li "+#{words.points(entry.amount)} · #{entry.label} · #{French.date(entry.earned_at.in(Household::TIME_ZONE))}"
      end
    end
  end
end
