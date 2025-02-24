# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnnouncementRead, type: :model do
  describe 'basic model' do
    it 'can be created with valid attributes' do
      admin = create(:user, role: :admin)
      user = create(:user)
      announcement = Announcement.create!(
        title: 'Test Title',
        content: 'Test Content',
        status: 'published',
        priority: 'normal',
        admin: admin
      )
      announcement_read = described_class.new(
        user: user,
        announcement: announcement
      )
      expect(announcement_read).to be_valid
    end
  end
end
