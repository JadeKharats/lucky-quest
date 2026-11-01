class Shared::LayoutHead < BaseComponent
  needs page_title : String
  needs color_scheme : String = "light dark"

  def render
    head do
      utf8_charset
      title "Quest · #{@page_title}"
      css_link asset("css/app.css")
      js_link asset("js/app.js"), defer: "true", type: "module"
      csrf_meta_tags
      responsive_meta_tag
      meta name: "color-scheme", content: color_scheme

      # Development helper used with the `lucky watch` command.
      # Reloads the browser when Crystal files are updated.
      live_reload_connect_tag if LuckyEnv.development?

      # Development helper used with the `bun run dev` command.
      # Reloads the browser when asset files are updated.
      bun_reload_connect_tag if LuckyEnv.development?
    end
  end
end
