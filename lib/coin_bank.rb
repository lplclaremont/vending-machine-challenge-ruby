class CoinBank
	attr_reader :coin_quantities, :deposited_funds

  def initialize(**quantities)
		@coin_quantities =  {
			200 => quantities[:two_pound],
			100 => quantities[:one_pound],
			50 => quantities[:fifty_p],
			20 => quantities[:twenty_p],
			10 => quantities[:ten_p],
			5 => quantities[:five_p],
			2 => quantities[:two_p],
			1 => quantities[:one_p],
		}
		@deposited_funds = 0
	end
end