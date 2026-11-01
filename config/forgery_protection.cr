# Request specs call actions directly, without a CSRF token. LuckyFlow specs
# still go through the real forms, token included.
Lucky::ProtectFromForgery.configure do |settings|
  settings.allow_forgery_protection = !LuckyEnv.test?
end
