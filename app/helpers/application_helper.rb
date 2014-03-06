module ApplicationHelper
  def active_nav_item(tgt_controller)
    (tgt_controller == controller_name ? "active" : "") 
  end
  
  def plugit_link_to(name = nil, options = nil, html_options = nil, &block)
    link_to(name, options, html_options, &block).gsub(
      %r[href="/#{Rails.application.config.ebu_plugit_local_root}],
      %Q[href="/#{Rails.application.config.ebu_plugit_root}]
    ).html_safe
  end
end
