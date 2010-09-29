class User < ActiveRecord::Base
  acts_as_authentic
  validates_numericality_of :budget, :greater_than => 0, :less_than => 1000000000, :allow_nil => true
  
  has_many :deals
end
