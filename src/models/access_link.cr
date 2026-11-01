require "digest/sha256"

# Only the digest of the token is stored: the token itself travels once, in
# the text message a parent sends.
class AccessLink < BaseModel
  table do
    belongs_to user : User
    column token_digest : String
    column expires_at : Time
    column used_at : Time?
  end

  def self.digest(token : String) : String
    Digest::SHA256.hexdigest(token)
  end

  def to_domain : Family::AccessLink
    Family::AccessLink.new(expires_at: expires_at, used_at: used_at)
  end
end
