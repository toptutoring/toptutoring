module Admin
  class MasqueradesController < ApplicationController
    before_action :must_be_admin_or_director, only: [:create]

    def create
      session[:admin_id] = current_user.id
      user = User.find(params[:user_id])
      sign_in user
      redirect_to root_path, notice: "Now masquerading as #{user.email}"
    end

    def destroy
      sign_in User.find(session[:admin_id])
      session.delete(:admin_id)
      redirect_to root_path, notice: "Stopped masquerading"
    end
  end

  private
  def must_be_admin_or_director
    unless current_user.has_role?("admin") or current_user.has_role?("director")
      flash[:error] = "Must be admin or director to masquerade"
      redirect_to root_url
    end
  end
end