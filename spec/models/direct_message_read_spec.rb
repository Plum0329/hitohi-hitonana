# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirectMessageRead, type: :model do
  describe 'uniqueness' do
    it 'prevents duplicate reads' do
      read = create(:direct_message_read)
      duplicate = build(:direct_message_read,
                        user: read.user,
                        direct_message: read.direct_message)

      expect(duplicate).not_to be_valid
    end
  end
end
