class Blog.Routers.PostsRouter extends Backbone.Router
  initialize: (options) ->
    @posts = new Blog.Collections.PostsCollection()
    @posts.reset options.posts
    console.log("##### ROUTER INIT")

  routes:
    "new"      : "newPost"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newPost: ->
    console.log("##### NEW")
    @view = new Blog.Views.Posts.NewView(collection: @posts)
    $("#posts").html(@view.render().el)

  index: ->
    console.log("##### INDEX")
    @view = new Blog.Views.Posts.IndexView(posts: @posts)
    $("#posts").html(@view.render().el)

  show: (id) ->
    post = @posts.get(id)
    console.log("##### SHOW")
    @view = new Blog.Views.Posts.ShowView(model: post)
    $("#posts").html(@view.render().el)

  edit: (id) ->
    post = @posts.get(id)
    console.log("##### EDIT")
    @view = new Blog.Views.Posts.EditView(model: post)
    $("#posts").html(@view.render().el)
