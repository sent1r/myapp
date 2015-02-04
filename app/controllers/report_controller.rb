class ReportController < ApplicationController
  before_filter :authenticate_user!
  @@reports = nil

  #Установка граничных дат для отчета
  def index
    @report = ''
    if @@reports.nil?
      @date_from = '2014-12-22 00:0:00'
      @date_to = Date.today.to_s+' 24:00:00'
    else
      @date_from = @@reports[:date_from].to_s+'00:00:00'
      @date_to = @@reports[:date_to].to_s+' 24:00:00'
    end

    #Сбрасываю переменную, чтобы исключить запоминание ранее введенных данных
    @@reports = nil

    #Выбираю строки, относящиеся только к расходам/доходам
    @in_incomes = Income.joins(:category).where("categories.is_income = 1 AND incomes.created_at > ?
    AND incomes.created_at < ? AND incomes.user_id=?", @date_from, @date_to, current_user.id)
    @out_incomes = Income.joins(:category).where("categories.is_income = 2 AND incomes.created_at > ?
    AND incomes.created_at < ? AND incomes.user_id=?", @date_from, @date_to, current_user.id)

    #Произвожу расчет суммы всех расходов/доходов
    @out_sum = 0
      @out_incomes.each do |income|
        @out_sum += income.cost
      end
    @in_sum = 0
      @in_incomes.each do |income|
        @in_sum += income.cost
      end
  end

  #Использую глобальную переменную для передачи даныых из формы из одного метода в другой
  def create
    @@reports = params
    redirect_to :controller=>'report', :action => 'index'
  end
end