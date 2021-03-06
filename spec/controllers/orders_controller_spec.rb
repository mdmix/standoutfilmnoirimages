require 'rails_helper'

  describe OrdersController, type: :controller do
    before do
      @user1 = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:user)
      @admin = FactoryBot.create(:user)
      @product = FactoryBot.create(:product)
    end
    # let(:userX) { User.create!(email: "woohoo@netscape.net", password: "woohoo") }
    # let(:userY) { User.create!(email: "youpi@netscape.net", password: "youpiyoupi") }
    # let(:userZ) { User.create!(email: "tralala@netscape.net", password: "tralala", admin: true) }
    let(:orderX) { Order.create!(user: @user1, product: @product, total: 59.0) }
    let(:orderY) { Order.create!(user: @user2, product: @product, total: 59.0) }
    # let (:product) {Product.create!(name: "Othello", description: "Good stuff", price: 25.0) }

    describe "GET #show" do
        context "when a logged in user accesses own order" do

          before do
            sign_in @user1
          end

          it "loads correctly user's own orders" do
            get :show, params: { id: orderX.id}
            expect(response).to be_ok
            expect(assigns(:order)).to eq orderX
        end

      end

        context "when a non-admin logged-in user attempts to access another user's order" do

          before do
            sign_in @user2
          end

          it "redirects to 'products-index' root page" do
            get :show, params: { id: orderX.id}
            expect(response).to redirect_to(root_path)
            expect(response).to have_http_status(302)
          end

        end

        context "when a user is not logged in or signed up" do
          it "redirects to login" do
            get :show, params: { id: orderX.id }
            expect(response).to redirect_to(new_user_session_path)
          end

        end

      end

        context "when an admin-user attempts to access another user's specific order" do

          before do
            sign_in @admin
          end

          it "loads correctly the other user's order" do
            get :show, params: { id: orderX.id }
            expect(response).to have_http_status(302)
            expect(assigns(:order)).to eq orderX
          end

        end

  end
