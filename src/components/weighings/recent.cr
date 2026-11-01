class Weighings::Recent < BaseComponent
  needs weighings : Array(Weighing)

  def render
    return if weighings.empty?

    section class: "recent" do
      h2 "Dernières pesées"
      ul do
        weighings.each { |weighing| row(weighing) }
      end
    end
  end

  private def row(weighing : Weighing)
    when_text = French.date_time(weighing.measured_at.in(Quest::TIME_ZONE))
    li do
      span when_text, class: "recent-when"
      strong French.kilograms(weighing.kilograms), class: "recent-weight"
      form_for Weighings::Delete.with(weighing.id), class: "recent-delete" do
        submit "Supprimer", aria_label: "Supprimer la pesée du #{when_text}"
      end
    end
  end
end
