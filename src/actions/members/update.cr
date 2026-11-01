class Members::Update < BrowserAction
  include Auth::RequireFamilyManager

  patch "/famille/:user_id" do
    UpdateMember.update(UserQuery.find(user_id), params) do |operation, member|
      if operation.saved?
        flash.success = "#{member.name} est à jour."
      else
        flash.failure = operation.errors.values.flatten.first? || "Rien n'a changé."
      end
      redirect Members::Index
    end
  end
end
