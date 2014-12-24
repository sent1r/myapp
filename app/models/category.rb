class Category < ActiveRecord::Base
	validates_presence_of :is_income, :name
	belongs_to :user
	has_many :incomes, dependent: :destroy

end
