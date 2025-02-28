# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirectMessage, type: :model do
  describe 'validations' do
    it 'requires title' do
      direct_message = build(:direct_message, title: nil)
      expect(direct_message).not_to be_valid
    end

    it 'requires content' do
      direct_message = build(:direct_message, content: nil)
      expect(direct_message).not_to be_valid
    end
  end

  describe 'scopes' do
    it 'returns only published messages' do
      published = create(:direct_message, status: :published)
      create(:direct_message, status: :draft)

      expect(described_class.active).to eq([published])
    end
  end
end
