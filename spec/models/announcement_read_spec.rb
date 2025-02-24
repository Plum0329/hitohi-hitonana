# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnnouncementRead, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:announcement) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:announcement_id) }
  end
end
