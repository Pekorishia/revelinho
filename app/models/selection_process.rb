class SelectionProcess < ApplicationRecord
  belongs_to :invite
  delegate :position, to: :invite
  delegate :company, to: :position

  has_many :messages, dependent: :destroy
end