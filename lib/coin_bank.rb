require 'change_calculator'

class CoinBank
	attr_reader :coin_quantities, :deposited_funds, :change_calculator

  def initialize(change_calculator, **quant)
		@change_calculator = change_calculator
		@coin_quantities =  {
			200 => quant[:two_pound] || default_coin_quantity,
			100 => quant[:one_pound] || default_coin_quantity,
			50 => quant[:fifty_p] || default_coin_quantity,
			20 => quant[:twenty_p] || default_coin_quantity,
			10 => quant[:ten_p] || default_coin_quantity,
			5 => quant[:five_p] || default_coin_quantity,
			2 => quant[:two_p] || default_coin_quantity,
			1 => quant[:one_p] || default_coin_quantity,
		}
		@deposited_funds = 0
	end

	def deposit_coin(coin_value)
		@deposited_funds += coin_value
		add_coin(coin_value)
	end

	def dispense_change(item_value)
		change_value = deposited_funds - item_value
		change = change_calculator.get_change(self, change_value)

		if (change == [] && change_value != 0)
			return "unable to dispense correct change"
		end
		
		change.each do |coin_value|
			remove_coin(coin_value)
		end

		change
	end

	def add_coin(coin_value)
		coin_quantities[coin_value] += 1
	end

	def remove_coin(coin_value)
		coin_quantities[coin_value] -= 1 if coin_quantities[coin_value] > 0
	end

	def default_coin_quantity
		0
	end
end