# A new secret feed link for the signed-in member; the old one stops working.
class CalendarFeeds::Create < BrowserAction
  post "/agenda/flux" do
    token = Random::Secure.urlsafe_base64(32)
    User::SaveOperation.update!(current_user, calendar_token_digest: AccessLink.digest(token))
    html CreatedPage, url: CalendarFeeds::Show.with(token).url
  end
end
