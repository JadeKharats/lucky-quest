class Home::Index < BrowserAction
  get "/" do
    html Home::IndexPage, report: HomeReport.for(current_user)
  end
end
