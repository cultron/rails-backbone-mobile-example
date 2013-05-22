class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /recordings/:external/comment
  def comment
    @recording = Recording.find_by_external(params[:external])
    comment = @recording.comments.new("user_id" => current_user.id, "comment" => params[:comment])
    respond_to do |format|
      if comment.save
        format.html { redirect_to :back }
        format.json { render :json => @recording, :status => :created, :location => @recording }
      else
        format.html { redirect_to :back, :alert => "Sorry, There was an error processing your comment. Please try again" }
        format.json { render :json => @recording.errors, :status => :unprocessable_entity }
      end
    end
  end


  def votes
    r = Recording.where(:external => params[:external]).first
    if current_user.voted_for?(r)
      json = [:voted_for => true, :voted_against => false]
    elsif current_user.voted_against?(r)
      json = [:voted_for => false, :voted_against => true]
    else
      json = [:voted_for => false, :voted_against => false]
    end
    respond_to do |format|
      format.json { render :json => json.to_json }
    end
  end


  def vote
   r = Recording.where(:external => params[:external]).first
   if params[:direction].eql? "up"
     current_user.vote_exclusively_for(r)
     json = [:voted_for => true, :voted_against => false]
   else
     current_user.vote_exclusively_against(r)
     json = [:voted_for => false, :voted_against => true]
   end

   respond_to do |format|
    format.json { render :json => json.to_json }
   end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(title: params[:post][:title], content: params[:post][:content])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end
