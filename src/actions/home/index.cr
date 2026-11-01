class Home::Index < BrowserAction
  get "/" do
    now = Time.local(Household::TIME_ZONE)
    html Home::IndexPage, report: HomeReport.for(current_user, now), today: now
  end
end
