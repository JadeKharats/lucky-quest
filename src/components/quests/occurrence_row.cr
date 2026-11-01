class Quests::OccurrenceRow < BaseComponent
  needs occurrence : Quests::Occurrence

  STATES = {
    Quests::Status::ToDo      => "à faire",
    Quests::Status::Done      => "faite, à valider",
    Quests::Status::Validated => "validée ✓",
  }

  def render
    quest = occurrence.quest
    li class: "quest quest-#{occurrence.status.to_s.underscore}" do
      span quest.title, class: "quest-title"
      if occurrence.status.to_do?
        form_for Completions::Create.with(quest.id), class: "quest-done" do
          submit "C'est fait !", flow_id: "done-#{quest.id}"
        end
      else
        span STATES[occurrence.status], class: "quest-state"
      end
    end
  end
end
