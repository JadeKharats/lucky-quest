// Leaves `url('/fonts/…')` as written in the CSS: the fonts are served as
// files from public/fonts, so a browser only downloads its skin's fonts
// (Bun would otherwise inline every font into app.css).
export default function externalFonts() {
  return {
    name: 'external-fonts',
    setup(build) {
      build.onResolve({filter: /^\/fonts\//}, args => ({path: args.path, external: true}))
    }
  }
}
