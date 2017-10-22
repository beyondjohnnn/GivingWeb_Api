class CharityFeaturedMembersController < ApplicationController

  def renderMember(charity_id)
    featured_members = CharityFeaturedMember.where(charity_id: charity_id).order(:position)
    featured_members = featured_members.map do |featured_member|
      payload = {
        position: featured_member.position,
        member: featured_member.member.as_json({
          include: [:donations, :comments]
        })
      }
    end
    return featured_members
  end

  def show
    render json: renderMember(params[:id])
  end

  def create
    featured_member = CharityFeaturedMember.new({ charity_id: params[:charity_id], member_id: params[:member_id], position: params[:position]})
    if featured_member.save
      render json: renderMember(params[:charity_id])
    else
      render json: {errors: "did not save"}
    end
  end

  def destroy
    find_charity_id = CharityFeaturedMember.where(member_id: params[:id])[0].delete
    render json: renderMember(find_charity_id.charity_id)
  end
end
