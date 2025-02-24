# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Announcement, type: :model do
  describe 'basic model' do
    it 'can be created with valid attributes' do
      admin = create(:user, role: :admin)
      announcement = described_class.new(
        title: 'Test Title',
        content: 'Test Content',
        status: 'published',
        priority: 'normal',
        admin: admin
      )
      expect(announcement).to be_valid
    end
  end
end
