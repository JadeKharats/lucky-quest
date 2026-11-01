# A line icon drawn in the text colour. Decorative: the label next to it
# carries the meaning.
class Shared::Icon < BaseComponent
  PATHS = {
    home:     "M3 11l9-7 9 7v9a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z",
    check:    "M5 12.5l4.5 4.5L19 7.5",
    meals:    "M3 11h18a9 9 0 0 1-18 0zM8 7c0-2 2-2 2-4M14 7c0-2 2-2 2-4",
    agenda:   "M4 5h16v16H4zM4 10h16M9 3v4M15 3v4",
    shop:     "M4 10h16v11H4zM2 6h20v4H2zM12 6v15M12 6c-2-4-6-4-6-1s6 1 6 1zM12 6c2-4 6-4 6-1s-6 1-6 1z",
    more:     "M5 12h.01M12 12h.01M19 12h.01",
    validate: "M9 11l3 3 8-8M20 12v7a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h9",
    star:     "M12 3l2.6 5.6 6.1.7-4.5 4.2 1.2 6L12 16.6 6.6 19.5l1.2-6-4.5-4.2 6.1-.7z",
    raid:     "M14.5 17.5L3 6V3h3l11.5 11.5M13 19l6-6M16 16l4 4M19 21l2-2",
    chevron:  "M9 5l7 7-7 7",
    weight:   "M5 21h14l-2-12H7zM9 9a3 3 0 0 1 6 0",
    family:   "M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM2 21v-1a6 6 0 0 1 12 0v1M17 11a3 3 0 1 0 0-6M22 21v-1a5 5 0 0 0-4-4.9",
    quests:   "M6 3h12v18H6zM9 8h6M9 12h6M9 16h3",
    canteen:  "M6 3h12v18H6zM9 8h6M9 12h6M9 16h3",
    skin:     "M12 3a9 9 0 1 0 0 18c1 0 1.5-.8 1.5-1.5 0-1-.8-1.2-.8-2.2 0-.9.7-1.6 1.6-1.6H17a4 4 0 0 0 4-4c0-4.7-4-8.7-9-8.7zM7.5 11h.01M10 7.5h.01M15 7.5h.01",
    sign_out: "M15 4h4v16h-4M10 17l5-5-5-5M15 12H3",
    flame:    "M12 2c.5 4 5 6 5 11a5 5 0 0 1-10 0c0-2.5 1.5-4 2-6 1 1.5 2 2 3 1.5-.5-2-.5-4 0-6.5z",
  }

  needs name : Symbol
  needs size : Int32 = 24

  def render
    tag "svg", options: {
      "class" => "icon", "width" => size.to_s, "height" => size.to_s, "viewBox" => "0 0 24 24",
      "fill" => "none", "stroke" => "currentColor", "stroke-width" => "2",
      "stroke-linecap" => "round", "stroke-linejoin" => "round", "aria-hidden" => "true",
    } do
      tag "path", options: {"d" => PATHS[name]}
    end
  end
end
