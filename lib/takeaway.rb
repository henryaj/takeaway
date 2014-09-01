require 'rubygems'
require 'twilio-ruby'
require_relative '../lib/twilio'
 
class Takeaway

	include Secrets

	attr_reader :client, :user_total, :order_total

	PRICE_LIST = {"Fiorentina" => 8, "Hawaiian" => 9, "Margherita" => 6, "Pepperoni" => 8, "dip" => 3}

	def place_order(order)
		# binding.pry
		order = order_split(order)
		order = get_quantities_and_products(order)
		order = substitute_in_prices(order)
		@order_total = calculate_total(order)
		
		raise "That total isn't right." if @order_total != user_total
		"Order placed!"
	end

	def order_split(order)
		@order_split = order.split(", ") # splits order into array of items, total
		@user_total = @order_split.pop.gsub('£', '').to_i
		@order_split
	end

	def get_quantities_and_products(order_split)
		order_split.map! { |x| x.split(" ") } # split at each space
		order_split.map! { |x| [x[0].to_i, x[1]] } # convert quantity to integer and produce new double split array
	end

	def substitute_in_prices(order_split)
		order_split.map! { |x| [x[0], x[1].gsub(/[a-zA-Z]+/, PRICE_LIST).to_i] } # sub item for price and convert to integer
	end

	def calculate_total(order_split)
		order_total = 0
		order_split.map! { |x| order_total + (x[0] * x[1]) }
		order_split.inject { |mem, x| mem + x }
	end 

	def send_sms
    t = Time.now + (60*60)
    @delivery_time = t.strftime("%H:%M")
    @client = Twilio::REST::Client.new Secrets::ACCOUNT_SID, Secrets::AUTH_TOKEN
    @client.account.messages.create({
        :from => '+441803503004',
        :to => '+447986347379',
        :body => "Thanks for your order! Your meal will be delivered by #{@delivery_time}. You fat bastard"
    	})
    puts "Message sent: 'Thanks for your order! Your meal will be delivered by #{@delivery_time}. You fat bastard'"
	end

end

# this bit runs only if called from the command line,
# not if run in rspec
if __FILE__==$0
	order = ARGV.join
	raise "You didn't specify an order!" if ARGV == []
	takeaway = Takeaway.new
	takeaway.place_order(order)
	takeaway.send_sms
end