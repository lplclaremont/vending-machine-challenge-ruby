require 'coin_bank'
require 'change_calculator'


describe 'calculating change' do
	it 'reduces the quantities accordingly when finding change' do
		change_calculator = ChangeCalculator.new()

		coin_bank = create_coin_bank(change_calculator, 20,20,20,20,20,20,20,20)
		coin_bank.deposit_coin(50)
		coin_bank.dispense_change(30)

		expect(coin_bank.coin_quantities[20]).to eq 19
	end
end

## Helper function in order to create CoinBank instances more easily
def create_coin_bank(change_calculator, *quantities)
	coin_bank = CoinBank.new(change_calculator,
				two_pound: quantities[0], one_pound: quantities[1], 
				fifty_p: quantities[2], twenty_p: quantities[3], ten_p: quantities[4],
				five_p: quantities[5], two_p: quantities[6], one_p: quantities[7])

	return coin_bank
end