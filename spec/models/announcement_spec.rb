# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Announcement, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:admin).class_name('User') }
    it { is_expected.to have_many(:announcement_reads).dependent(:destroy) }
    it { is_expected.to have_many(:readers).through(:announcement_reads).source(:user) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:status).with_values(draft: 0, published: 1, archived: 2) }
    it { is_expected.to define_enum_for(:priority).with_values(normal: 0, important: 1, urgent: 2) }
  end

  describe 'scopes' do
    describe '.active' do
      let!(:draft_announcement) { create(:announcement, status: :draft) }
      let!(:published_announcement) { create(:announcement, status: :published) }
      let!(:archived_announcement) { create(:announcement, status: :archived) }

      it 'returns only published announcements' do
        expect(described_class.active).to include(published_announcement)
        expect(described_class.active).not_to include(draft_announcement, archived_announcement)
      end
    end

    describe '.recent' do
      let!(:old_announcement) { create(:announcement, created_at: 2.days.ago) }
      let!(:new_announcement) { create(:announcement, created_at: 1.day.ago) }

      it 'orders announcements by created_at desc' do
        expect(described_class.recent.first).to eq(new_announcement)
        expect(described_class.recent.last).to eq(old_announcement)
      end
    end
  end
end
