class PostsController < ApplicationController
  before_action :require_login, except: [:show]
  before_action :set_post, only: [:show, :destroy]
  before_action :ensure_correct_user, only: [:destroy]
  before_action :load_post_from_session, only: [:new_reading, :new_content, :confirm]

  def index
    begin
      @posts = Post.includes(:user, :tags, :image_post).order(created_at: :desc)
      @image_post = ImagePost.find_by(id: session[:image_post_id]) if session[:image_post_id]
    rescue => e
      logger.error "Error in posts#index: #{e.message}"
      @posts = Post.none
      flash.now[:alert] = "投稿の取得中にエラーが発生しました"
    end
  end

  def show
    begin
      @post = Post.includes(:image_post, :tags).find(params[:id])
      @image_post = @post.image_post
    rescue ActiveRecord::RecordNotFound
      redirect_to posts_path, alert: '投稿が見つかりませんでした'
    rescue => e
      logger.error "Error in posts#show: #{e.message}"
      redirect_to posts_path, alert: '投稿の取得中にエラーが発生しました'
    end
  end

  def new_type
    begin
      @post = Post.new
      @image_post = ImagePost.find_by(id: session[:image_post_id]) if session[:image_post_id]
      ensure_tags_exist
    rescue => e
      logger.error "Error in posts#new_type: #{e.message}"
      redirect_to posts_path, alert: 'エラーが発生しました'
    end
  end

  def new_reading
    begin
      @image_post = ImagePost.find_by(id: session[:image_post_id]) if session[:image_post_id]
      if params[:post] && params[:post][:tag_id].present?
        session[:post_params] ||= {} 
        session[:post_params]['tag_id'] = params[:post][:tag_id]
      end
    
      @post = Post.new(session[:post_params])
      @tag = Tag.find_by(id: session[:post_params]&.dig('tag_id'))
    
      redirect_to new_type_posts_path, alert: '句の種類を選択してください' unless @tag
    rescue => e
      logger.error "Error in posts#new_reading: #{e.message}"
      redirect_to new_type_posts_path, alert: 'エラーが発生しました'
    end
  end

  def new_content
    begin
      @image_post = ImagePost.find_by(id: session[:image_post_id]) if session[:image_post_id]
      if params[:post] && params[:post][:reading].present?
        session[:post_params] ||= {}
        session[:post_params].merge!({
          'reading' => params[:post][:reading],
          'tag_id' => params[:post][:tag_id]
        })
      end
    
      @post = Post.new(session[:post_params])
      @tag = Tag.find_by(id: session[:post_params]['tag_id'])
    
      if !session[:post_params]&.dig('reading')
        redirect_to new_reading_posts_path, alert: '読み方を入力してください'
      end
    rescue => e
      logger.error "Error in posts#new_content: #{e.message}"
      redirect_to new_reading_posts_path, alert: 'エラーが発生しました'
    end
  end

  def create
    begin
      @image_post = ImagePost.find_by(id: session[:image_post_id]) if session[:image_post_id]
      @post = current_user.posts.build(
        reading: session[:post_params]['reading'],
        display_content: session[:post_params]['display_content']
      )

      @post.image_post_id = session[:image_post_id] if session[:image_post_id]
    
      tag_id = session[:post_params]['tag_id'] || session[:post_params][:tag_id]
      if tag_id.present?
        tag = Tag.find_by(id: tag_id)
        @post.tags << tag if tag
      end
    
      if @post.save
        session[:post_params] = nil
        session.delete(:image_post_id)
        redirect_to posts_path, notice: '投稿が完了しました'
      else
        errors = @post.errors.full_messages
        flash[:alert] = errors.join("<br>").html_safe

        if @post.tags.empty?
          redirect_to new_type_posts_path
        elsif @post.reading.blank?
          redirect_to new_reading_posts_path
        elsif @post.display_content.blank?
          redirect_to new_content_posts_path
        else
          redirect_to new_type_posts_path
        end
      end
    rescue => e
      logger.error "Error in posts#create: #{e.message}"
      redirect_to new_type_posts_path, alert: '投稿中にエラーが発生しました'
    end
  end

  def confirm
    begin
      @image_post = ImagePost.find_by(id: session[:image_post_id]) if session[:image_post_id]
      if params[:post]
        session[:post_params] ||= {}
        session[:post_params].merge!(params[:post].permit(:display_content, :reading, :tag_id))
      end
      
      @post = Post.new(session[:post_params])
      @tag = Tag.find_by(id: session[:post_params]['tag_id'])
    
      if !session[:post_params]&.dig('display_content')
        redirect_to new_content_posts_path, alert: '本文を入力してください'
      end
    rescue => e
      logger.error "Error in posts#confirm: #{e.message}"
      redirect_to new_content_posts_path, alert: 'エラーが発生しました'
    end
  end

  def destroy
    begin
      @post.destroy!
      redirect_to posts_path, status: :see_other, notice: '投稿を削除しました'
    rescue => e
      logger.error "Error in posts#destroy: #{e.message}"
      redirect_to posts_path, alert: '削除中にエラーが発生しました'
    end
  end

  private

  def post_params
    params.require(:post).permit(:reading, :display_content, :tag_id)
  end

  def set_post
    @post = Post.includes(:image_post, :tags).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: '投稿が見つかりませんでした'
  end

  def ensure_correct_user
    unless @post.user == current_user
      redirect_to posts_path, status: :see_other
    end
  end

  def load_post_from_session
    if session[:post_params]
      @post = Post.new(session[:post_params])
      tag_id = session[:post_params]['tag_id'] || session[:post_params][:tag_id]
      @tag = Tag.find_by(id: tag_id)
    end
  end

  def ensure_tags_exist
    if Tag.count == 0
      Tag.find_or_create_by!(name: '俳句')
      Tag.find_or_create_by!(name: '川柳')
    end
    @tags = Tag.all
  end
end