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
      redirect_to new_type_posts_path
      return
    end
  
    @image_post = ImagePost.new(image_post_params)
  
    if @image_post.save
      # ここでお題を作成
      theme = current_user.themes.build(
        description: @image_post.description,
        image_post: @image_post
      )
  
      if @image_post.image.attached?
        theme.image.attach(@image_post.image.blob)
      end
  
      theme.save
  
      session[:image_post_id] = @image_post.id
      session.delete(:temp_image_post)
      redirect_to new_type_posts_path
    else
      session[:temp_image_post] = image_post_params.to_h
      flash.now[:alert] = '画像の投稿に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def complete
    @image_post = ImagePost.find(session[:image_post_id])

    if current_user
      theme = current_user.themes.build(
        description: @image_post.description,
        image_post: @image_post
      )
  
      if @image_post.image.attached?
        theme.image.attach(@image_post.image.blob)
      end
      
      if theme.save
        flash[:notice] = 'お題が作成されました'
      else
        flash[:alert] = 'お題の作成に失敗しました'
      end
    end
    
    session.delete(:image_post_id)
  end

  private

  def image_post_params
    params.require(:image_post).permit(:image, :description)
  rescue ActionController::ParameterMissing
    {}
  end
end