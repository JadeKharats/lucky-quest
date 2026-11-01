# Latest weighing, 7-day average and trend.
class Weighings::Overview < BaseComponent
  needs summary : Health::Summary

  def render
    section class: "overview" do
      if latest = summary.latest
        stat "Dernière pesée", French.kilograms(latest.kilograms.value),
          French.date_time(latest.measured_at.in(Household::TIME_ZONE))
        stat "Moyenne sur 7 jours", summary.average.try { |kilos| French.kilograms(kilos) } || "—"
        stat "Tendance", *trend_text
      else
        para "Aucune pesée pour l'instant : la première se saisit ci-dessous.", class: "empty"
      end
    end
  end

  private def stat(label : String, value : String, detail : String? = nil)
    div class: "stat" do
      span label, class: "stat-label"
      strong value, class: "stat-value"
      span detail, class: "stat-detail" if detail
    end
  end

  private def trend_text : Tuple(String, String?)
    trend = summary.trend
    return {"—", "il faut une semaine de pesées"} unless trend

    case trend.direction
    in .down?   then {"↘ #{French.delta(trend.delta)}", "en 7 jours"}
    in .up?     then {"↗ #{French.delta(trend.delta)}", "en 7 jours"}
    in .stable? then {"→ stable", "sur 7 jours"}
    end
  end
end
