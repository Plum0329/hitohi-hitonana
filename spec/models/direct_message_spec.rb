# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirectMessage, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:admin).class_name('User') }
    it { is_expected.to belong_to(:recipient).class_name('User') }
    it { is_expected.to have_many(:direct_message_reads).dependent(:destroy) }
    it { is_expected.to have_many(:readers).through(:direct_message_reads).source(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:status).with_values(draft: 0, published: 1, archived: 2) }
    it { is_expected.to define_enum_for(:priority).with_values(normal: 0, important: 1, urgent: 2) }
  end

  describe 'scopes' do
    describe '.active' do
      let!(:draft_message) { create(:direct_message, status: :draft) }
      let!(:published_message) { create(:direct_message, status: :published) }
      let!(:archived_message) { create(:direct_message, status: :archived) }

      it 'excludes draft and archived messages' do
        expect(described_class.active).not_to include(draft_message, archived_message)
      end

      it 'includes published messages' do
        expect(described_class.active).to include(published_message)
      end
    end

    describe '.recent' do
      let!(:old_message) { create(:direct_message, created_at: 2.days.ago) }
      let!(:new_message) { create(:direct_message, created_at: 1.day.ago) }

      it 'returns messages in descending order of creation' do
        expect(described_class.recent.to_a).to eq([new_message, old_message])
      end
    end
  end
end
