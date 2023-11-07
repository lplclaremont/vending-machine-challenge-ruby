require 'coin_bank'
require 'change_calculator'

describe 'integration' do
	describe 'initialisation' do
		it 'initialises with correct coin_quantities and deposited_funds' do
			change_calculator = ChangeCalculator.new()
			coin_bank = create_coin_bank(change_calculator, 8,7,6,5,4,3,2,1)

			expect(coin_bank.coin_quantities[200]).to eq 8
			expect(coin_bank.coin_quantities[5]).to eq 3
			expect(coin_bank.deposited_funds).to eq 0
		end
	end

	describe 'deposit_coin' do
		it 'adds coin to bank and updates deposited_funds' do
			change_calculator = ChangeCalculator.new()
			coin_bank = create_coin_bank(change_calculator, 0,0,0,0,0,0,0,0)
			coin_bank.deposit_coin(50)

			expect(coin_bank.coin_quantities[50]).to eq 1
			expect(coin_bank.deposited_funds).to eq 50
		end
	end

	describe '#dispense_change' do
		it 'returns an empty array when item_value == deposited_funds' do
			change_calculator = ChangeCalculator.new()
			coin_bank = create_coin_bank(change_calculator, 5,5,5,5,5,5,5,5)
			coin_bank.deposit_coin(50)

			expect(coin_bank.dispense_change(50)).to eq []
		end

		it 'returns a singleton array when one coin returned and decrements the quantity' do
			change_calculator = ChangeCalculator.new()
			coin_bank = create_coin_bank(change_calculator, 5,5,5,5,5,5,5,5)
			coin_bank.deposit_coin(50)

			expect(coin_bank.dispense_change(40)).to eq [10]
			expect(coin_bank.coin_quantities[10]).to eq 4
		end

		it 'returns correct change in more complicated example' do
			change_calculator = ChangeCalculator.new()
			coin_bank = create_coin_bank(change_calculator, 5,5,5,5,5,5,5,5)
			coin_bank.deposit_coin(200)
			coin_bank.deposit_coin(200)

			expect(coin_bank.dispense_change(61)).to eq [200, 100, 20, 10, 5, 2, 2]
		end

		it 'returns helpful string when not enough coins to dispense the right change' do
			change_calculator = ChangeCalculator.new()
			coin_bank = create_coin_bank(change_calculator, 5,5,5,5,5,5,1,0)
			coin_bank.deposit_coin(5)

			expect(coin_bank.dispense_change(2)).to eq 'unable to dispense correct change'
		end
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