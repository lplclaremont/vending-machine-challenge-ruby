require 'change_calculator'

class CoinBank
	attr_reader :coin_quantities, :deposited_funds, :change_calculator

  	def initialize(change_calculator, **quants)
		check_valid_quantities(quants.values())
		@change_calculator = change_calculator
		@coin_quantities =  create_quantity_hash(quants)
		@deposited_funds = 0
	end

	def deposit_coin(coin_value)
		@deposited_funds += coin_value
		add_coin(coin_value)
	end

	def dispense_change(item_value)
		check_valid_item(item_value)
		return "more funds required for purchase" if item_value > deposited_funds

		change_amount = deposited_funds - item_value
		change = change_calculator.get_change(coin_quantities, change_amount)
		if (change == [] && change_amount != 0)
			return "unable to dispense correct change"
		end
		remove_change_coins(change)
		change
	end

	def reset_funds
		@deposited_funds = 0
	end

	def add_coin(coin_value)
		check_valid_coin(coin_value)
		coin_quantities[coin_value] += 1
	end

	def remove_coin(coin_value)
		coin_quantities[coin_value] -= 1 if coin_quantities[coin_value] > 0
	end

	def remove_change_coins(change)
		change.each do |coin_value|
			remove_coin(coin_value)
		end
	end

	def create_quantity_hash(quants)
		{
			200 => quants[:two_pound] || 0,
			100 => quants[:one_pound] || 0,
			50 => quants[:fifty_p] || 0,
			20 => quants[:twenty_p] || 0,
			10 => quants[:ten_p] || 0,
			5 => quants[:five_p] || 0,
			2 => quants[:two_p] || 0,
			1 => quants[:one_p] || 0,
		}
	end

	## Error cases

	def check_valid_quantities(quantities)
		if (quantities.any? { |q| !non_negative_int?(q)})
			raise Exception.new "quantities must all be non negative integers"
		end
	end

	def check_valid_coin(coin_value)
		valid_coins = coin_quantities.keys()
		if !valid_coins.include?(coin_value)
			raise Exception.new "coin deposits must be a valid denomination"
		end
	end

	def check_valid_item(item_value)
		if !non_negative_int?(item_value)
			raise Exception.new "item value is not a valid money value"
		end
	end

	def non_negative_int?(n)
		n >= 0 && n.is_a?(Integer)
	end

end