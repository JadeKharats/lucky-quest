module Appearance
  # Inspired by, never copied: no names, logos or assets of other works.
  # Stored values never change.
  enum Skin
    Classic = 0
    System  = 1
    Galaxy  = 2

    # Classique follows the device's light / dark mode; the others are night
    # skins by nature.
    def always_dark? : Bool
      !classic?
    end
  end
end
