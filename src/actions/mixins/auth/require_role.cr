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

module Auth::RequireWeightLog
  macro included
    before require_weight_log
  end

  private def require_weight_log
    raise Lucky::RouteNotFoundError.new(context) unless current_user.role.keep_weight_log?
    continue
  end
end
