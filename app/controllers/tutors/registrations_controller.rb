class Tutors::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  def create
    @minimum_password_length = User.password_length.min
    @resource = User.new
    super
    #super do
     # if !resource.valid?
      #  render 'tutors/new'
       # abort
      #end
    #end
  end

  def new
    @minimum_password_length = User.password_length.min
    @resource = User.new
    #build_resource
    #resource.build_tutor
    super do
      resource.build_tutor
    end
    #render 'tutors/new'
  end

  def show
    @user = User.find(params[:id])
  end

  def resource_name
    :user
  end

  def resource_class
    User
  end

  #def resource
   # @resource ||= User.new
  #end
   #def new
  #   resource = User.new
  #   resource.build_tutor
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

   protected

   def sign_up_params
     params.require(:user).permit(:name, :email, :phone_number, :password, :password_confirmation, tutor_attributes: [:subject, :activity_type])
   end

   def after_sign_up_path_for(resource)
    tutor_path(resource)
   end

    def after_sign_in_path_for(resource)
      tutor_path(resource)
    end

  # If you have extra params to permit, append them to the sanitizer.
   #def configure_sign_up_params
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
   #end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
