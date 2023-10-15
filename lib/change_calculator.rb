class ChangeCalculator

	def initialize()
	end

	def get_change(coin_bank, item_value)
		returned_change = []
		remaining_change = coin_bank.deposited_funds - item_value

		coin_bank.coin_quantities.each do |value, quant|
			while value <= remaining_change && quant > 0
				returned_change << value
				remaining_change -= value
				quant -= 1
			end
		end

		return returned_change
	end
end