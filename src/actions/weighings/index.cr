class Weighings::Index < BrowserAction
  include Auth::RequireWeightLog

  get "/poids" do
    html IndexPage,
      operation: SaveWeighing.new(owner: current_user, measured_at_local: SaveWeighing.now_local),
      report: WeightReport.for(current_user)
  end
end
