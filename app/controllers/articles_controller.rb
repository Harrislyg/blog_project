class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :show, :destroy]
  before_action :require_user, except: [:index, :show]
  #except for the index and show action, you need to be a logged in user to access the edit, update and delete
  before_action :require_same_user, only: [:edit, :update, :destroy]
  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    #Validation in user id

    if @article.save
      flash[:success] = "Article was successfully created"
      redirect_to article_path(@article)
    else
      render 'new'
    end

  end

  def show
    # @article = Article.find(params[:id])
  end

  def destroy
    # @article = Article.find(params[:id])
    @article.destroy

    flash[:danger] = "Article was successfully deleted"
    redirect_to articles_path
  end

  def edit
    # @article = Article.find(params[:id])

  end

  def update
    # @article = Article.find(params[:id])
    if @article.update(article_params)
      flash[:success] = "Article was successfully updated"
      redirect_to article_path(@article)
    else
      render 'edit'
    end

  end



  private
    def set_article
      @article = Article.find(params[:id])
    end


    def article_params
      params.require(:article).permit(:title, :description)
    end

    def require_same_user
      if current_user != @article.user && !current_user.admin?
        #current_user exist because require_user before action above already ensures that there is a current_user
        #@artcile exsit because the before action that defines @article comes before this before action
        flash[:danger] = "You can only edit or delete your own articles"
        redirect_to root_path
      end
    end

end
