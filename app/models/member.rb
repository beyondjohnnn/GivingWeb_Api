class Member < ApplicationRecord
  has_many :donations
  has_many :comments
  has_many :member_tags
end
