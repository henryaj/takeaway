require 'rubygems'
require 'twilio-ruby'
require_relative '../lib/twilio'
 


class Takeaway

	include Secrets

	PRICE_LIST = {"Fiorentina" => 8, "Hawaiian" => 9, "Margherita" => 6, "Pepperoni" => 8, "dip" => 3}

	def self.place_order(order)
		"Order placed!"
	end

	def self.order_split(order)
		@order_split = order.split(", ") # splits order into array of items, total
		@user_total = @order_split.pop.gsub('£', '').to_i
		@order_split
	end

	def self.calculate_total 
		@order_split.map! { |x| x.split(" ") }
		@order_quantities = @order_split.map { |x| x[0]}
		@order_prices = @order_split.map { |x| x[1].gsub(/\D+/, PRICE_LIST) }
		@order_total = @order_quantities.map do |q|
			@order_prices.map! { |p| puts p.to_i * q }
		end
	end

	def self.user_total
		@user_total
	end

	def self.send_message
		begin
    t = Time.now + (60*60)
    @delivery_time = t.strftime("%H:%M")
    @client = Twilio::REST::Client.new Secrets::ACCOUNT_SID, Secrets::AUTH_TOKEN
    @client.account.messages.create({
        :from => '+441803503004',
        :to => '+447986347379',
        :body => "Thanks for your order! Your meal will be delivered by #{@delivery_time}. You fat bastard"
    	})
		rescue Twilio::REST::RequestError => e
    	puts e.messages
		end
	end

end

Takeaway.send_message