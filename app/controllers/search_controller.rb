class SearchController < ApplicationController
  def show
    key = "%#{params[:key]}%"
    @member_results =
    Member.where(
      'name LIKE ? OR info LIKE ? OR snippet LIKE ? OR location LIKE ?',
      key, key, key, key).order(:name)
    @charity_results = Charity.where(
      'name LIKE ? OR description LIKE ?',
      key, key).order(:name)

    render json: ({ members: @member_results, charities: @charity_results })
  end
end
