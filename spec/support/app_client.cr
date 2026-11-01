# Calls browser actions directly. Sign in by passing `backdoor_user_id`
# (see Auth::TestBackdoor).
class AppClient < Lucky::BaseHTTPClient
  app AppServer.new

  def initialize
    super
    headers("Content-Type": "application/json", "Accept": "text/html")
  end
end
