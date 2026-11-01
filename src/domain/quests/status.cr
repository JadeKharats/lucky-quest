module Quests
  # à faire → faite → validée
  enum Status
    ToDo
    Done
    Validated

    def self.of(completion : Completion?) : self
      return ToDo unless completion
      completion.validated ? Validated : Done
    end

    # A parent's own quest needs nobody's validation; a child's waits for a
    # parent or a guest.
    def self.after_completion_by(role : Family::Role) : self
      role.validate_quests? ? Validated : Done
    end
  end
end
