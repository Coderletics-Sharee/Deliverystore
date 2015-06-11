class User < ActiveRecord::Base
  has_many :purchases, foreign_key: :buyer_id
has_many :deliveries, through: :purchases
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

def cart_count
  $redis.scard "cart#{id}"
end

def cart_total_price
  total_price = 0
  get_cart_deliveries.each { |delivery| total_price+= delivery.price }
  total_price
end
 
def get_cart_deliveries
  cart_ids = $redis.smembers "cart#{id}"
  Delivery.find(cart_ids)
end

def purchase_cart_deliveries!
  get_cart_deliveries.each { |delivery| purchase(delivery) }
  $redis.del "cart#{id}"
end
 
def purchase(delivery)
  deliveries << delivery unless purchase?(delivery)
end
 
def purchase?(delivery)
  deliveries.include?(delivery)
end

FIELDS = [:first_name, :last_name, :phone, :website, :company, :fax, :addresses, :credit_cards, :custom_fields]
  attr_accessor *FIELDS

  def has_payment_info?
    #braintree_customer_id
  end

  def with_braintree_data!
    return self unless has_payment_info?
    braintree_data = Braintree::Customer.find(braintree_customer_id)

    FIELDS.each do |field|
      send(:"#{field}=", braintree_data.send(field))
    end
    self
  end

  def default_credit_card
    return unless has_payment_info?
    credit_cards.find { |cc| cc.default? }
  end

end
