# Quest sends no email yet (no sign-up, no password reset). Carbon stays
# configured for Lucky, with an adapter that delivers nothing.
BaseEmail.configure do |settings|
  settings.adapter = Carbon::DevAdapter.new(print_emails: LuckyEnv.development?)
end
