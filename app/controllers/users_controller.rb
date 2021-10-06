class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :logged_in, except: %i[ login_page login_fail ]
  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  	if(logged_in)
   		@posts = User.find(@user.id).posts
   	else
   		return
   	end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    render 'destroy'
    # respond_to do |format|
    #   format.html { redirect_to users_url, notice: "User was successfully destroyed." }
    #   format.json { head :no_content }
    #format.html {notice: "test"}
  end

  def create_fast
    @name = params[:name]
    @email = params[:email]
    User.create( name: @name, email: @email)
  end
  
  def login_page
    	session[:user_id] = nil
  end
  
  def check_login
	@loginEmail = params[:email]
	@loginPassword = params[:password]
	@usermatch = false
	@find = User.find_by(email:@loginEmail)
	if(@find && @find.authenticate(@loginPassword))
	  	redirect_to user_path(@find.id), notice: "Login successfully."
	  	@usermatch = true
	  	session[:user_id] = @find.id
	end
  	if(@usermatch == false)
  		render :_loginfail
  	end
  end
  
  def login_fail
  	
  end
  
  def create_post
	@post = Post.new()
	@post.user_id = params[:user_id]
  end
  def add_post
  	@post = Post.new(post_params)
	if @post.save
		redirect_to user_url(@post.user_id), notice: "Post was successfully created."
    	end
  end
  
  def edit_post_page
  	@user = User.find(params[:user_id])
	@post = @user.posts.find(params[:post_id])
  end
  
  def update_post
  	@user = User.find(params[:user_id])
  	@post = @user.posts.find(params[:post_id])
  	@post.update(post_params)
  	redirect_to user_url(@user.id), notice: "Edit post successfully."
  end
  
  def delete_post_page
  	@user = User.find(params[:user_id])
  	@post = @user.posts.find(params[:post_id])
  	@post.destroy()
  	redirect_to user_url(@user.id), notice: "Delete post successfully."
  end
  private
    def logged_in
  	if(session[:user_id])
  		return true
  	else
  		redirect_to main_path, notice: "Please login."
  	end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :name, :birthdate, :address, :postal_code, :password)
    end
    def post_params
      params.require(:post).permit(:user_id, :msg)
    end
end
