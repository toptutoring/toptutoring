module MenuLinksHelper
  def link_to_client_students_or_tutors
    if current_user.student_account
      menu_link(clients_tutors_path, "Your Tutors", "icon ion-ios-contact bg-purple")
    elsif current_user.client_account
      menu_link(clients_students_path, "Your Students", "icon ion-ios-contact bg-purple")
    end
  end

  def menu_link(path, title, icon_style)
    tag.li class: "panel" do
      link_to path, class: active?(path) do
        tag.i(class: icon_style) +
        tag.span(title, class: "sidebar-title")
      end
    end
  end

  def active?(path)
    request.path == path ? "active" : nil
  end
end
