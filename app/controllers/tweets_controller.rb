class TweetsController < ApplicationController

  # コントローラのアクションが実行される前に実行する => indexアクション以外はmove_to_indexメソッドが読み込まれる
  before_action :move_to_index, except: [:index, :show]

  def index
    @tweets = Tweet.includes(:user).page(params[:page]).per(5).order("created_at DESC")
  end

  def new
  end

  def create
    Tweet.create(text: tweet_params[:text], user_id: current_user.id)
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy if tweet.user_id == current_user.id
  end

  def update
    tweet = Tweet.find(params[:id])
    tweet.update(tweet_params) if tweet.user_id == current_user.id
  end

  def edit
    @tweet = Tweet.find(params[:id])
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  private
  def tweet_params
    params.permit(:text)
  end

  # ユーザーがサインインしてない時、indexアクションを実行する
  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end
end
