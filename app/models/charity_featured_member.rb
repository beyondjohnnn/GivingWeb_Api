class CharityFeaturedMember < ApplicationRecord
  belongs_to :charity
  belongs_to :member
end
