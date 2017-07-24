module Admin
  class RolesController < ApplicationController
    before_action :require_login,

    def index
      @tutors = User.tutors
      @assignable_roles = assignable_roles
      @new_role = UserRole.new
    end

    def create
      @new_role = UserRole.new(role_params)
      if @new_role.save
        user_name = User.find(params[:user_id]).name
        role_name = Role.find(params[:role_id]).name
        redirect_to(admin_roles_path,
          notice: "#{user_name} has been assigned the role of #{role_name}") and return
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @new_role.errors.full_messages }) and return
      end
    end

    def destroy
      user_role = UserRole.find(params[:id])
      user = User.find(user_role.user_id)
      role = Role.find(user_role.role_id)
      if user_role.destroy
        redirect_to admin_roles_path, flash: { notice: "#{user.name} was removed as #{role.name.capitalize}" }
      else
        redirect_to :back, flash: { error: "There was an error processing your request." }
      end
    end

    private

    def role_params
      params.except(:authenticity_token, :_method).permit(:role_id, :user_id)
    end

    def assignable_roles
      Role.where(name: %w[director tutor contractor])
    end
  end
end
