class CoinBank
	attr_reader :coin_quantities, :deposited_funds

  def initialize(**quant)
		@coin_quantities =  {
			200 => quant[:two_pound],
			100 => quant[:one_pound],
			50 => quant[:fifty_p],
			20 => quant[:twenty_p],
			10 => quant[:ten_p],
			5 => quant[:five_p],
			2 => quant[:two_p],
			1 => quant[:one_p],
		}
		@deposited_funds = 0
	end

	def deposit_coin(coin_value)
		@deposited_funds += coin_value
		add_coin(coin_value)
	end

	def add_coin(coin_value)
		coin_quantities[coin_value] += 1
	end

	def remove_coin(coin_value)
		coin_quantities[coin_value] -= 1 if coin_quantities[coin_value] > 0
	end
end