class Admin::UsersController < Admin::AdminController
  MODEL = self.controller_name.singularize.downcase.to_sym
  
  def index
    @users = User.paginate :page => params[:page], :per_page => Settings.page_limit
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[MODEL])
    @user.role = params[MODEL][:role]
    if @user.save
      flash[:notice] = "Created #{@user.name}"
      redirect_to admin_user_url(@user)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    @user.role = params[MODEL][:role]
    if @user.update_attributes(params[MODEL])
      flash[:notice] = "Updated #{@user.name}"
      redirect_to admin_user_url(@user)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user != current_user
      @user.destroy
      flash[:notice] = "Deleted #{@user.name}"
    else
      flash[:error] = "Cannot delete yourself"
    end
    redirect_to admin_users_url
  end
    
end
