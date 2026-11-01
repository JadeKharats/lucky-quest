class Members::NewForm < BaseComponent
  needs operation : CreateMember

  def render
    section class: "card" do
      h2 "Ajouter un membre"
      form_for Members::Create do
        mount Shared::Field, attribute: operation.name, label_text: "Prénom", &.text_input(flow_id: "member-name")
        role_field
        mount Shared::DateField, attribute: operation.last_day, label_text: "Dernier jour d'accès (invité·e)", id: "member_last_day"
        submit "Ajouter", flow_id: "add-member"
      end
    end
  end

  private def role_field
    label "Rôle", for: "member_role"
    select_input operation.role, id: "member_role", flow_id: "member-role" do
      options_for_select operation.role, Family::Role.values.map { |role| {French.role(role), role} }
    end
    mount Shared::FieldErrors, operation.role
  end
end
