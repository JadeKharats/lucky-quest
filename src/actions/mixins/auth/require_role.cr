# Pages a role may not use do not exist for it: 404, not 403, so nothing
# tells a child or a guest what is behind them.
module Auth::RequireFamilyManager
  macro included
    before require_family_manager
  end

  private def require_family_manager
    raise Lucky::RouteNotFoundError.new(context) unless current_user.role.manage_family?
    continue
  end
end

module Auth::RequireQuestValidator
  macro included
    before require_quest_validator
  end

  private def require_quest_validator
    raise Lucky::RouteNotFoundError.new(context) unless current_user.role.validate_quests?
    continue
  end
end

module Auth::RequireShop
  macro included
    before require_shop
  end

  # Parents run the shop, children buy; guests see nothing of it.
  private def require_shop
    role = current_user.role
    raise Lucky::RouteNotFoundError.new(context) unless role.buy_rewards? || role.manage_family?
    continue
  end
end

module Auth::RequireMealPlanner
  macro included
    before require_meal_planner
  end

  private def require_meal_planner
    raise Lucky::RouteNotFoundError.new(context) unless current_user.role.plan_meals?
    continue
  end
end

module Auth::RequireCanteenEditor
  macro included
    before require_canteen_editor
  end

  private def require_canteen_editor
    raise Lucky::RouteNotFoundError.new(context) unless current_user.role.enter_canteen_menu?
    continue
  end
end

module Auth::RequireDriver
  macro included
    before require_driver
  end

  private def require_driver
    raise Lucky::RouteNotFoundError.new(context) unless current_user.role.drive?
    continue
  end
end

module Auth::RequireWeightLog
  macro included
    before require_weight_log
  end

  private def require_weight_log
    raise Lucky::RouteNotFoundError.new(context) unless current_user.role.keep_weight_log?
    continue
  end
end
