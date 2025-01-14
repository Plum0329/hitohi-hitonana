class ImagePostsController < ApplicationController
  before_action :require_login

  def new
    @image_post = if session[:temp_image_post]
      ImagePost.new(session[:temp_image_post].except('image'))
    else
      ImagePost.new
    end
  end

  def create
    if params[:image_post].nil?
      # 画像なしの場合は直接new_type_posts_pathへリダイレクト
      redirect_to new_type_posts_path
      return
    end

    @image_post = ImagePost.new(image_post_params)

    if @image_post.save
      session[:image_post_id] = @image_post.id
      session.delete(:temp_image_post) # 一時保存データを削除
      redirect_to new_type_posts_path
    else
      # エラーの場合、入力データを一時保存
      session[:temp_image_post] = image_post_params.to_h
      flash.now[:alert] = '画像の投稿に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def image_post_params
    params.require(:image_post).permit(:image, :description)
  rescue ActionController::ParameterMissing
    {}
  end
end