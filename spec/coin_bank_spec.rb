require 'coin_bank'

describe 'CoinBank' do
  context 'initially' do
		it 'contains coins with correct quantities given' do
			mock_change_calc = double('ChangeCalculator')
			coin_bank = create_coin_bank(mock_change_calc, 8,7,6,5,4,3,2,1)
			
			expect(coin_bank.coin_quantities[200]).to eq 8
			expect(coin_bank.coin_quantities[5]).to eq 3
		end

		it 'contains a deposited_funds of 0' do
			mock_change_calc = double('ChangeCalculator')
			coin_bank = create_coin_bank(mock_change_calc, 8,7,6,5,4,3,2,1)												
			
			expect(coin_bank.deposited_funds).to eq 0
		end

		it 'defaults to 0 quantity when no value given' do
			mock_change_calc = double('ChangeCalculator')
			coin_bank = CoinBank.new(
				mock_change_calc, ten_p: 10
			)

			expect(coin_bank.coin_quantities[20]).to eq 0
			expect(coin_bank.coin_quantities[10]).to eq 10
			expect(coin_bank.coin_quantities[2]).to eq 0
		end
  end

	describe '#add_coin' do
		it 'adds one to the quantity of the corresponding coin' do
			mock_change_calc = double('ChangeCalculator')
			coin_bank = create_coin_bank(mock_change_calc, 8,7,6,5,4,3,2,1)
			coin_bank.add_coin(50)
			coin_bank.add_coin(2)

			expect(coin_bank.coin_quantities[50]).to eq 7
			expect(coin_bank.coin_quantities[2]).to eq 3
		end

		it 'updates the quantity of the corresponding coin after multiple calls' do
			mock_change_calc = double('ChangeCalculator')
			coin_bank = create_coin_bank(mock_change_calc, 8,7,6,5,4,3,2,1)
			coin_bank.add_coin(50)
			coin_bank.add_coin(50)
			coin_bank.add_coin(50)

			expect(coin_bank.coin_quantities[50]).to eq 9
		end
	end

	describe '#remove_coin' do
		it 'reduces coin quantity of corresponding coin by 1' do
			mock_change_calc = double('ChangeCalculator')
			coin_bank = create_coin_bank(mock_change_calc, 8,7,6,5,4,3,2,1)
			coin_bank.remove_coin(50)

			expect(coin_bank.coin_quantities[50]).to eq 5
		end

		it 'updates coin quantity of corresponding coin after multiple calls' do
			mock_change_calc = double('ChangeCalculator')
			coin_bank = create_coin_bank(mock_change_calc, 8,7,6,5,4,3,2,1)
			coin_bank.remove_coin(50)
			coin_bank.remove_coin(50)
			coin_bank.remove_coin(50)

			expect(coin_bank.coin_quantities[50]).to eq 3
		end

		it 'does not reduce a coin quantity to below zero' do
			mock_change_calc = double('ChangeCalculator')
			coin_bank = create_coin_bank(mock_change_calc, 8,7,6,5,4,3,2,1)
			coin_bank.remove_coin(2)
			coin_bank.remove_coin(2)
			coin_bank.remove_coin(2)

			expect(coin_bank.coin_quantities[2]).to eq 0
		end
	end

	describe '#deposit_coin' do
		it 'adds coin to the bank and updates deposited funds' do
			mock_change_calc = double('ChangeCalculator')
			coin_bank = create_coin_bank(mock_change_calc, 8,7,6,5,4,3,2,1)
			coin_bank.deposit_coin(20)

			expect(coin_bank.coin_quantities[20]).to eq 6
			expect(coin_bank.deposited_funds).to eq 20
		end

		it 'adds multiple coins to the bank and updates deposited funds' do
			mock_change_calc = double('ChangeCalculator')
			coin_bank = create_coin_bank(mock_change_calc, 8,7,6,5,4,3,2,1)
			coin_bank.deposit_coin(20)
			coin_bank.deposit_coin(10)
			coin_bank.deposit_coin(100)

			expect(coin_bank.coin_quantities[20]).to eq 6
			expect(coin_bank.coin_quantities[10]).to eq 5
			expect(coin_bank.coin_quantities[100]).to eq 8
			expect(coin_bank.deposited_funds).to eq 130
		end
	end

	describe '#dispense_change' do
		it 'does not change coin_quantities when no change required' do
			mock_change_calc = double('ChangeCalculator', :get_change => [])
			coin_bank = create_coin_bank(mock_change_calc, 8,7,6,5,4,3,2,1)
			
			expect(coin_bank.dispense_change(10))
			.to eq 'unable to dispense correct change'

			expect(coin_bank.coin_quantities[1]).to eq 1
			expect(coin_bank.coin_quantities[2]).to eq 2
			expect(coin_bank.coin_quantities[5]).to eq 3
		end

		it 'reduces the quantity of corresponding coin when one coin returned as change' do
			mock_change_calc = double('ChangeCalculator')
			allow(mock_change_calc).to receive(:get_change)
			.with(any_args).and_return([10])
			coin_bank = create_coin_bank(mock_change_calc, 8,7,6,5,4,3,2,1)

			expect(coin_bank.dispense_change(10)).to eq [10]
			expect(coin_bank.coin_quantities[10]).to eq 3
		end

		it 'reduces the quantity of corresponding coin when one coin returned as change' do
			mock_change_calc = double('ChangeCalculator')
			allow(mock_change_calc).to receive(:get_change)
			.with(any_args).and_return([10])
			coin_bank = create_coin_bank(mock_change_calc, 8,7,6,5,4,3,2,1)

			expect(coin_bank.dispense_change(10)).to eq [10]
			expect(coin_bank.coin_quantities[10]).to eq 3
		end

		it 'returns a helpful string when machine can not return the correct change' do
			mock_change_calc = double('ChangeCalculator')
			allow(mock_change_calc).to receive(:get_change)
			.with(any_args).and_return([])
			coin_bank = create_coin_bank(mock_change_calc, 0,0,0,0,0,0,0,0)
			coin_bank.deposit_coin(20)

			expect(coin_bank.dispense_change(10))
			.to eq 'unable to dispense correct change'
		end
	end

	describe '#reset_funds' do
		it 'sets the deposited_funds value back to zero' do
			mock_change_calc = double('ChangeCalculator')
			coin_bank = create_coin_bank(1,2,3,4,5,6,7,8)
			coin_bank.deposit_coin(20)

			expect(coin_bank.deposited_funds).to eq 20
			coin_bank.reset_funds
			
			expect(coin_bank.deposited_funds).to eq 0
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