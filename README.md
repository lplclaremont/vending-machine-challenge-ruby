# Vending Machine Change Tracker

## Overview
This API is to be used in conjunction with vending machine software in order to track the coins inside the machine. It is to be set initially with the quantities of each coin denomination which are loaded into the machine and will then update these quantities as the user makes deposits and purchases.

## Design
We have two main problems to solve in constructing this program, keeping track of the coins inside of the machine and finding the correct change to be returned to a user when a purchase is made.

#### Class structure
My program structure includes the following two classes:
 - **CoinBank** which tracks the quantities of each coin inside the machine by updating the values as coins are entered by a user and change is returned.
 - **ChangeGenerator** which finds the coins required in change when a purchase is made based on the quantity of coins available and the amount to be returned.

Therefore, we have a CoinBank class which utilises the ChangeGenerator class. These are dependent on each other as the ChangeGenerator also utilises an instance of CoinBank to find the change to be returned. Below is a basic demonstration of the public interfaces of both classes:

![Screenshot of initial class interface design](./images/class-interfaces.png)

As we can see, CoinBank has three main methods:
- **deposit_coin:** Updates the value of deposited_funds and increments the respective coin quantity in the hash.
- **dispense_change:** Removes the correct coins from the quantities hash and returns the change coins in an array.
- **reset_funds:** Returns the deposited_funds instance variable to 0.

And ChangeGenerator has one main method:
- **get_change:** Finds the coins to be returned from the machine based on the coin_quantities hash from the coin bank.

#### Usage
When creating a CoinBank instance, we must pass as arguments a ChangeGenerator instance and the initial float of coin quantities which are loaded into the machine. These keyword arguments (two_pound: 10, one_pound: 10, .. etc) are used to populate the coin_quantities hash. The change generator is stored as an instance variable and is used in the dispense_change method of CoinBank.
Instances of ChangeGenerator are created with no initialisation arguments, and so the setup for creating a CoinBank instance to track the coins in a vending machine will look like this:
```ruby
change_generator = ChangeGenerator.new()
coin_bank = CoinBank.new(
    change_generator,
    two_pound: 5, one_pound: 5,
    fifty_p: 5, twenty_p: 5,
    ten_p: 5, five_p: 5,
    two_p: 5, one_p: 5
    )
```

**Design choices:**
- By using a ChangeGenerator class we are delegating the calculation of change to a seperate class so that this is more easily reusable should we require that functionality in another part of a wider application. It also ensures CoinBank has a single responsibility, and only updates the quantities without being concerned with how we calculate change.
- Initialising CoinBank instances with a ChangeGenerator instance means that CoinBank does not need to create any instances for itself inside the class, making it less tightly dependent on ChangeGenerator (it only must know that there is a get_change method that it calls), and this also makes unit testing easier since we are able to mock the ChangeGenerator behaviour and pass it in for the purpose of unit testing CoinBank.
- When we call get_change on the ChangeGenerator instance, an instance of CoinBank is passed in so that the change calculation can utilise the coin_quantities hash from the coin_bank. This means that a change_generator just has to access something called 'coin_quantities' from whatever object is passed into it. This means we are not restricted by exactly what this object is, and we can reuse the ChangeGenerator class with other objects which contain a hash of coins and quantities. It could be reused for a vending machine in a different country, for example, with different coin values.
- The CoinBank instances use keyword arguments to input quantities, which forces the programmer to be explicit when defining the initial quantity of each coin and also allows us to create a default quantity for a coin should they not input a value for each denomination.
- The coin_quantities hash stored in a CoinBank instance is of the format {coin_value => quantity}, with the coin_value being the number of pence (£1 = 100, 2p = 2 for example). This means we can easily access the coins by their monetary value which can be used in the calculation of change.