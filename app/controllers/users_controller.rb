class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to deals_url, :notice => 'You have signed up successfully.'
    else
      render :action => "new"
    end
  end
end
