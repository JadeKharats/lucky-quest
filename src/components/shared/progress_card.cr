# Rank, points and progress of the signed-in member, in her skin's words
# and look.
class Shared::ProgressCard < BaseComponent
  needs report : ProgressReport
  needs buyer : Bool
  needs words : Lexicon

  def render
    standing = report.standing
    section class: "card hero progress" do
      decoration
      div class: "hero-head" do
        div class: "hero-badge" do
          span "Rang", class: "hero-badge-label"
          strong standing.rank.to_s, class: "hero-badge-letter"
        end
        div class: "hero-text" do
          strong words.rank(standing.rank), class: "progress-rank"
          span words.points(standing.xp), class: "progress-xp"
        end
      end
      next_rank(standing)
      shop_link if buyer?
      recent
    end
  end

  private def decoration
    case words.skin
    in .animals?           then raw Shared::Art::GIRAFFE
    in .dance?             then raw Shared::Art::DANCER
    in .classic?, .system? then nil
    end
  end

  private def next_rank(standing : Progression::Standing)
    up = standing.next_rank
    if up
      mount Shared::Meter, progress: standing.progress, skin: words.skin,
        label: "#{words.points(standing.xp)} sur #{words.points(up.threshold)}"
      para words.next_rank(standing.xp_to_next, up), class: "hero-next"
    else
      para words.top_rank, class: "hero-next"
    end
  end

  private def shop_link
    link "#{words.shop} : #{words.points(report.wallet.balance)} à dépenser →", to: Rewards::Index, class: "progress-shop"
  end

  private def recent
    return if report.recent.empty?
    details class: "progress-recent" do
      summary "Derniers gains"
      ul do
        report.recent.each do |entry|
          li "+#{words.points(entry.amount)} · #{entry.label} · #{French.date(entry.earned_at.in(Household::TIME_ZONE))}"
        end
      end
    end
  end
end
