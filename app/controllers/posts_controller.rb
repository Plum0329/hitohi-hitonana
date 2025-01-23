class PostsController < ApplicationController
  before_action :require_login, except: [:show, :index]
  before_action :ensure_correct_user, only: [:destroy]
  before_action :load_post_from_session, only: [:new_reading, :new_content, :confirm]
  before_action :set_theme, only: [:new_type, :new_reading, :new_content, :confirm]

  def index
    @posts = Post.includes(:user, :tags, :image_post, theme: [:posts, :image_attachment])
                 .order(created_at: :desc)
                 .page(params[:page])
                 .per(10)
    @image_post = ImagePost.find_by(id: session[:image_post_id]) if session[:image_post_id]
    @show_like_button = false
  rescue => e
    logger.error "Error in posts#index: #{e.message}"
    logger.error e.backtrace.join("\n")
    @posts = Post.none.page(params[:page])
    flash.now[:alert] = "投稿の取得中にエラーが発生しました"
  end

  def show
    @post = Post.includes(:user, :tags, :theme, :image_post).find(params[:id])
    @theme = if @post.theme.present?
      @post.theme
    elsif @post.image_post.present?
      Theme.find_by(image_post_id: @post.image_post.id)
    end
    @show_like_button = true
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: '投稿が見つかりませんでした'
  rescue => e
    logger.error "Error in posts#show: #{e.message}"
    redirect_to posts_path, alert: '投稿の取得中にエラーが発生しました'
  end

  def new_type
    if params[:from_confirm].present?
      session[:from_confirm] = true
    end

    if params[:post].present?
      session[:post_params] ||= {}
      session[:post_params].merge!(params[:post].to_unsafe_h)
    end

    @post = Post.new(session[:post_params])
    ensure_tags_exist

    if @theme
      unless @theme.available_for?(current_user)
        redirect_to theme_path(@theme), alert: 'このお題では句を詠むことができません'
        return
      end
      session[:theme_id] = @theme.id
    elsif session[:no_image]
      session.delete(:image_post_id)
    else
      @image_post = ImagePost.find_by(id: session[:image_post_id]) if session[:image_post_id]
    end
  rescue => e
    logger.error "Error in posts#new_type: #{e.message}"
    logger.error e.backtrace.join("\n")
    redirect_to new_type_posts_path, alert: 'エラーが発生しました'
  end

  def new_reading
    if params[:from_confirm].present?
      session[:from_confirm] = true
    end

    @image_post = ImagePost.find_by(id: session[:image_post_id]) if session[:image_post_id]
    if params[:post] && params[:post][:tag_id].present?
      session[:post_params] ||= {} 
      session[:post_params].merge!(params[:post].to_unsafe_h)
    end

    @post = Post.new(session[:post_params])
    @tag = Tag.find_by(id: session[:post_params]&.dig('tag_id'))

    redirect_to new_type_posts_path, alert: '句の種類を選択してください' unless @tag
  rescue => e
    logger.error "Error in posts#new_reading: #{e.message}"
    redirect_to new_type_posts_path, alert: 'エラーが発生しました'
  end

  def new_content
    if params[:from_confirm].present?
      session[:from_confirm] = true
    end

    @image_post = ImagePost.find_by(id: session[:image_post_id]) if session[:image_post_id]
    if params[:post] && params[:post][:reading].present?
      session[:post_params] ||= {}
      session[:post_params].merge!(params[:post].to_unsafe_h)
    end

    @post = Post.new(session[:post_params])
    @tag = Tag.find_by(id: session[:post_params]&.dig('tag_id'))

    if !session[:post_params]&.dig('reading')
      redirect_to new_reading_posts_path, alert: '読み方を入力してください'
    end
  rescue => e
    logger.error "Error in posts#new_content: #{e.message}"
    redirect_to new_reading_posts_path, alert: 'エラーが発生しました'
  end

  def confirm
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

  def create
    begin
      ActiveRecord::Base.transaction do
        @post = current_user.posts.build(
          reading: session[:post_params]['reading'],
          display_content: session[:post_params]['display_content']
        )

        if session[:theme_id]
          @theme = Theme.find(session[:theme_id])
          @post.theme = @theme
        elsif session[:image_post_id]
          @image_post = ImagePost.find(session[:image_post_id])
          @post.image_post = @image_post

          # 画像投稿からお題を作成
          theme = current_user.themes.build(
            description: @image_post.description,
            image_post: @image_post
          )

          if @image_post.image.present?
            theme.image.attach(@image_post.image.blob)
          end

          theme.save
          @post.theme = theme
        end

        tag_id = session[:post_params]['tag_id']
        if tag_id.present?
          tag = Tag.find_by(id: tag_id)
          @post.tags << tag if tag
        end

        if @post.save
          session[:post_params] = nil
          session.delete(:image_post_id)
          session.delete(:theme_id)
          session.delete(:no_image)
          session.delete(:from_confirm)  # フラグをクリア
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
      end
    rescue => e
      logger.error "Error in posts#create: #{e.message}"
      logger.error e.backtrace.join("\n")
      redirect_to new_type_posts_path, alert: '投稿中にエラーが発生しました'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    begin
      ActiveRecord::Base.transaction do
        if @post.image_post.present?
          theme = Theme.find_by(image_post_id: @post.image_post.id)
          theme.destroy! if theme

          remaining_posts = Post.where(image_post_id: @post.image_post.id)
                              .where.not(id: @post.id)
                              .exists?
          @post.image_post.destroy! unless remaining_posts
        end

        @post.destroy!
        flash[:notice] = '投稿を削除しました'
      end
    rescue => e
      logger.error "Post destroy error: #{e.class}: #{e.message}"
      logger.error e.backtrace.join("\n")
      flash[:alert] = '削除中にエラーが発生しました'
    ensure
      redirect_to posts_path
    end
  end

  def discard
    session[:post_params] = nil
    session.delete(:image_post_id)
    session.delete(:theme_id)
    session.delete(:no_image)
    session.delete(:from_confirm)
    redirect_to root_path, notice: '投稿を破棄しました'
  end

  private

  def post_params
    params.require(:post).permit(:reading, :display_content, :tag_id)
  end

  def ensure_correct_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to posts_path, status: :see_other
    end
  end

  def set_theme
    if params[:theme_id]
      @theme = Theme.find(params[:theme_id])
    elsif session[:theme_id]
      @theme = Theme.find(session[:theme_id])
    end
  rescue ActiveRecord::RecordNotFound
    session.delete(:theme_id)
    redirect_to themes_path, alert: 'お題が見つかりませんでした'
  end

  def load_post_from_session
    if session[:post_params]
      @post = Post.new(session[:post_params])
      @tag = Tag.find_by(id: session[:post_params]['tag_id'])
    else
      @post = Post.new
    end
  end

  def ensure_tags_exist
    if Tag.count == 0
      Tag.find_or_create_by!(name: '俳句')
      Tag.find_or_create_by!(name: '川柳')
    end
    @tags = Tag.where(name: ['俳句', '川柳'])
  end
end