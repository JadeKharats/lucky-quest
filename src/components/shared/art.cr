# The themes' drawings, as fixed inline SVG: no image files, no user data
# inside, so they are written out as they are. Decorative unless a label is
# given by the caller.
module Shared::Art
  INK = "#2B1D0E"

  CAT = <<-SVG
    <svg class="art art-cat" viewBox="0 0 64 64" aria-hidden="true">
      <circle cx="32" cy="32" r="31" fill="#fff" stroke="#{INK}" stroke-width="2.5"/>
      <path d="M13 28 L17 9 L29 19 Z M51 28 L47 9 L35 19 Z" fill="#F2A541" stroke="#{INK}" stroke-width="2.2" stroke-linejoin="round"/>
      <path d="M16.5 14 L18 22 L23 19 Z M47.5 14 L46 22 L41 19 Z" fill="#FFB7C5"/>
      <ellipse cx="32" cy="36" rx="20" ry="17" fill="#F2A541" stroke="#{INK}" stroke-width="2.2"/>
      <circle cx="25" cy="34" r="3" fill="#{INK}"/><circle cx="39" cy="34" r="3" fill="#{INK}"/>
      <circle cx="26" cy="33" r="1" fill="#fff"/><circle cx="40" cy="33" r="1" fill="#fff"/>
      <path d="M30 40 h4 l-2 2.5 z" fill="#E86A86"/>
      <path d="M32 42.5 q-2.5 3.5 -5.5 1.5 M32 42.5 q2.5 3.5 5.5 1.5 M8 37 h9 M8 42 l9 -2 M56 37 h-9 M56 42 l-9 -2" fill="none" stroke="#{INK}" stroke-width="1.6" stroke-linecap="round"/>
    </svg>
    SVG

  GIRAFFE = <<-SVG
    <svg class="art art-giraffe" viewBox="0 0 80 160" aria-hidden="true">
      <rect x="30" y="44" width="20" height="130" rx="9" fill="#F2A541" stroke="#{INK}" stroke-width="2.2"/>
      <circle cx="37" cy="64" r="4" fill="#A8611C"/><circle cx="44" cy="82" r="5" fill="#A8611C"/><circle cx="36" cy="100" r="4.5" fill="#A8611C"/><circle cx="45" cy="118" r="4" fill="#A8611C"/><circle cx="37" cy="136" r="5" fill="#A8611C"/>
      <path d="M38 14 v-9 M50 14 v-9" stroke="#{INK}" stroke-width="2.4" stroke-linecap="round"/>
      <circle cx="38" cy="5" r="3.2" fill="#A8611C" stroke="#{INK}" stroke-width="1.8"/><circle cx="50" cy="5" r="3.2" fill="#A8611C" stroke="#{INK}" stroke-width="1.8"/>
      <ellipse cx="25" cy="22" rx="8" ry="4" fill="#F2A541" stroke="#{INK}" stroke-width="2" transform="rotate(-25 25 22)"/>
      <path d="M30 18 Q44 6 58 18 L66 34 Q66 44 54 44 L36 44 Q28 40 30 18 Z" fill="#F2A541" stroke="#{INK}" stroke-width="2.2" stroke-linejoin="round"/>
      <ellipse cx="58" cy="38" rx="8" ry="6" fill="#F6C27A"/>
      <circle cx="44" cy="26" r="2.6" fill="#{INK}"/>
      <circle cx="58" cy="37" r="1.2" fill="#{INK}"/><circle cx="62" cy="37" r="1.2" fill="#{INK}"/>
    </svg>
    SVG

  # A hip-hop pose: knees bent, one arm up, a cap.
  DANCER = <<-SVG
    <svg class="art art-dancer" viewBox="0 0 100 140" aria-hidden="true">
      <path d="M8 22 q6 -6 12 0 M4 34 q6 -6 12 0 M82 20 q6 -6 12 0" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" opacity="0.45"/>
      <circle cx="50" cy="18" r="10" fill="currentColor"/>
      <path d="M44 10 h18 l4 4" fill="none" stroke="#FFD23D" stroke-width="4" stroke-linecap="round"/>
      <g fill="none" stroke="currentColor" stroke-width="9" stroke-linecap="round" stroke-linejoin="round">
        <path d="M50 32 L48 70"/><path d="M50 40 L30 30 L24 10"/><path d="M50 40 L72 52 L82 40"/>
        <path d="M48 70 L30 90 L26 122"/><path d="M48 70 L68 92 L78 122"/>
      </g>
      <path d="M18 126 h16 M70 126 h16" stroke="#FFD23D" stroke-width="6" stroke-linecap="round"/>
    </svg>
    SVG

  PAW = %(<svg class="meter-step" viewBox="0 0 24 24" aria-hidden="true"><ellipse cx="12" cy="16" rx="5" ry="4.2"/><circle cx="6" cy="10" r="2.2"/><circle cx="10" cy="6.5" r="2.2"/><circle cx="14" cy="6.5" r="2.2"/><circle cx="18" cy="10" r="2.2"/></svg>)

  FOOTPRINT = %(<svg class="meter-step" viewBox="0 0 14 22" aria-hidden="true"><ellipse cx="7" cy="7" rx="6" ry="7"/><ellipse cx="7" cy="18" rx="4.5" ry="3.5"/></svg>)
end
