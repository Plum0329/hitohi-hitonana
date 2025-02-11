# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :require_login
  before_action :set_likeable, only: [:create]
  before_action :set_like, only: [:destroy]

  def create
    @like = current_user.likes.build(likeable: @likeable)

    if @like.save
      flash[:notice] = 'いいねしました'
    else
      flash[:alert] = @like.errors.full_messages.join(', ')
    end
    redirect_back_or_to @likeable
  end

  def destroy
    if @like.destroy
      flash[:notice] = 'いいねを取り消しました'
    else
      flash[:alert] = 'いいねの取り消しに失敗しました'
    end
    redirect_back_or_to @like.likeable
  end

  private

  def set_likeable
    type = params[:likeable_type]
    id = params[:likeable_id]

    if %w[Post Theme].include?(type)
      @likeable = type.constantize.find(id)
    else
      flash[:alert] = '無効なリクエストです'
      redirect_back fallback_location: root_path
    end
  end

  def set_like
    @like = current_user.likes.find_by!(
      likeable_type: params[:likeable_type],
      likeable_id: params[:likeable_id]
    )
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'いいねが見つかりませんでした'
    redirect_back fallback_location: root_path
  end
end
