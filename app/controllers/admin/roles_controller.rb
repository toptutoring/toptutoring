module Admin
  class RolesController < ApplicationController
    before_action :require_login,

    def index
      @tutors = User.tutors
      @unassigned = User.left_joins(:roles).where(user_roles: { user_id: nil })
      @assignable_roles = assignable_roles
      @new_role = UserRole.new
    end

    def create
      @new_role = UserRole.new(role_params)
      if @new_role.save
        user = User.find(params[:user_id])
        role = Role.find(params[:role_id])
        create_account(user, role)
        flash.notice = "#{user.name} has been assigned the role of #{role.name}"
      else
        flash.alert = @new_role.errors.full_messages
      end
      redirect_to admin_roles_path
    end

    def destroy
      user_role = UserRole.find(params[:id])
      user = User.find(user_role.user_id)
      role = Role.find(user_role.role_id)
      destroy_account(user, role)
      if user_role.destroy
        flash.notice = "#{user.name} was removed as a #{role.name.capitalize}"
      else
        flash.alert = "There was an error processing your request." 
      end
      redirect_to admin_roles_path
    end

    private

    def role_params
      params.except(:authenticity_token, :_method).permit(:role_id, :user_id)
    end

    def assignable_roles
      Role.where(name: %w[director tutor contractor])
    end

    def create_account(user, role)
      if role.name == "contractor"
        user.create_contractor_account!.create_contract!
      elsif role.name == "tutor"
        user.create_tutor_account!.create_contract!
      end
    end

    def destroy_account(user, role)
      if role.name == "contractor"
        user.contractor_account.destroy!
      elsif role.name == "tutor"
        user.tutor_account.destroy!
      end
    end
  end
end
