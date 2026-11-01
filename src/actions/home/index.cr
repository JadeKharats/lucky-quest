class Home::Index < BrowserAction
  get "/" do
    if current_user.role.keep_weight_log?
      redirect Weighings::Index
    else
      html Home::WelcomePage
    end
  end
end
