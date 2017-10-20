require "pp"

class ChargesController < ApplicationController

	def new
	end

	def create
	  # Amount in cents
	  @amount = 500
	  token = params[:token]

	  customer = Stripe::Customer.create(
	    :email => token[:email],
	    :source  => token[:id]
	  )

	  charge = Stripe::Charge.create(
	    :customer    => customer.id,
	    :amount      => @amount,
	    :description => 'Rails Stripe customer',
	    :currency    => 'gbp'
	  )

	  render json: {return: "payment made"}

	rescue Stripe::CardError => e
	  render json: e.message
	end

end
