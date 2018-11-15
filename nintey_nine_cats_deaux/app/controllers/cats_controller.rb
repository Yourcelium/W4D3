class CatsController < ApplicationController
  before_action :require_login
  
  
  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create

    new_params = cat_params
    new_params[:user_id] = @current_user.id
    
    @cat = Cat.new(new_params)
    
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
  
    @cat = Cat.find(params[:id])
    
    if is_owner?
      render :edit
    else
      render :you_blew_it
    end
  end

  def update
    @cat = Cat.find(params[:id])
    unless is_owner? 
      render :you_blew_it
      return
    end
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)        
      
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :description, :name, :sex)
  end
  
  def is_owner?
    current_user == @cat.owner
  end
end
