# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirectMessagesController, type: :controller do
  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:direct_message) { create(:direct_message, recipient: user) }

    context 'when logged in' do
      before { login_user(user) }

      it 'shows the message successfully' do
        get :show, params: { id: direct_message.id }
        expect(response).to be_successful
      end
    end

    context 'when not logged in' do
      it 'redirects to login' do
        get :show, params: { id: direct_message.id }
        expect(response).to redirect_to login_path
      end
    end
  end
end
