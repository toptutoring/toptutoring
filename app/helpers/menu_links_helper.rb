module MenuLinksHelper
  def link_to_client_students_or_tutors
    if current_user.student_account
      link_to clients_tutors_path do
        tag.i(class: "icon ion-ios-contact bg-purple") +
          content_tag(:span, "Your Tutors", class: "sidebar-title")
      end
    elsif current_user.client_account
      link_to clients_students_path do
        tag.i(class: "icon ion-ios-contact bg-purple") +
          content_tag(:span, "Your Students", class: "sidebar-title")
      end
    end
  end
end
