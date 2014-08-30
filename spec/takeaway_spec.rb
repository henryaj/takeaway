require 'takeaway'
require 'webmock/rspec'

describe Takeaway do
	
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

	xit 'should take each order line and split it into quantity and item' do
		Takeaway.place_order("1 Fiorentina, 2 Margherita, 1 dip, £23")
		expect(Takeaway.order_item_split).to eq()
	end

	xit 'should calculate the order total' do
		Takeaway.place_order("1 Fiorentina, 2 Margherita, 1 dip, £26")
		expect(Takeaway.calculate_total).to eq 23
	end

	xit 'should not accept an order with an invalid total' do
		expect{ Takeaway.place_order("1 Fiorentina, 2 Margherita, 1 dip, £58") }.to raise_error
	end

	it 'should send a text saying that your order will be delivered in one hour' do
		t = Time.now + (60*60)
    @delivery_time = t.strftime("%H:%M")
		stub_request(:post, "https://#{Secrets::ACCOUNT_SID}:#{Secrets::AUTH_TOKEN}@api.twilio.com/*").
         with(:body => {"Body"=>"Thanks for your order! Your meal will be delivered by #{@delivery_time}. You fat bastard", "From"=>"+441803503004", "To"=>"+447986347379"}).
         to_return(:status => 200, :body => "", :headers => {})
		end


end