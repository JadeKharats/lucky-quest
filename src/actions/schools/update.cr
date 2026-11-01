class Schools::Update < BrowserAction
  include Auth::RequireFamilyManager

  patch "/famille/ecoles/:school_id" do
    SaveSchool.update(SchoolQuery.find(school_id), params) do |operation, school|
      if operation.saved?
        flash.success = "École « #{school.name} » mise à jour."
      else
        flash.failure = operation.errors.values.flatten.first? || "Rien n'a changé."
      end
      redirect Members::Index
    end
  end
end
