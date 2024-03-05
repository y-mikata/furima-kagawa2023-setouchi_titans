module ApplicationHelper
  def flash_class(type)
    case type
    when 'notice' then 'alert alert-info'
    when 'alert', 'error' then 'alert alert-danger'
    else 'alert alert-primary'
    end
  end
end
