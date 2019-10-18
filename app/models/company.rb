class Company < ApplicationRecord
  has_one :company_profile, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :positions, dependent: :destroy
  validates :name, :address, presence: true, on: :update

  enum status: { pending: 0, active: 10 }
end
