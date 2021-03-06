class Headstart::SessionsController < ApplicationController
  unloadable

  skip_before_filter :authenticate, :only => [:new, :create, :destroy]
  protect_from_forgery :except => :create
  filter_parameter_logging :password
  before_filter :set_oauth_url, :only => [:new, :create]

  def new
    render :template => 'sessions/new'
  end

  def create
    @user = if params[:session]
      ::User.authenticate(params[:session][:email], params[:session][:password])
    else
      ::User.find_facebook_user(params['code'], get_full_app_path)
    end
      
    if @user.nil?
      flash_failure_after_create
      render :template => Headstart.configuration.session_failure_template, :status => :unauthorized
    else
      if @user.email_confirmed?
        flash_success_after_create
      elsif @user.email_confirmation_sent_at.blank?
        ::HeadstartMailer.deliver_welcome(@user)
        @user.update_attribute(:email_confirmation_sent_at, Time.now)
        flash_notice_after_create
      end
      sign_in(@user)
      reset_session
      redirect_back_or(url_after_create)
    end
  end

  def destroy
    if Headstart.configuration.use_facebook_connect
      cookies[Headstart.configuration.facebook_api_key + "_user"] = nil
      cookies[Headstart.configuration.facebook_api_key + "_session_key"] = nil
    end
    sign_out
    flash_success_after_destroy
    redirect_to(url_after_destroy)
  end

  private

  def flash_failure_after_create
    flash.now[:failure] = translate(:bad_email_or_password,
      :scope   => [:headstart, :controllers, :sessions],
      :default => "Bad email or password.")
  end

  def flash_success_after_create
    flash[:success] = translate(:signed_in, :default =>  "Signed in.")
  end

  def flash_notice_after_create
    flash[:notice] = translate(:unconfirmed_email,
      :scope   => [:headstart, :controllers, :sessions],
      :default => "User has not confirmed email. " <<
                  "Confirmation email will be resent.")
  end

  def url_after_create
    Headstart.configuration.url_after_create
  end

  def flash_success_after_destroy
    flash[:success] = translate(:signed_out, :default =>  "Signed out.")
  end

  def url_after_destroy
    sign_in_url
  end
end
