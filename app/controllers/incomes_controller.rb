class IncomesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_income, only: [:show, :edit, :update, :destroy]

  respond_to :html

  #Переменная @ncomes может содержать только строки, относящиеся к доодам, расходам, группе одноименных затрат
  #Переменная @anc используется для информирования пользователя на какой странице шаблона он находится (при отрисовке)
  #@@mycat описывается ниже, метод new
  def index
    if params[:in_out] == "1"
      @incomes = Income.joins(:category).where("categories.is_income = ?", 1).where(user_id: current_user.id)
      @anc = "(Доходы)"
      @@mycat = Category.where("categories.is_income = ?", 1).where(user_id: current_user.id)
    elsif params[:in_out] == "2"
      @incomes = Income.joins(:category).where("categories.is_income = ?", 2).where(user_id: current_user.id)
      @anc = "(Расходы)"
      @@mycat = Category.where("categories.is_income = ?", 2).where(user_id: current_user.id)
    elsif params[:i_name]
      @incomes = Income.where(name: params[:i_name], user_id: current_user.id)
    else
      @incomes = Income.where(user_id: current_user.id)
      @anc = "(Все)"
      @@mycat = nil
    end

    @cat_names = Category.select(:id, :name)

    respond_with(@incomes)
  end

  def show
    respond_with(@income)
  end

  #Переменная @@mycat призвана усовершенствовать вид вывода списка операций (В зависимости от id категории выводить ее имя)
  def new
    @income = Income.new
    if @@mycat
      @cat = @@mycat
    else
      @cat = Category.where(user_id: current_user.id)
    end
    respond_with(@income)
  end

  def edit
    @cat = Category.where(user_id: current_user.id)
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