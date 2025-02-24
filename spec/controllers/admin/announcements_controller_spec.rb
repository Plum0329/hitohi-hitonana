# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::AnnouncementsController, type: :controller do
  let(:admin) { create(:user, role: :admin) }
  let(:user) { create(:user, role: :general) }
  let(:announcement) { create(:announcement, admin: admin) }
  let(:valid_attributes) do
    {
      title: 'テストお知らせ',
      content: 'テスト本文です',
      status: 'published',
      priority: 'normal',
      published_at: Time.current
    }
  end
  let(:invalid_attributes) { { title: '', content: '' } }

  describe 'GET #index' do
    context 'as an admin user' do
      before do
        login_user(admin)
        get :index
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'assigns all announcements as @announcements' do
        announcement
        expect(assigns(:announcements)).to include(announcement)
      end
    end

    context 'as a general user' do
      before do
        login_user(user)
        get :index
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #new' do
    before do
      login_user(admin)
      get :new
    end

    it 'returns a success response' do
      expect(response).to be_successful
    end

    it 'assigns a new announcement as @announcement' do
      expect(assigns(:announcement)).to be_a_new(Announcement)
    end
  end

  describe 'POST #create' do
    before do
      login_user(admin)
    end

    context 'with valid params' do
      it 'creates a new Announcement' do
        expect do
          post :create, params: { announcement: valid_attributes }
        end.to change(Announcement, :count).by(1)
      end

      it 'redirects to the announcements list' do
        post :create, params: { announcement: valid_attributes }
        expect(response).to redirect_to(admin_announcements_path)
      end
    end

    context 'with invalid params' do
      it 'does not create a new Announcement' do
        expect do
          post :create, params: { announcement: invalid_attributes }
        end.not_to change(Announcement, :count)
      end

      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { announcement: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'GET #edit' do
    before do
      login_user(admin)
      get :edit, params: { id: announcement.to_param }
    end

    it 'returns a success response' do
      expect(response).to be_successful
    end

    it 'assigns the requested announcement as @announcement' do
      expect(assigns(:announcement)).to eq(announcement)
    end
  end

  describe 'PATCH #update' do
    before do
      login_user(admin)
    end

    context 'with valid params' do
      let(:new_attributes) { { title: '更新されたタイトル' } }

      it 'updates the requested announcement' do
        patch :update, params: { id: announcement.to_param, announcement: new_attributes }
        announcement.reload
        expect(announcement.title).to eq('更新されたタイトル')
      end

      it 'redirects to the announcements list' do
        patch :update, params: { id: announcement.to_param, announcement: valid_attributes }
        expect(response).to redirect_to(admin_announcements_path)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        patch :update, params: { id: announcement.to_param, announcement: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH #publish' do
    let(:draft_announcement) { create(:announcement, admin: admin, status: :draft) }

    before do
      login_user(admin)
      patch :publish, params: { id: draft_announcement.to_param }
    end

    it 'updates the announcement status to published' do
      draft_announcement.reload
      expect(draft_announcement.status).to eq('published')
    end

    it 'sets published_at timestamp' do
      draft_announcement.reload
      expect(draft_announcement.published_at).not_to be_nil
    end

    it 'redirects to the announcements list' do
      expect(response).to redirect_to(admin_announcements_path)
    end
  end

  describe 'PATCH #archive' do
    let(:published_announcement) { create(:announcement, admin: admin, status: :published) }

    before do
      login_user(admin)
      patch :archive, params: { id: published_announcement.to_param }
    end

    it 'updates the announcement status to archived' do
      published_announcement.reload
      expect(published_announcement.status).to eq('archived')
    end

    it 'redirects to the announcements list' do
      expect(response).to redirect_to(admin_announcements_path)
    end
  end
end
