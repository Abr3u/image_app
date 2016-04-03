class PostsController < ApplicationController
	before_action :find_post, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
	before_action :authenticate_user!, except: [:index, :show]

  def new
    @post = Post.new
  end

  def index
	@posts = Post.all
  end

  def show
		@comments = Comment.where(post_id: @post)
	end
  
  def edit
	end
	
	def update
		if @post.update(post_params)
			redirect_to @post
		else
			render 'edit'
		end
	end

	def destroy
		@post.destroy
		redirect_to root_path
	end
  
  def create
    @post = Post.new(permit_post)
    if @post.save
      flash[:success] = "Success creating new post"
      redirect_to post_path(@post)
    else
      flash[:error] = @post.errors.full_messages
      redirect_to new_post_path
    end
  end
  
  def upvote
		@post.upvote_by current_user
		redirect_to :back
	end

	def downvote
		@post.downvote_from current_user
		redirect_to :back
	end
  
  private
  def find_post
		@post = Post.find(params[:id])
	end
  
    def permit_post
        params.require(:post).permit(:avatar,:description)
    end  
end
