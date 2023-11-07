class ChangeCalculator

	def get_change(coin_bank, change_value, *index)
		coin_index = index[0] || 0
		coins_and_quantities = coin_bank.coin_quantities.to_a

		return [] if coin_index >= coins_and_quantities.count

		coin_value = coins_and_quantities[coin_index][0]
		quantity = coins_and_quantities[coin_index][1]
		# find the maximum quantity of current coin
		# that will fit into the total change
		range_maximum = [quantity, change_value/coin_value].min

		(range_maximum).downto(0).each do |q|
			remaining_change = change_value - (q * coin_value)
			result = get_change(coin_bank, remaining_change, coin_index + 1)

			if (result.length > 0) || (remaining_change == 0)
				return [coin_value]*q + result
			end
		end
		
		return []
	end
end