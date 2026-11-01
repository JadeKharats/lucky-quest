class Schools::Create < BrowserAction
  include Auth::RequireFamilyManager

  post "/famille/ecoles" do
    SaveSchool.create(params) do |operation, school|
      if school
        flash.success = "École « #{school.name} » ajoutée."
      else
        flash.failure = operation.errors.values.flatten.first? || "École non ajoutée."
      end
      redirect Members::Index
    end
  end
end
