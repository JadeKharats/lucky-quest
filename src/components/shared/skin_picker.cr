# "Mon apparence": three small previews, one tap each.
class Shared::SkinPicker < BaseComponent
  needs current : Appearance::Skin

  def render
    section class: "card skin-picker" do
      h2 "Mon apparence"
      div class: "skin-choices" do
        Appearance::Skin.values.each { |skin| choice(skin) }
      end
    end
  end

  private def choice(skin : Appearance::Skin)
    form_for Appearances::Choose, class: "skin-choice" do
      input type: "hidden", name: "appearance:skin", value: skin.to_s
      div class: "skin-preview", "data-skin": skin.to_s.downcase do
        span Lexicon.for(skin).rank(Progression::Rank::D), class: "skin-preview-rank"
        span Lexicon.for(skin).today, class: "skin-preview-title"
      end
      if skin == current
        span "#{Lexicon.name(skin)} ✓", class: "skin-current"
      else
        submit Lexicon.name(skin), flow_id: "skin-#{skin.to_s.downcase}"
      end
    end
  end
end
