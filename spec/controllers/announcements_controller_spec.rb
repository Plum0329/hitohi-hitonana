# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnnouncementsController, type: :controller do
  let(:user) { create(:user) }
  let(:announcement) { create(:announcement, status: :published) }

  describe 'GET #index' do
    before do
      announcement
      get :index
    end

    it 'returns a success response' do
      expect(response).to be_successful
    end

    it 'assigns only published announcements as @announcements' do
      draft_announcement = create(:announcement, status: :draft)
      archived_announcement = create(:announcement, status: :archived)

      expect(assigns(:announcements)).to include(announcement)
      expect(assigns(:announcements)).not_to include(draft_announcement, archived_announcement)
    end
  end

  describe 'GET #show' do
    context 'for a published announcement' do
      before do
        get :show, params: { id: announcement.to_param }
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'assigns the requested announcement as @announcement' do
        expect(assigns(:announcement)).to eq(announcement)
      end
    end

    context 'for a draft announcement' do
      let(:draft_announcement) { create(:announcement, status: :draft) }

      it 'raises ActiveRecord::RecordNotFound' do
        expect do
          get :show, params: { id: draft_announcement.to_param }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST #mark_as_read' do
    before do
      login_user(user)
    end

    it 'creates a new announcement_read record' do
      expect do
        post :mark_as_read, params: { id: announcement.to_param }
      end.to change(AnnouncementRead, :count).by(1)
    end

    it 'does not create duplicate records' do
      create(:announcement_read, user: user, announcement: announcement)

      expect do
        post :mark_as_read, params: { id: announcement.to_param }
      end.not_to change(AnnouncementRead, :count)
    end
  end
end
