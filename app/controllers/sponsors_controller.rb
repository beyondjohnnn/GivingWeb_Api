class SponsorsController < ApplicationController

    def index
      render json: Sponsor.all
    end

    def create
      sponsor = Sponsor.new({name: params[:name], sponsor_url_image: params[:sponsor_url_image]})
      if sponsor.save
        render json: sponsor
      else
        render json: {errors: "did not save"}
      end
    end
 end
