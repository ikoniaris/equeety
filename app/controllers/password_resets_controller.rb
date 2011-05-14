class PasswordResetsController < ApplicationController
  
  before_filter :require_no_user
  before_filter :load_user_with_given_perishable_token
  
  def new
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      @user.reset_perishable_token!
      
      flash[:notice] = "Your password has been reset."
      redirect_to dashboard_path
    else
      render :action => :edit
    end
  end
  
  private
  
  def load_user_with_given_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user 
      flash[:notice] = "The password reset link has expired. Please renew your request."
      redirect_to root_path
    end
  end
  
end
