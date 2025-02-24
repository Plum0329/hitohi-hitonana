# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnnouncementRead, type: :model do
  describe 'basic model' do
    let(:user) { create(:user) }
    let(:announcement) { create(:announcement) }

    it 'can be created with valid attributes' do
      announcement_read = build(:announcement_read, user: user, announcement: announcement)
      expect(announcement_read).to be_valid
    end
  end
end
