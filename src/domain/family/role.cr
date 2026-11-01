module Family
  # What a member is in the household. The stored values never change:
  # they live in the database.
  enum Role
    Parent = 0
    Child  = 1
    Guest  = 2

    def manage_family? : Bool
      parent?
    end

    # Product rule: no weight tracking for the children, nor for the guests.
    def keep_weight_log? : Bool
      parent?
    end

    # Guests help without quests of their own.
    def keep_quests? : Bool
      !guest?
    end

    # A child never validates a quest, not even someone else's.
    def validate_quests? : Bool
      !child?
    end

    # The shop is for the children; parents and guests do not buy.
    def buy_rewards? : Bool
      child?
    end

    # Grandparents may be the ones cooking during the holidays.
    def plan_meals? : Bool
      !child?
    end

    # Each daughter copies her own school's menu.
    def enter_canteen_menu? : Bool
      child?
    end

    # Parents and grandparents drive the children to their activities.
    def drive? : Bool
      !child?
    end

    # Guests (the grandparents) come in for a while, the household for good.
    def time_limited? : Bool
      guest?
    end
  end
end
