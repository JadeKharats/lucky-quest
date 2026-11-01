class SignIns::Delete < BrowserAction
  delete "/sign_out" do
    sign_out
    flash.info = "Vous êtes déconnecté·e."
    redirect to: SignIns::New
  end
end
