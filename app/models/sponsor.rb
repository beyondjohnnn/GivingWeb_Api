class Sponsor < ApplicationRecord
  has_many :sponsorships
  has_many :members, :through => :sponsorships
end
