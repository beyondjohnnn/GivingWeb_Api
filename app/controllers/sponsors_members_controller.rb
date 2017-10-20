class SponsorsMembersController < ApplicationController

    def index
      render json: SponsorsMember.all
    end

    def create
      sponsor_member = SponsorsMember.new({sponsor_id: params[:sponsor_id], member_id: params[:member_id]})
      if sponsor_member.save
        render json: sponsor_member
      else
        render json: {errors: "did not save"}
      end
    end
 end
