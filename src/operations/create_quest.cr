class CreateQuest < Quest::SaveOperation
  param_key :quest
  include QuestDetails

  permit_columns title, user_id, frequency, xp, canteen_menu

  before_save do
    check_member
  end

  private def check_member
    member = user_id.value.try { |id| UserQuery.new.id(id).first? }
    unless member.try(&.role.keep_quests?)
      user_id.add_error "Ce membre n'a pas de quêtes."
    end
  end
end
