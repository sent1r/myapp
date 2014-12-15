class Category < ActiveRecord::Base
	validates_presence_of :is_income
	belongs_to :user
	has_many :incomes

end
