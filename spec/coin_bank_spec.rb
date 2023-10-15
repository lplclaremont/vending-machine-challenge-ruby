require 'coin_bank'

describe 'CoinBank' do
  context 'initially' do
		it 'contains coins with correct quantities given' do
			coin_bank = create_coin_bank(8,7,6,5,4,3,2,1)
			expect(coin_bank.coin_quantities[200]).to eq 8
			expect(coin_bank.coin_quantities[5]).to eq 3
		end

		it 'contains a deposited_funds of 0' do
			coin_bank = create_coin_bank(8,7,6,5,4,3,2,1)												
			expect(coin_bank.deposited_funds).to eq 0
		end
  end

	describe '#add_coin' do
		it 'adds one to the quantity of the corresponding coin' do
			coin_bank = create_coin_bank(8,7,6,5,4,3,2,1)
			coin_bank.add_coin(50)
			coin_bank.add_coin(2)
			expect(coin_bank.coin_quantities[50]).to eq 7
			expect(coin_bank.coin_quantities[2]).to eq 3
		end

		it 'updates the quantity of the corresponding coin after multiple calls' do
			coin_bank = create_coin_bank(8,7,6,5,4,3,2,1)
			coin_bank.add_coin(50)
			coin_bank.add_coin(50)
			coin_bank.add_coin(50)
			expect(coin_bank.coin_quantities[50]).to eq 9
		end
	end

	describe '#remove_coin' do
		it 'reduces coin quantity of corresponding coin by 1' do
			coin_bank = create_coin_bank(8,7,6,5,4,3,2,1)
			coin_bank.remove_coin(50)
			expect(coin_bank.coin_quantities[50]).to eq 5
		end

		it 'updates coin quantity of corresponding coin after multiple calls' do
			coin_bank = create_coin_bank(8,7,6,5,4,3,2,1)
			coin_bank.remove_coin(50)
			coin_bank.remove_coin(50)
			coin_bank.remove_coin(50)
			expect(coin_bank.coin_quantities[50]).to eq 3
		end

		it 'does not reduce a coin quantity to below zero' do
			coin_bank = create_coin_bank(8,7,6,5,4,3,2,1)
			coin_bank.remove_coin(2)
			coin_bank.remove_coin(2)
			coin_bank.remove_coin(2)
			expect(coin_bank.coin_quantities[2]).to eq 0
		end
	end

	describe '#deposit_coin' do
		it 'adds coin to the bank and updates deposited funds' do
			coin_bank = create_coin_bank(8,7,6,5,4,3,2,1)
			coin_bank.deposit_coin(20)
			expect(coin_bank.coin_quantities[20]).to eq 6
			expect(coin_bank.deposited_funds).to eq 20
		end

		it 'adds multiple coins to the bank and updates deposited funds' do
			coin_bank = create_coin_bank(8,7,6,5,4,3,2,1)
			coin_bank.deposit_coin(20)
			coin_bank.deposit_coin(10)
			coin_bank.deposit_coin(100)
			expect(coin_bank.coin_quantities[20]).to eq 6
			expect(coin_bank.coin_quantities[10]).to eq 5
			expect(coin_bank.coin_quantities[100]).to eq 8
			expect(coin_bank.deposited_funds).to eq 130
		end
	end
end



## Helper function in order to create CoinBank instances more easily
def create_coin_bank(*quantities)
	coin_bank = CoinBank.new(two_pound: quantities[0], one_pound: quantities[1], 
				fifty_p: quantities[2], twenty_p: quantities[3], ten_p: quantities[4],
				five_p: quantities[5], two_p: quantities[6], one_p: quantities[7])

	return coin_bank
end