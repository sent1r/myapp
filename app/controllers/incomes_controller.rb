class IncomesController < ApplicationController
  before_action :set_income, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    if params[:in_out] == "1"
      @incomes = Income.joins(:category).where("categories.is_income = 1 AND incomes.user_id="+current_user.id.to_s)
      @anc = "(Доходы)"
      @@mycat = Category.where("categories.is_income = 1")
    elsif params[:in_out] == "2"
      @incomes = Income.joins(:category).where("categories.is_income = 2 AND incomes.user_id="+current_user.id.to_s)
      @anc = "(Расходы)"
      @@mycat = Category.where("categories.is_income = 2")
    else
      @incomes = Income.all
      @anc = "(Все)"
      @@mycat = nil
    end
    respond_with(@incomes)
  end

  def show
    respond_with(@income)
  end

  def new
    @income = Income.new
    if @@mycat.nil?
      @cat = Category.all
    else
      @cat = @@mycat
    end
    respond_with(@income)
  end

  def edit
  end

  def create
    @income = Income.new(income_params)
    @income.user_id = current_user.id if current_user
    @income.save
    respond_with(@income)
  end

  def update
    @income.update(income_params)
    respond_with(@income)
  end

  def destroy
    @income.destroy
    respond_with(@income)
  end

  private
    def set_income
      @income = Income.find(params[:id])
    end

    def income_params
      params.require(:income).permit(:user_id, :category_id, :name, :cost)
    end
end
