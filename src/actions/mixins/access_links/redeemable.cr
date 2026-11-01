module AccessLinks::Redeemable
  # The link, if it still lets its member in right now.
  private def redeemable_link(token : String) : AccessLink?
    now = Time.utc
    AccessLinkQuery.for_token(token).first?.try do |link|
      link if link.to_domain.usable?(now) && link.user.access_window.open?(now)
    end
  end
end
