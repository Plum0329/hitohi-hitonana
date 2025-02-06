class Admin::PostsController < Admin::BaseController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :soft_delete, :restore]

  def index
    @posts = Post.includes(:user, :theme, :likes)

    @posts = case params[:filter]
            when 'available'
              @posts.available
            when 'deleted'
              @posts.deleted
            else
              @posts
            end

    @posts = sort_records(@posts).page(params[:page]).per(20)
  end

  def show
  end

  def edit
    @post = Post.includes(:tags).find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    ActiveRecord::Base.transaction do
      if params[:post][:tag_id].present?
        @post.post_tags.destroy_all
        @post.tags << Tag.find(params[:post][:tag_id])
      end

      if @post.update(post_params)
        redirect_to admin_post_path(@post), notice: '句を更新しました'
      else
        render :edit, status: :unprocessable_entity
      end
    end
  rescue => e
    Rails.logger.error "更新エラー: #{e.message}"
    flash.now[:alert] = '更新できませんでした'
    render :edit, status: :unprocessable_entity
  end

  def soft_delete
    if @post.soft_delete
      redirect_to admin_post_path(@post), notice: '句を非表示にしました'
    else
      flash.now[:alert] = '非表示にできませんでした'
      render :show
    end
  end

  def restore
    if @post.restore
      redirect_to admin_post_path(@post), notice: '句を再表示しました'
    else
      flash.now[:alert] = '再表示できませんでした'
      render :show
    end
  end

  def destroy
    begin
      ActiveRecord::Base.transaction do
        # 関連する削除申請を先に削除
        @post.posts_deletion_requests.destroy_all
        # タグの関連を削除
        @post.post_tags.destroy_all
        # 画像投稿の関連を解除
        if @post.image_post.present?
          @post.update_column(:image_post_id, nil)
        end
        # 投稿を削除
        @post.destroy!
        redirect_to admin_posts_path, notice: '句を完全に削除しました'
      end
    rescue => e
      logger.error "投稿の削除中にエラーが発生しました: #{e.message}"
      redirect_to admin_posts_path, alert: '削除中にエラーが発生しました'
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:display_content, :reading)
  end
end