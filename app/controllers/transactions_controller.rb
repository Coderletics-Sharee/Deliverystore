class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_braintree_data, only: [:show, :edit]

def show
end

  def new
  gon.client_token = generate_client_token
 end
 
 def edit
    @credit_card = current_user.default_credit_card
    @tr_data = edit_customer_tr_data
  end
  
 def create
    unless current_user.has_payment_info?
    @result = Braintree::Transaction.sale(
                amount: current_user.cart_total_price,
                payment_method_nonce: params[:payment_method_nonce],
                customer: {
                  first_name: params[:first_name],
                  last_name: params[:last_name],
                  #company: params[:company],
                  email: current_user.email,
                  phone: params[:phone]
                },
                options: {
                  store_in_vault: true
                })
  else
    @result = Braintree::Transaction.sale(
              amount: current_user.cart_total_price,
              payment_method_nonce: params[:payment_method_nonce])
    end
    if @result.success?
      #current_user.update(braintree_customer_id: @result.transaction.customer_details.id) unless current_user.has_payment_info?
    current_user.purchase_cart_deliveries!
    redirect_to root_url, notice: "Congraulations! Your transaction has been successfull!"
  else
    flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
    gon.client_token = generate_client_token
    render :new
  end
  end

private
def generate_client_token
  if current_user.has_payment_info?
    Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
  else
    Braintree::ClientToken.generate
  end

#def check_cart
    #if current_user.get_cart_deliveries.blank?
      #redirect_to root_url, alert: "Please add some items to your cart before processing your transaction!"
    #end
  end
end
