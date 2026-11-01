# Messaging apps open a link to draw its preview: this page only shows a
# button, and the link is used up by the POST behind it (AccessLinks::Redeem).
class AccessLinks::Show < BrowserAction
  include Auth::AllowGuests
  include AccessLinks::Redeemable

  get "/entrer/:token" do
    if link = redeemable_link(token)
      html ShowPage, token: token, member: link.user
    else
      # `html_with_status InvalidPage, 404` does not expand without page
      # assigns in Lucky 1.5 (trailing comma), hence the named status.
      html InvalidPage, _with_status_code: 404
    end
  end
end
