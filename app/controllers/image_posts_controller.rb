class ImagePostsController < ApplicationController
  before_action :require_login

  def new
    if params[:from_confirm]
      session[:from_confirm] = true
      session[:post_params] = {} unless session[:post_params].is_a?(Hash)
    end

    if params[:image_post].present? && params[:image_post][:id].present?
      @image_post = ImagePost.find(params[:image_post][:id])
      session[:image_post_id] = @image_post.id
    else
      @image_post = if session[:temp_image_post]
        ImagePost.new(session[:temp_image_post].except('image'))
      else
        ImagePost.new
      end
    end
  end

  def create
    if params[:image_post].nil?
      session.delete(:image_post_id)
      session[:no_image] = true
      redirect_to new_type_posts_path
      return
    end
  
    @image_post = ImagePost.new(image_post_params)
  
    if @image_post.save
      if session[:image_post_id].present?
        old_image_post = ImagePost.find_by(id: session[:image_post_id])
        old_image_post&.destroy
      end
      
      session[:image_post_id] = @image_post.id
      session.delete(:temp_image_post)
      session.delete(:no_image)
      redirect_to new_type_posts_path
    else
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