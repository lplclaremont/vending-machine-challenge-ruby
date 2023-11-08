require 'change_calculator'

class CoinBank
	attr_reader :coin_quantities, :deposited_funds, :change_calculator

  	def initialize(change_calculator, **quants)
		valid_quantities?(quants.values())
		@change_calculator = change_calculator
		@coin_quantities =  create_quantity_hash(quants)
		@deposited_funds = 0
	end

	def deposit_coin(coin_value)
		@deposited_funds += coin_value
		add_coin(coin_value)
	end

	def dispense_change(item_value)
		valid_item?(item_value)
		return "more funds required for purchase" if item_value > deposited_funds

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

	def reset_funds
		@deposited_funds = 0
	end

	def add_coin(coin_value)
		valid_coin?(coin_value)
		coin_quantities[coin_value] += 1
	end

	def remove_coin(coin_value)
		coin_quantities[coin_value] -= 1 if coin_quantities[coin_value] > 0
	end

	def default_coin_quantity
		0
	end

	def create_quantity_hash(quants)
		{
			200 => quants[:two_pound] || default_coin_quantity,
			100 => quants[:one_pound] || default_coin_quantity,
			50 => quants[:fifty_p] || default_coin_quantity,
			20 => quants[:twenty_p] || default_coin_quantity,
			10 => quants[:ten_p] || default_coin_quantity,
			5 => quants[:five_p] || default_coin_quantity,
			2 => quants[:two_p] || default_coin_quantity,
			1 => quants[:one_p] || default_coin_quantity,
		}
	end

	## Error cases

	def valid_quantities?(quantities)
		if (quantities.any? { |q| non_negative_int?(q)})
			raise Exception.new "quantities must all be non negative integers"
		end
	end

	def valid_coin?(coin_value)
		valid_coins = coin_quantities.keys()
		if !valid_coins.include?(coin_value)
			raise Exception.new "coin deposits must be a valid denomination"
		end
	end

	def valid_item?(item_value)
		if non_negative_int?(item_value)
			raise Exception.new "item value is not a valid money value"
		end
	end

	def non_negative_int?(n)
		n < 0 || !n.is_a?(Integer)
	end

end