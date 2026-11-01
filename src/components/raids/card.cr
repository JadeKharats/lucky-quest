# A family raid on the home page: everyone sees every step.
class Raids::Card < BaseComponent
  needs raid_view : RaidBoard::View
  needs member : User
  needs names : Hash(Int64, String)

  def render
    progress = raid_view.progress
    section class: "card raid" do
      h2 "Raid : #{raid_view.raid.title}"
      if progress.finished?
        para "Raid terminé, bravo à toute la famille !", class: "raid-finished"
      end
      ol class: "raid-steps" do
        raid_view.raid.steps.each { |step| step_row(step) }
      end
    end
  end

  private def step_row(step : Quests::RaidStep)
    state = raid_view.progress.state(step)
    li class: "raid-step raid-step-#{state.to_s.downcase}" do
      div class: "quest-title" do
        strong step.title
        span detail(step, state), class: "quest-state"
      end
      actions(step)
    end
  end

  private def detail(step : Quests::RaidStep, state : Quests::StepState) : String
    done_by = who(raid_view.progress.checked_by(step))
    case state
    in .locked? then "🔒 #{who(step.participant_ids)}"
    in .done?   then "✓ #{done_by}"
    in .open?
      awaited = "en attente de #{who(raid_view.progress.awaited(step))}"
      done_by.empty? ? awaited : "#{awaited} · fait par #{done_by}"
    end
  end

  private def who(ids : Array(Int64)) : String
    French.names(ids.map { |id| names[id]? || "?" })
  end

  private def actions(step : Quests::RaidStep)
    progress = raid_view.progress
    div class: "member-actions" do
      if progress.can_check?(member.id, step)
        form_for RaidChecks::Create.with(step.id) do
          submit "C'est fait !", flow_id: "raid-done-#{step.id}"
        end
      end
      if progress.can_undo?(member.id, step)
        form_for RaidChecks::Delete.with(step.id), class: "secondary" do
          submit "Annuler"
        end
      end
      if member.role.manage_family? && !progress.state(step).locked? && !progress.checked_by(step).empty?
        form_for RaidSteps::Reset.with(step.id), class: "secondary" do
          submit "Réinitialiser"
        end
      end
    end
  end
end
