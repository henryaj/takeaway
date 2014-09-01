require 'takeaway'
require 'twilio'
require 'webmock/rspec'

describe Takeaway do

	before do
		stub_request(:post, "https://*:*@api.twilio.com")
	end

	it 'should list all dishes' do	
		expect(Takeaway::PRICE_LIST).to include("Fiorentina", "Hawaiian", "Margherita", "Pepperoni", "dip")
	end

	it 'all dishes should have a price' do
		expect(Takeaway::PRICE_LIST.values).to include(8, 9, 6, 8, 3)
	end

	it 'should accept an order as a string' do
		expect(Takeaway.place_order("1 Fiorentina, 2 Margherita, 1 dip, £23")).to eq "Order placed!"
	end

	it 'should convert the order string into an array of items' do
		expect(Takeaway.order_split("1 Fiorentina, 2 Margherita, 1 dip, £23")).to eq(["1 Fiorentina", "2 Margherita", "1 dip"])
	end

	it 'should remove the leading £ sign from the order total provided by the user' do
		Takeaway.place_order("1 Fiorentina, 2 Margherita, 1 dip, £23")
		expect(Takeaway.user_total).to eq 23
	end

	it 'should then split the order string into pairs of quantity and product' do
		expect(Takeaway.get_quantities_and_products(["1 Fiorentina", "2 Margherita", "1 dip"])).to eq([[1, "Fiorentina"], [2, "Margherita"], [1, "dip"]])
	end

	it 'should then substitute each dish' do
		expect(Takeaway.substitute_in_prices([[1, "Fiorentina"], [2, "Margherita"], [1, "dip"]])).to eq([[1, 8], [2, 6], [1, 3]])
	end

	it 'should then calculate the order total' do
		expect(Takeaway.calculate_total([[1, 8], [2, 6], [1, 3]])).to eq 23
	end

	it 'should accept order as a string and calculate the total' do
		Takeaway.place_order("1 Fiorentina, 2 Margherita, 1 dip, £23")
		expect(Takeaway.order_total).to eq 23
	end

	it 'should not accept an order with an invalid total' do
		expect{ Takeaway.place_order("1 Fiorentina, 2 Margherita, 1 dip, £58") }.to raise_error
	end

	it 'should send you a text saying that your order will be delivered in an hour' do
		expect(Takeaway.client.account.messages).to receive(:create)
		Takeaway.send_sms
	end


end