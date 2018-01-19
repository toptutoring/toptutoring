module MenuLinksHelper
  def link_to_client_students_or_tutors
    if current_user.student_account
      menu_link(clients_tutors_path, "Your Tutors", "icon ion-ios-contact bg-purple")
    elsif current_user.client_account
      menu_link(clients_students_path, "Your Students", "icon ion-ios-contact bg-purple")
    end
  end

  def menu_link(path, title, icon_style, badge = nil)
    tag.li class: "panel" do
      link_to path, class: active?(path) do
        concat tag.i(class: icon_style)
        concat tag.span(title, class: "sidebar-title")
        concat tag.span(badge, class: "badge bg-danger") if badge && badge > 0
      end
    end
  end

  def active?(path)
    request.path == path ? "active" : nil
  end
end
