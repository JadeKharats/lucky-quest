class AccessLinkQuery < AccessLink::BaseQuery
  def self.for_token(token : String) : self
    new.token_digest(AccessLink.digest(token)).preload_user
  end

  # Marks the link used unless another request just did: only one device
  # gets in with a given link.
  def self.claim(link : AccessLink, now : Time) : Bool
    new.id(link.id).used_at.is_nil.update(used_at: now) == 1
  end
end
