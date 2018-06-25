module AdminUserHelper
  def admin_user_actions(user, user_view)
    if user.archived? 
      admin_reactivate_user_link(user, user_view)
    else 
      admin_edit_user_link(user)
      admin_archive_user_link(user, user_view)
      admin_remove_user_link(user) if current_user.admin?
      admin_masquerade_link(user)
    end
  end

  def admin_reactivate_user_link(user, user_view)
    render_confirm_link("Reactivate",
                       reactivate_admin_user_path(user, view: user_view),
                       "reactivate_user_link_#{user.id}",
                       classes: "btn",
                       link_method: :patch,
                       confirm_message: "Are you sure you want to reactivate this user?",
                       remote: true,
                       confirm_title: "Confirm reactivating #{user.full_name}")
  end

  def admin_edit_user_link(user)
    user_action = current_user.admin? ? edit_admin_user_path(user) : edit_director_client_path(user)
    action = user.has_role?("tutor") ? edit_admin_tutor_path(user) : user_action
    icon_link(action, "ion-edit", "Edit user info", "edit_user_link_#{user.id}", classes: "mr-15")
  end

  def admin_remove_user_link(user)
    render_icon_confirm_link("ion-trash-b", "Remove user permanently",
                             admin_user_path(user), "remove_user_link_#{user.id}",
                             classes: "mr-15",
                             link_method: :delete,
                             confirm_message: "Are you sure you want to remove this user?",
                             warning: "This will permanently remove the user from the database.",
                             remote: true,
                             confirm_title: "Confirm removing #{user.full_name}")
  end

  def admin_archive_user_link(user, user_view)
    render_icon_confirm_link("ion-android-archive", "Archive user from list",
                            archive_admin_user_path(user, view: user_view), "archive_user_link_#{user.id}",
                            classes: "mr-15",
                            link_method: :patch,
                            confirm_message: "Archiving the user will also archive all engagements. Are you sure you want to archive this user?",
                            remote: true,
                            confirm_title: "Confirm archiving #{user.full_name}")
  end

  def admin_masquerade_link(user)
    render_icon_confirm_link("ion-android-people", "Masquerade as this user",
                             user_masquerade_path(user), "masquerade_link_#{user.id}",
                            link_method: :post,
                            confirm_message: "Are you sure you want to masquerade as this user?",
                            confirm_title: "Masquerading as #{user.full_name}")
  end
end
