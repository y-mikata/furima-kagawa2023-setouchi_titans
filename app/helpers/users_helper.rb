module UsersHelper
  def sidebar_link(name, path)
    class_name = 'section'
    class_name << ' active' if current_page?(path)

    content_tag :li, class: class_name do
      link_to name, path, class: 'section_name'
    end
  end
end
