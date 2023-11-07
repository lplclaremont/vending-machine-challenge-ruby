require 'change_calculator'

describe ChangeCalculator do
	context 'with certainly enough coins inside machine' do
		fake_quantities = {
				200 => 20,
				100 => 20,
				50 => 20,
				20 => 20,
				10 => 20,
				5 => 20,
				2 => 20,
				1 => 20,
			}

		it 'returns an empty array when change_value is zero' do
			mock_coin_bank = double('CoinBank', :coin_quantities => fake_quantities)
			change_calc = ChangeCalculator.new()

			expect(change_calc.get_change(mock_coin_bank, 0)).to eq []
		end

		it 'returns singleton array when one coin required in change' do
			mock_coin_bank = double('CoinBank', :coin_quantities => fake_quantities)
			change_calc = ChangeCalculator.new()

			expect(change_calc.get_change(mock_coin_bank, 100)).to eq [100]
		end

		it 'returns correct change when multiple coins of same denomination required' do
			mock_coin_bank = double('CoinBank', :coin_quantities => fake_quantities)
			change_calc = ChangeCalculator.new()

			expect(change_calc.get_change(mock_coin_bank, 40)).to eq [20, 20]
		end

		it 'returns correct change when coins of different denominations required' do
			mock_coin_bank = double('CoinBank', :coin_quantities => fake_quantities)
			change_calc = ChangeCalculator.new()

			expect(change_calc.get_change(mock_coin_bank, 60)).to eq [50, 10]
		end

		it 'returns correct change when many coins of different denominations required' do
			mock_coin_bank = double('CoinBank', :coin_quantities => fake_quantities)
			change_calc = ChangeCalculator.new()

			expect(change_calc.get_change(mock_coin_bank, 474)).to eq [200, 200, 50, 20, 2, 2]
		end
	end

	context 'with some coins running out in the machine' do
		fake_quantities = {
				200 => 20,
				100 => 20,
				50 => 0,
				20 => 2,
				10 => 20,
				5 => 1,
				2 => 3,
				1 => 0,
			}

		it 'correctly uses 10p coins to get 40p change' do
			mock_coin_bank = double('CoinBank', :coin_quantities => fake_quantities)
			change_calc = ChangeCalculator.new()

			expect(change_calc.get_change(mock_coin_bank, 60)).to eq [20, 20, 10, 10]
		end

		it 'correctly uses 2p coins to return 6p change' do
			mock_coin_bank = double('CoinBank', :coin_quantities => fake_quantities)
			change_calc = ChangeCalculator.new()

			expect(change_calc.get_change(mock_coin_bank, 6)).to eq [2, 2, 2]
		end

		it 'returns no change when it runs out of coins during calculation process' do
			# just two 1 pence coins inside machine
			fake_quantities = {
				1 => 2,
			}
			mock_coin_bank = double('CoinBank', :coin_quantities => fake_quantities)
			change_calc = ChangeCalculator.new()
			
			expect(change_calc.get_change(mock_coin_bank, 3)).to eq []
		end
	end
end