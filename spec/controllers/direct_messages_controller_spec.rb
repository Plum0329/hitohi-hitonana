# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirectMessagesController, type: :controller do
  describe 'as recipient' do
    let(:user) { create(:user) }
    let(:direct_message) { create(:direct_message, recipient: user) }

    before do
      login(user)
    end

    it 'can view own message' do
      get :show, params: { id: direct_message.id }
      expect(response).to be_successful
    end
  end
end
