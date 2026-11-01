class IssueAccessLink < AccessLink::SaveOperation
  needs member : User

  # Shown once to the parent, never stored.
  getter token : String = Random::Secure.urlsafe_base64(32)

  before_save do
    user_id.value = member.id
    token_digest.value = AccessLink.digest(token)
    expires_at.value = Family::AccessLink.issued_at(Time.utc).expires_at
  end
end
