class PostsController < ApplicationController
  before_action :require_login, except: [:show]
  before_action :set_post, only: [:show, :destroy]
  before_action :ensure_correct_user, only: [:destroy]

  def index
    @posts = Post.order(created_at: :desc)
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    @current_count = @post.count_syllables(post_params[:content])

    if @post.save
      redirect_to posts_path, notice: '句を投稿しました'
    else
      error_message = if @post.errors[:base].first # エラーメッセージを取得
                       @post.errors[:base].first
                     else
                       "入力内容を確認してください"
                     end
      
      flash.now[:alert] = error_message
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, status: :see_other
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def ensure_correct_user
    unless @post.user == current_user
      redirect_to posts_path, status: :see_other
    end
  end
end