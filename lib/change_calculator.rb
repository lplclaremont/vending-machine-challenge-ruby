class ChangeCalculator

	def initialize()
	end

	def get_change(coin_bank, change_value, *index)
		index = index[0] || 0
		coins_and_quantities = coin_bank.coin_quantities.to_a
		return [] if index >= coins_and_quantities.count || index < 0

		coin_value = coins_and_quantities[index][0]
		quantity = coins_and_quantities[index][1]
		range = [quantity, change_value/coin_value].min

		r = range..0
		(r.first).downto(r.last).each do |i|
			remaining_change = change_value - (i * coin_value)
			result = get_change(coin_bank, remaining_change, index+1)

			if (result.length > 0) || (remaining_change==0)
				return [coin_value]*i + result
			end
		end
		return []
	end
end