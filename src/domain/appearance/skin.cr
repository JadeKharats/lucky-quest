module Appearance
  # How a member's Quest looks. Stored values never change and are never
  # reused: 2 was Galaxie, dropped in M10.
  enum Skin
    Classic = 0
    System  = 1
    Animals = 3
    Dance   = 4

    def always_dark? : Bool
      system? || dance?
    end

    # Only Classique follows the device's light / dark mode; Animaux is
    # always light.
    def follows_device? : Bool
      classic?
    end
  end
end
