class FeedbackMessage < ActiveRecord::Base
  #FIXME: use strong parameters
  #attr_accessible :name, :email, :content
  validates_presence_of :name, :email, :content
end
