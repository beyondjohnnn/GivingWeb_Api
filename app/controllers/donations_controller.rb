class DonationsController < ApplicationController

  def index
    render json: Donation.all
  end

  def create
	  # Amount in cents
	  amount = params[:donation_amount]
	  token = params[:token]
    email = params[:email]
    
    user = User.where('email = ?', email).first
    pp user['first_name']
    if user['customer_id'] == ""
      customer = Stripe::Customer.create(
	      :email => email,
	      :source  => token[:id]
	    )
      user.update({customer_id: customer.id})
      #user.save
    end

	  pp user

	  charge = Stripe::Charge.create(
      :customer    => user.customer_id,
	    :amount      => amount,
	    :description => "#{amount} donation from user with email #{email}",
	    :currency    => 'gbp'
	  )

	  render json: {return: "payment made"}

	rescue Stripe::CardError => e
	  render json: e.message
	end 

    
 end
