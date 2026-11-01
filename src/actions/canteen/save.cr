class Canteen::Save < BrowserAction
  include Auth::RequireCanteenEditor
  include WeekParam

  post "/cantine/:week" do
    school = current_user.school_id.try { |id| SchoolQuery.new.id(id).first? } || raise Lucky::RouteNotFoundError.new(context)
    monday = parse_day(week).at_beginning_of_week
    SaveCanteenWeek.run(params, school: school, week: school.week(monday)) do |_operation, _saved|
      CanteenQuest.check(current_user, school)
      flash.success = "Menu de la cantine enregistré, merci !"
      redirect Canteen::Index.with(semaine: monday.to_s(DATE_FORMAT))
    end
  end
end
