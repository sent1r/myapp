class Income < ActiveRecord::Base
  validates_presence_of :name, :cost, :category_id
  belongs_to :category
end