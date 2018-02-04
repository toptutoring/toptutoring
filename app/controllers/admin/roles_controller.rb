module Admin
  class RolesController < ApplicationController
    before_action :require_login

    def index
      @tutors = User.tutors
      @unassigned = User.left_joins(:roles).where(user_roles: { user_id: nil })
      @assignable_roles = assignable_roles
    end

    def create
      user_role = create_role
      user_name = user_role.user.name
      role_name = user_role.role.name
      flash.notice = "#{user_name} has been assigned the role of #{role_name}. Please set rates."
      redirect_to admin_roles_path
    rescue ActiveRecord::RecordInvalid => e
      flash.alert = e.message
      redirect_to admin_roles_path
    end

    def destroy
      user_role = UserRole.find(params[:id])
      if user_role.destroy
        flash.notice = destroy_success_string(user_role.user, user_role.role)
      else
        flash.alert = user_role.errors.full_messages
      end
      redirect_to admin_roles_path
    end

    private

    def user_role_params
      params.require(:user_role).permit(:role_id, :user_id)
    end

    def assignable_roles
      Role.where(name: %w[director tutor contractor])
    end

    def create_role
      user_role = UserRole.new(user_role_params)
      ActiveRecord::Base.transaction do
        user_role.save!
        create_accounts(user_role.user, user_role.role)
      end
      user_role
    end

    def create_accounts(user, role)
      if role.name == "contractor"
        user.create_contractor_account!(hourly_rate: 15)
      elsif role.name == "tutor"
        user.create_tutor_account!
      end
    end

    def destroy_success_string(user, role)
      "#{user.name} has been removed as a #{role.name}."
    end
  end
end
