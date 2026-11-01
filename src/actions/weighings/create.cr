class Weighings::Create < BrowserAction
  post "/poids" do
    SaveWeighing.create(params, owner: current_user) do |operation, weighing|
      if weighing
        flash.success = "Pesée enregistrée."
        redirect Index
      else
        html_with_status IndexPage, 422,
          operation: operation,
          report: WeightReport.for(current_user)
      end
    end
  end
end
