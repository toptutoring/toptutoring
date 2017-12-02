module MenuLinksHelper
  def link_to_client_students_or_tutors
    if current_user.is_student?
      link_to clients_tutors_path do
        tag.i(class: "icon ion-ios-contact bg-purple") +
          content_tag(:span, "Your Tutors", class: "sidebar-title")
      end
    else
      link_to clients_students_path do
        tag.i(class: "icon ion-ios-contact bg-purple") +
          content_tag(:span, "Your Students", class: "sidebar-title")
      end
    end
  end
end
