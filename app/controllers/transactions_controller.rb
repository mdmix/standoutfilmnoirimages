class TransactionsController < ApplicationController

    before_action :authenticate_user!
    before_action :check_cart!

    def new
      gon.client_token = generate_client_token
    end

    def create
      @result = Braintree::Transaction.sale(
        amount: current_user.cart_total_price,
        payment_method_nonce: params[:payment_method_nonce])
      if @result.success?
        current_user.purchase_cart_products!
        flash[:notice] = "All classic choices! We'll get your prints to you at 'North By North West' speed!"
        redirect_to root_url
      else
        flash[:alert] = "Hmm, something went wrong, let's try again!"
        gon.client_token = generate_client_token
        render :new
      end
    end


    private

      def check_cart!
        if current_user.get_cart_products_with_qty.blank?
          redirect_to root_url, alert: "Without adding prints, you won't go anywhere"
        end
      end

      def generate_client_token
        Braintree::ClientToken.generate
      end

end
