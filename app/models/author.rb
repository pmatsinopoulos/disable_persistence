class Author < ActiveRecord::Base
  attr_accessible :first_name, :last_name

  validates :first_name, :presence => true
  validates :last_name,  :presence => true
  validates :last_name, :uniqueness => {:scope => :first_name, :case_sensitive => false}

  has_many :books, :inverse_of => :author, :dependent => :destroy
end