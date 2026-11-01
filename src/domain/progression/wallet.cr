module Progression
  record Wallet, earned : Int32, spent : Int32 do
    def balance : Int32
      earned - spent
    end

    def can_afford?(cost : Int32) : Bool
      cost.positive? && cost <= balance
    end
  end
end
