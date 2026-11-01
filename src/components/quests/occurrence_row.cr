# One quest of the day or the week, as a card: what to do, what it is
# worth, and a big button to say it is done.
class Quests::OccurrenceRow < BaseComponent
  TINTS = 4

  needs occurrence : Quests::Occurrence
  needs words : Lexicon
  needs reward : Int32? = nil
  needs tint : Int32 = 0

  def render
    quest = occurrence.quest
    li class: "quest quest-#{occurrence.status.to_s.underscore}" do
      span class: "quest-tile quest-tile-#{tint}" do
        mount Shared::Icon, name: occurrence.status.to_do? ? :star : :check
      end
      div class: "quest-body" do
        strong quest.title, class: "quest-title"
        span state, class: "quest-state"
      end
      if occurrence.status.to_do?
        form_for Completions::Create.with(quest.id), class: "quest-done" do
          submit words.done, flow_id: "done-#{quest.id}"
        end
      else
        span class: "quest-check", "aria-hidden": "true" do
          mount Shared::Icon, name: :check
        end
      end
    end
  end

  private def state : String
    case occurrence.status
    in .to_do?     then reward.try { |points| "+#{words.points(points)}" } || ""
    in .done?      then words.awaiting
    in .validated? then words.validated
    end
  end
end
