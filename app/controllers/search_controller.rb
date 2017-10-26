class SearchController < ApplicationController

  def show
    search_term = params[:searchTerm].downcase
    priority = "#{search_term}%"
    fuzzy = "%#{search_term}%"

    result_limit = 3
    @member_results = search_members_by_name(priority, result_limit)
    found_names = get_found_members_names(@member_results)

    result_limit -= @member_results_by_name.length
    @member_results = Member.limit(result_limit).where(
      "lower(name) NOT IN (#{found_names}) AND (lower(name) LIKE ? OR lower(info) LIKE ? OR lower(snippet) LIKE ? OR lower(location) LIKE ?)",
      fuzzy,
      fuzzy,
      fuzzy,
      fuzzy
    ).order(:name)

    sorted_by_name = @member_results_by_name + @member_results
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

def search_members_by_name(search_term, limit)
  return @member_results_by_name = Member.limit(limit).where('lower(name) LIKE ?', search_term).order(:name)
end

def get_found_members_names(members)
  found_names = []
  for member in @member_results_by_name
    found_names.push("'#{member.name.downcase}'")
  end
  return found_names.length > 0 ? found_names.join(", ") : "'0'"
end
