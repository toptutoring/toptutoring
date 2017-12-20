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
      flash.notice = "#{user_name} has been assigned the role of #{role_name}."
      redirect_to admin_roles_path
    rescue ActiveRecord::RecordInvalid => e
      flash.alert = e.message
      redirect_to admin_roles_path
    end

    def destroy
      user_role = UserRole.find(params[:id])
      destroy_role(user_role)
      user_name = user_role.user.name
      role_name = user_role.role.name
      flash.notice = "#{user_name} has been removed as a #{role_name}."
      redirect_to admin_roles_path
    rescue ActiveRecord::ActiveRecordError => e
      flash.alert = e.message
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
        user.create_contractor_account!.create_contract!
      elsif role.name == "tutor"
        user.create_tutor_account!.create_contract!
      end
    end

    def destroy_role(user_role)
      ActiveRecord::Base.transaction do
        if user_role.role.name == "contractor"
          user_role.user.contractor_account.destroy!
        elsif user_role.role.name == "tutor"
          user_role.user.tutor_account.destroy!
        end
        user_role.destroy!
      end
    end
  end
end
