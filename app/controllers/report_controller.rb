class ReportController < ApplicationController
  before_filter :authenticate_user!
  @@reports = nil

  #setting a period of report
  def index
    @report = ''
    if @@reports.nil?
      @date_from = '2014-12-22 00:00:00'
      @date_to = Date.today.to_s+' 23:59:59'
    else
      @date_from = @@reports[:date_from].to_s+' 00:00:00'
      @date_to = @@reports[:date_to].to_s+' 23:59:59'
    end

    #Unset the variable to clean memory
    @@reports = nil

    #Only Incomes or only expences
    @in_incomes = Income.joins(:category).where("categories.is_income = 1 AND incomes.created_at > ? AND
    incomes.created_at < ? AND incomes.user_id=?", @date_from, @date_to, current_user.id)
    @out_incomes = Income.joins(:category).where("categories.is_income = 2 AND incomes.created_at > ? AND
    incomes.created_at < ? AND incomes.user_id=?", @date_from, @date_to, current_user.id)

    #Summing all amounts of incomes or expences
    @out_sum = 0
      @out_incomes.each do |income|
        @out_sum += income.cost
      end
    @in_sum = 0
      @in_incomes.each do |income|
        @in_sum += income.cost
      end
  end

  #@@reports used to send params in to index controller
  def create
    @@reports = params
    redirect_to :controller=>'report', :action => 'index'
  end
end