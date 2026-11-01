module Family
  # A link a parent sends by text message to let a member in on her own
  # device. It works once, and only for a short while: a forwarded or leaked
  # message is worthless once used or late.
  record AccessLink, expires_at : Time, used_at : Time? = nil do
    LIFETIME = 48.hours

    def self.issued_at(now : Time) : self
      new(expires_at: now + LIFETIME)
    end

    def usable?(now : Time) : Bool
      used_at.nil? && now < expires_at
    end
  end
end
