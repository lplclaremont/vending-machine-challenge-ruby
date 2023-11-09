require_relative './lib/change_calculator'
require_relative './lib/coin_bank'

puts("")
puts("Test out the coin storage API as follows:")
puts("We'll set up an initial state of 20 coins of each denomination in the machine.")
puts("Now you can view the total coins in the machine,")
puts("deposit funds (one coin at a time) and see the change when purchasing an item.")
puts("")
puts("Enter 'peek' to see the total coins,")
puts("'deposit' to deposit a coin")
puts("'purchase' to see the change given with an order")
puts("type 'exit' to finish testing")
puts("")

change_calculator = ChangeCalculator.new()
coin_bank = CoinBank.new(
    change_calculator,
    two_pound: 20, one_pound: 20,
    fifty_p: 20, twenty_p: 20,
    ten_p: 20, five_p: 20,
    two_p: 20, one_p: 20
)

def purchase_item(coin_bank)
    puts("Enter value of item to buy (in pence)")
    puts("i.e., £2.50 = 250, 79p = 79")
    puts("Note -- deposited funds: ", coin_bank.deposited_funds)
    begin
        item_value = gets.chomp.to_i
        puts("Change received: ", coin_bank.dispense_change(item_value))
        coin_bank.reset_funds()
    rescue Exception => error
        puts("An exception occurred: #{error.message}")
    end
end

def deposit(coin_bank)
    puts("Enter a coin to deposit (in pence)")
    puts("i.e, £1 = 100, 20p = 20, 1p = 1")
    begin
        coin = gets.chomp.to_i
        coin_bank.deposit_coin(coin)
        puts ""
        puts("New total funds: ", coin_bank.deposited_funds)
    rescue Exception => error
        puts "An exception occurred: #{error.message}"
    end
end

while true do
    puts("'peek': see coins")
    puts("'deposit': add coin")
    puts("'purchase': see change given")
    puts("'exit' to finish")
    response = gets.chomp

    if (response == 'peek')
        puts(coin_bank.coin_quantities)   
    elsif (response == 'purchase')
        purchase_item(coin_bank)
    elsif (response == 'deposit')
        deposit(coin_bank)      
    elsif (response == 'exit')
        break
    end
    puts(" ")
end