class SearchController < ApplicationController

  def show

    key = "%#{params[:searchTerm].downcase}%"

    @member_results = Member.limit(3).where(
      'lower(name) LIKE ? OR lower(info) LIKE ? OR lower(snippet) LIKE ? OR lower(location) LIKE ?',
      key,
      key,
      key,
      key
    ).order(:name)

    @charity_results = Charity.limit(3).where(
      'lower(name) LIKE ? OR lower(description) LIKE ?',
      key,
      key
    ).order(:name)

    render json: ({ members: @member_results, charities: @charity_results })
  end

end
