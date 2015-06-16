class Location < ActiveRecord::Base
  # Associatons
  belongs_to :policy
  has_many :buildings, dependent: :destroy

  accepts_nested_attributes_for :buildings

  default_scope { order('created_at ASC') }
end
