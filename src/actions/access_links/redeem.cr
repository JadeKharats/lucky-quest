class AccessLinks::Redeem < BrowserAction
  include Auth::AllowGuests
  include AccessLinks::Redeemable

  post "/entrer/:token" do
    link = redeemable_link(token)
    if link && AccessLinkQuery.claim(link, Time.utc)
      sign_in link.user
      flash.success = "Bienvenue #{link.user.name} !"
      redirect Home::Index
    else
      # `html_with_status InvalidPage, 404` does not expand without page
      # assigns in Lucky 1.5 (trailing comma), hence the named status.
      html InvalidPage, _with_status_code: 404
    end
  end
end
