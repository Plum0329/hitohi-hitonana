# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::DirectMessagesController, type: :controller do
  describe 'as admin' do
    let(:admin) { create(:user, :admin) }

    before do
      login(admin)
    end

    it 'accesses index' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'as general user' do
    let(:user) { create(:user) }

    before do
      login(user)
    end

    it 'cannot access index' do
      get :index
      expect(response).to redirect_to(admin_login_path)
    end
  end
end
