class ThemesController < ApplicationController
  before_action :require_login, except: [:index, :show, :all_posts]
  
  def index
    @themes = Theme.includes(:image_attachment, :user)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(10)
  end

  def show
    @theme = Theme.find(params[:id])
    all_posts = @theme.posts.includes(:user, :tags)
    @first_post = all_posts.order(created_at: :asc).first
    
    # ログインユーザーの投稿を取得（存在する場合）
    @my_post = all_posts.find_by(user: current_user) if current_user

    # 最初の投稿とユーザーの投稿を除いた残りの投稿をランダムに並び替え
    excluded_post_ids = [@first_post&.id, @my_post&.id].compact
    @random_posts = all_posts
                    .where.not(id: excluded_post_ids)
                    .order(Arel.sql('RANDOM()'))
                    .limit(3)
    
    @total_posts_count = all_posts.count
  rescue ActiveRecord::RecordNotFound
    redirect_to themes_path, alert: 'お題が見つかりませんでした'
  end

  def user_themes
    @user = User.find(params[:id])
    @themes = @user.themes.includes(:image_attachment)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(10)
  rescue ActiveRecord::RecordNotFound
    redirect_to themes_path, alert: 'ユーザーが見つかりませんでした'
  end

  def new
    @theme = Theme.new
  end

  def create
    @theme = current_user.themes.build(theme_params)

    if @theme.save
      redirect_to themes_path, notice: 'お題を投稿しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @theme = current_user.themes.find(params[:id])
    @theme.destroy
    redirect_to themes_path, notice: 'お題を削除しました', status: :see_other
  rescue ActiveRecord::RecordNotFound
    redirect_to themes_path, alert: 'お題が見つかりませんでした'
  end

  def all_posts
    @theme = Theme.find(params[:id])
    @posts = @theme.posts.includes(:user, :tags)
                  .order(created_at: :asc)
                  .page(params[:page])
                  .per(10)
  rescue ActiveRecord::RecordNotFound
    redirect_to themes_path, alert: 'お題が見つかりませんでした'
  end

  private

  def theme_params
    params.require(:theme).permit(:description, :image)
  end
end