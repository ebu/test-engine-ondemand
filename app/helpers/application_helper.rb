module ApplicationHelper
  def active_nav_item(tgt_controller)
    (tgt_controller == controller_name ? "active" : "") 
  end
end
