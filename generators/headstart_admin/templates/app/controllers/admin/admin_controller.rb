class Admin::AdminController < ApplicationController
  
  before_filter :authenticate
  before_filter :check_role
  
  def index
    
  end
  
  private
  
  
  def check_role
    redirect_to root_url unless current_user.admin?
  end

end
