require 'takeaway'

describe Takeaway do
	
	it 'should list all dishes' do	
		expect(Takeaway.list_dishes).to include("Fiorentina", "Hawaiian", "Margherita", "Pepperoni", "garlic bread")
	end

	it 'all dishes should have a price' do
		takeaway_prices = Takeaway.list_dishes.values
		expect(takeaway_prices).to include(8, 9, 6, 8, 3)
	end

end