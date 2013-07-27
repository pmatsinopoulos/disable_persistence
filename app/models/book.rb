class Book < ActiveRecord::Base
  attr_accessible :author, :author_id, :title

  validates :author, :presence => true
  validates :title, :uniqueness => {:scope => :author_id, :case_sensitive => false}

  belongs_to :author, :inverse_of => :books
end