module ApplicationHelper
  def active_nav_item(tgt_controller)
    (tgt_controller == controller_name ? "active" : "") 
  end
  
  def formatted_owner(user)
    text = if user.first_name.blank? && user.last_name.blank?
      user.username
    else
      [user.first_name, user.last_name].join(' ')
    end
    
    text += " (#{user.organization_name})"
    text
  end
end
