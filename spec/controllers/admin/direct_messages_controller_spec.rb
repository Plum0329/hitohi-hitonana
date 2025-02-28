# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::DirectMessagesController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:recipient) { create(:user) }

  describe 'actions requiring admin' do
    context 'when logged in as admin' do
      before { login_user(admin) }

      it 'shows index page' do
        get :index
        expect(response).to be_successful
      end

      it 'shows new page' do
        get :new
        expect(response).to be_successful
      end
    end

    context 'when not logged in as admin' do
      it 'redirects from index' do
        get :index
        expect(response).to redirect_to login_path
      end
    end
  end
end
