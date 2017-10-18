class CharityFeaturedMembersController < ApplicationController

    def show
      featured_members = CharityFeaturedMember.where(params[charity_id: params[:id]]).order(:position)

      featured_members = featured_members.map do |members|
        members.member.as_json({
          include: [:donations, :comments]
        })
      end
      render json: featured_members
    end

    def create
      featured_member = CharityFeaturedMember.new({ charity_id: params[:charity_id], member_id: params[:member_id], position: params[:position]})
      if featured_member.save
        render json: featured_member
      else
        render json: {errors: "did not save"}
      end
    end

    def update
      member = CharityFeaturedMember.where(member_id: params[:id])[0]
      member.position = params[:position]
      member.save
      render json: member
    end

    def destroy
      find_charity_id = CharityFeaturedMember.where(member_id: params[:id])[0].delete
      # delete = CharityFeaturedMember.where(member_id: params[:id])[0].delete
      featured_members = CharityFeaturedMember.where(charity_id: find_charity_id.charity_id).order(:position)

      featured_members = featured_members.map do |members|
        members.member.as_json({
          include: [:donations, :comments]
        })
      end
      render json: featured_members
    end
 end
