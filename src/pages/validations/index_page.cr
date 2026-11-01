class Validations::IndexPage < MainLayout
  needs completions : Array(Completion)

  def page_title
    "À valider"
  end

  def content
    h1 "À valider"
    section class: "card quests" do
      if completions.empty?
        para "Rien à valider pour l'instant.", class: "empty"
      else
        ul do
          completions.each { |completion| row(completion) }
        end
      end
    end
  end

  private def row(completion : Completion)
    quest = completion.quest
    li class: "quest" do
      div class: "quest-title" do
        strong quest.title
        span "#{quest.user.name} · #{French.period(completion.period_start.in(Household::TIME_ZONE), quest.recurrence.weekly?)}", class: "quest-state"
      end
      div class: "member-actions" do
        form_for Validations::Create.with(completion.id) do
          submit "Valider", flow_id: "validate-#{completion.id}"
        end
        form_for Validations::Delete.with(completion.id), class: "secondary" do
          submit "Pas encore"
        end
      end
    end
  end
end
