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

		it 'returns no change when item value is same as funds' do
			mock_coin_bank = double('CoinBank', :coin_quantities => fake_quantities)

			change_calc = ChangeCalculator.new()
			expect(change_calc.get_change(mock_coin_bank, 0)).to eq []
		end

		it 'returns singleton array when one coin required in change' do
			mock_coin_bank = double('CoinBank', :coin_quantities => fake_quantities)

			change_calc = ChangeCalculator.new()
			expect(change_calc.get_change(mock_coin_bank, 100)).to eq [100]
		end

		it 'returns correct change when multiple coins of same denomination needed' do
			mock_coin_bank = double('CoinBank', :coin_quantities => fake_quantities)

			change_calc = ChangeCalculator.new()
			expect(change_calc.get_change(mock_coin_bank, 40)).to eq [20, 20]
		end

		it 'returns correct change when multiple coins of different denomination needed' do
			mock_coin_bank = double('CoinBank', :coin_quantities => fake_quantities)

			change_calc = ChangeCalculator.new()
			expect(change_calc.get_change(mock_coin_bank, 60)).to eq [50, 10]
		end
	end

	context 'with some coins running out inside machine' do
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
	end
end