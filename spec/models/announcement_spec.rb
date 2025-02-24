# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Announcement, type: :model do
  describe 'basic model' do
    let(:admin) { create(:user, role: :admin) }

    it 'can be created with valid attributes' do
      announcement = build(:announcement, admin: admin)
      expect(announcement).to be_valid
    end
  end
end
