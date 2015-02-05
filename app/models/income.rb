class Income < ActiveRecord::Base
  validates_presence_of :name, :cost
  belongs_to :category
end