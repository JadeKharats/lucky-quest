class Home::Index < BrowserAction
  include Auth::AllowGuests

  get "/" do
    if current_user?
      redirect Me::Show
    else
      redirect SignIns::New
    end
  end
end
