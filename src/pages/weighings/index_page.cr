class Weighings::IndexPage < MainLayout
  needs operation : SaveWeighing
  needs report : WeightReport

  def page_title
    "Poids"
  end

  def content
    h1 "Poids"
    mount Weighings::Overview, summary: report.summary
    mount Weighings::Curve, report: report
    mount Weighings::Form, operation: operation
    mount Weighings::Recent, weighings: report.recent
  end
end
