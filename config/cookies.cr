require "./server"

Lucky::Session.configure do |settings|
  settings.key = "_lucky_quest_session"
end

Lucky::CookieJar.configure do |settings|
  settings.on_set = ->(cookie : HTTP::Cookie) {
    # If ForceSSLHandler is enabled, only send cookies over HTTPS
    cookie.secure(Lucky::ForceSSLHandler.settings.enabled)

    # By default, don't allow reading cookies with JavaScript
    cookie.http_only(true)

    # Restrict cookies to a first-party or same-site context
    cookie.samesite(:lax)

    # Set all cookies to the root path by default
    cookie.path("/")

    # Phones and the tablet stay signed in: the session lasts a year from the
    # last visit. Guests are cut off server-side at the end of their access.
    cookie.expires(1.year.from_now) if cookie.name == Lucky::Session.settings.key
    cookie
  }
end
