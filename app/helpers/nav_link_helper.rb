module NavLinkHelper
  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : ''

    if class_name != ''
      content_tag(:li, :class => class_name) do
      link_to link_text, link_path
      end
    else
      content_tag(:li) do
      link_to link_text, link_path
      end
    end
  end
end
