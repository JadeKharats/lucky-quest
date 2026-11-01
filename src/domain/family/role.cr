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

    # Guests (the grandparents) come in for a while, the household for good.
    def time_limited? : Bool
      guest?
    end
  end
end
