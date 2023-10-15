require 'coin_bank'

describe 'CoinBank' do
  context 'initially' do
      it 'contains coins with correct quantities given' do
        coin_bank = CoinBank.new(two_pound: 8, one_pound: 7,fifty_p: 6,
																	twenty_p: 5,ten_p: 4, five_p: 3,
																	two_p: 2, one_p: 1)

				expect(coin_bank.coin_quantities[200]).to eq 8
        expect(coin_bank.coin_quantities[5]).to eq 3
      end

      it 'contains a deposited_funds of 0' do
        coin_bank = CoinBank.new(two_pound: 8, one_pound: 7,fifty_p: 6,
																	twenty_p: 5,ten_p: 4, five_p: 3,
																	two_p: 2, one_p: 1)
																	
				expect(coin_bank.deposited_funds).to eq 0
      end
  end
end