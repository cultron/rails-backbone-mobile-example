class Post < ActiveRecord::Base
  attr_accessible :content, :title
  acts_as_commentable
end
