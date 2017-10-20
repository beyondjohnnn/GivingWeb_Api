class Member < ApplicationRecord
  has_many :donations
  has_many :comments
  has_many :sponsorships
  has_many :sponsors, :through => :sponsorships
end
