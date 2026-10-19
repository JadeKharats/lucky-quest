# For more detailed documentation, visit
# https://luckyframework.org/guides/testing/html-and-interactivity

LuckyFlow.configure do |settings|
  settings.stop_retrying_after = 200.milliseconds
  settings.base_uri = Lucky::RouteHelper.settings.base_uri

  # LuckyFlow downloads a chromedriver into ~/.webdrivers/ by default. That
  # download fails behind some proxies, so CHROMEDRIVER_PATH can point to a
  # driver matching the local browser instead.
  settings.driver_path = ENV["CHROMEDRIVER_PATH"]?
end

# Same as LuckyFlow's built-in headless_chrome, plus CHROME_BIN to run any
# Chromium-based browser (e.g. Brave when Chrome is not installed).
LuckyFlow::Registry.register :headless_chrome do
  LuckyFlow::Selenium::Chrome::Driver.new do |config|
    config.chrome_options.binary = ENV["CHROME_BIN"]?
    config.chrome_options.args = [
      "--no-sandbox",
      "--headless",
      "--disable-gpu",
      "--disable-dev-shm-usage",
      "--remote-debugging-port=#{ENV.fetch("CHROME_REMOTE_DEBUGGING_PORT", "9222")}",
    ]
  end
end

# By default, LuckyFlow is set in "headless" mode (no browser window shown).
# Uncomment this to enable running `LuckyFlow` in a Google Chrome window instead.
# Be sure to disable for CI.
#
# LuckyFlow.default_driver = "chrome"

# LuckyFlow uses a registry for each driver. By default, chrome, and headless_chrome
# are available. If you'd like to register your own custom driver, you can register
# it here.
#
# LuckyFlow::Registry.register :firefox do
#   # add your custom driver here
# end

# Setup specs to allow you to change the driver on the fly
# per spec by setting a tag on specific specs. Requires the
# driver to be registered through `LuckyFlow::Registry` first.
#
# ```
# it "uses headless_chrome" do
# end
# it "uses webless", tags: "webless" do
# end
# ```
LuckyFlow::Spec.setup
