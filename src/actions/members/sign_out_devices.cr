# Lost phone, end of the holidays: every session of the member was opened
# with the old generation, so they all stop working.
class Members::SignOutDevices < BrowserAction
  include Auth::RequireFamilyManager

  post "/famille/:user_id/deconnexion" do
    member = UserQuery.find(user_id)
    User::SaveOperation.update!(member, session_generation: member.session_generation + 1)
    flash.success = "Les appareils de #{member.name} sont déconnectés."
    redirect Members::Index
  end
end
