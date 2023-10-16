class ChangeCalculator

	def initialize()
	end

	def get_change(coin_bank, change_value)
		coin_quantities = coin_bank.coin_quantities
		returned_change = []
		remaining_change = change_value

		coin_quantities.each do |value, quant|
			while value <= remaining_change && quant > 0
				returned_change << value
				remaining_change -= value
				quant -= 1
			end
		end

		return returned_change
	end
end