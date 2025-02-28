# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirectMessageRead, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:direct_message) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    let(:user) { create(:user) }
    let(:direct_message) { create(:direct_message) }

    it 'validates uniqueness of user_id scoped to direct_message_id' do
      create(:direct_message_read, user: user, direct_message: direct_message)
      duplicate_read = build(:direct_message_read, user: user, direct_message: direct_message)
      expect(duplicate_read).not_to be_valid
    end
  end
end
