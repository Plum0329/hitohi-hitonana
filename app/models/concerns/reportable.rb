# frozen_string_literal: true

module Reportable
  extend ActiveSupport::Concern

  included do
    belongs_to :user

    enum :reason_category, {
      inappropriate: 0,
      spam: 1,
      copyright: 2,
      harassment: 3,
      other: 4
    }, prefix: true

    validates :reason, presence: true, length: { minimum: 10, maximum: 1000 }
    validates :reason_category, presence: true

    enum :status, { pending: 0, approved: 1, rejected: 2 }
  end
end
