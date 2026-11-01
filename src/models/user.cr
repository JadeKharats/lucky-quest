# A member of the household. The table keeps Lucky's name, `users`; the
# screens say "membre".
class User < BaseModel
  include Carbon::Emailable
  include Authentic::PasswordAuthenticatable

  table do
    column name : String
    column role : Family::Role
    # Parents only: the others have no password and come in with a link.
    column email : String?
    column encrypted_password : String?
    # Guests only: the first instant they may no longer come in.
    column access_ends_at : Time?
    # Bumped to sign every device of the member out.
    column session_generation : Int32 = 0
    # Children only: whose canteen menu is hers.
    belongs_to school : School?
  end

  def emailable : Carbon::Address
    Carbon::Address.new(email.to_s)
  end

  def access_window : Family::AccessWindow
    Family::AccessWindow.new(access_ends_at)
  end
end
