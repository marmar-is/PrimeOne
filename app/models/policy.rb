class Policy < ActiveRecord::Base
  # Callbacks
  after_save :notify_status
  # Validations
  validates :number, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true

  # Associations
  belongs_to :broker

  has_one :property, dependent: :destroy
  has_one :gl, dependent: :destroy
  has_one :crime, dependent: :destroy
  has_one :auto, dependent: :destroy
  has_many :locations, dependent: :destroy

  accepts_nested_attributes_for :property
  accepts_nested_attributes_for :crime
  accepts_nested_attributes_for :gl
  accepts_nested_attributes_for :auto
  accepts_nested_attributes_for :locations


  private
    def notify_status
      if self.status_changed?
        
      end
    end
end
