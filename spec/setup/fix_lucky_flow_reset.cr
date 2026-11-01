# LuckyFlow 0.10 resets the browser by navigating to about:blank and *then*
# deleting all cookies — WebDriver only deletes the current page's cookies,
# and about:blank has none. Quest's year-long session cookie then leaks from
# one flow spec to the next. Delete first, while still on the app's page.
class LuckyFlow::Selenium::Driver
  def reset : Nil
    @session.try do |session|
      session.cookie_manager.delete_all_cookies
      session.navigate_to("about:blank")
    end
  end
end
