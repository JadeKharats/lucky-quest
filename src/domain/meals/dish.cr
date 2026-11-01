module Meals
  record Dish, name : String, tag : MainTag do
    # "Lasagnes  Bolognaise " and "lasagne bolognaise" are the same dish:
    # case, accents, spaces and a final plural s / x are ignored.
    def key : String
      name.unicode_normalize(:nfd).gsub(/\p{Mn}/, "").downcase
        .split.map { |word| singular(word) }.join(" ")
    end

    def same_dish?(other : Dish) : Bool
      key == other.key
    end

    private def singular(word : String) : String
      word.size > 2 && word.ends_with?(/[sx]/) ? word.rchop : word
    end
  end
end
