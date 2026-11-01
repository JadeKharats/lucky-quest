class Members::Row < BaseComponent
  needs member : User

  def render
    li class: "member" do
      div class: "member-title" do
        strong member.name
        span French.role(member.role), class: "member-role"
        access_text.try { |text| span text, class: "member-access" }
      end
      edit_form
      div class: "member-actions" do
        form_for AccessLinks::Create.with(member.id) do
          submit "Créer un lien d'accès", flow_id: "access-link-#{member.id}"
        end
        form_for Members::SignOutDevices.with(member.id), class: "secondary" do
          submit "Déconnecter ses appareils"
        end
      end
    end
  end

  private def access_text : String?
    member.access_window.last_day.try { |day| "jusqu'au #{French.date(day.in(Quest::TIME_ZONE))} inclus" }
  end

  private def edit_form
    operation = UpdateMember.form_for(member)
    details class: "member-edit" do
      summary "Modifier"
      form_for Members::Update.with(member.id) do
        mount Shared::Field, attribute: operation.name, label_text: "Prénom", &.text_input
        if member.role.time_limited?
          mount Shared::DateField, attribute: operation.last_day, label_text: "Dernier jour d'accès", id: "member_#{member.id}_last_day"
        end
        submit "Enregistrer"
      end
    end
  end
end
