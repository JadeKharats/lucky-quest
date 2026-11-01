class CreateMember < User::SaveOperation
  param_key :member
  include MemberDetails

  permit_columns name, role

  before_save do
    validate_required role, message: "Choisissez un rôle."
  end
end
