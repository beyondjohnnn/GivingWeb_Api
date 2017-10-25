class SearchController < ApplicationController

  def show

    fuzzy = "%#{params[:searchTerm].downcase}%"
    priority = "#{params[:searchTerm].downcase}%"

    @member_results_by_name = Member.limit(3).where('lower(name) LIKE ?', priority).order(:name)

    @member_results = Member.limit(3).where(
      'lower(name) LIKE ? OR lower(info) LIKE ? OR lower(snippet) LIKE ? OR lower(location) LIKE ?',
      fuzzy,
      fuzzy,
      fuzzy,
      fuzzy
    ).order(:name)
    sorted_by_name = @member_results_by_name.merge(@member_results)
    sorted_by_name = sorted_by_name.as_json({
        include: [:donations, :comments, :sponsors]
      })

    @charity_results = Charity.limit(3).where(
      'lower(name) LIKE ? OR lower(description) LIKE ?',
      fuzzy,
      fuzzy
    ).order(:name)

    render json: ({ members: sorted_by_name, charities: @charity_results })
  end

end
