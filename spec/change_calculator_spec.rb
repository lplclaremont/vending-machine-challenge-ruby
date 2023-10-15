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
			mock_coin_bank = double('CoinBank',
						:coin_quantities => fake_quantities,
						:deposited_funds => 200)

			change_calc = ChangeCalculator.new()
			expect(change_calc.get_change(mock_coin_bank, 200)).to eq []
		end

		it 'returns singleton array when one coin required in change' do
			mock_coin_bank = double('CoinBank',
						:coin_quantities => fake_quantities,
						:deposited_funds => 200)

			change_calc = ChangeCalculator.new()
			expect(change_calc.get_change(mock_coin_bank, 100)).to eq [100]
		end

		it 'returns correct change when multiple coins of same denomination needed' do
			mock_coin_bank = double('CoinBank',
						:coin_quantities => fake_quantities,
						:deposited_funds => 50)

			change_calc = ChangeCalculator.new()
			expect(change_calc.get_change(mock_coin_bank, 10)).to eq [20, 20]
		end

		it 'returns correct change when multiple coins of different denomination needed' do
			mock_coin_bank = double('CoinBank',
						:coin_quantities => fake_quantities,
						:deposited_funds => 100)

			change_calc = ChangeCalculator.new()
			expect(change_calc.get_change(mock_coin_bank, 40)).to eq [50, 10]
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
				2 => 0,
				1 => 20,
			}

			it 'correctly uses different coin denomination to make change' do
				mock_coin_bank = double('CoinBank',
						:coin_quantities => fake_quantities,
						:deposited_funds => 100)

				change_calc = ChangeCalculator.new()
				expect(change_calc.get_change(mock_coin_bank, 40)).to eq [20, 20, 10, 10]
			end
	end
end