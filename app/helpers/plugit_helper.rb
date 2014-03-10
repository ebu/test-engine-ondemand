# Specific helper functions to generate valid PlugIt links and URLs.
#
# Most of these functions revolve around getting a valid URL to a resource
# and then modifying it to obtain a URL that the PlugIt framework deems valid.
module PlugitHelper
  def url_for_plugit(orig)
    orig.gsub(
      %r[/#{Rails.application.config.ebu_plugit_local_root}],
      %Q[/#{Rails.application.config.ebu_plugit_root}]
    )
  end
  
  def plugit_link_to_mpd(job)
    plugit_link_to('Raw MPD', plugit_stream_url_for(job), class: 'btn btn-default btn-sm')
  end
  
  def plugit_link_to_play(job)
    plugit_link_to('Open in Dash.js player', url_for_plugit(play_encoding_job_path(job)), class: 'btn btn-primary btn-sm')
  end
  
  def plugit_stream_url_for(job)
    "media/" + ['dash', job.randomized_id, 'dash.mpd'].join('/')
  end

  def plugit_raw_mpd_link(job)
    url = mpd_url(job)
    "Raw public MPD link: ".html_safe + plugit_link_to(url, url)
  end  

  def plugit_link_to(name = nil, options = nil, html_options = nil, &block)
    link_to(name, options, html_options, &block).gsub(
      %r[href="/#{Rails.application.config.ebu_plugit_local_root}],
      %Q[href="/#{Rails.application.config.ebu_plugit_root}]
    ).html_safe
  end
  
  def mpd_url(job)
    url_for_plugit("#{root_path}/#{plugit_stream_url_for(job)}")
  end
  
  # Authorisation methods
  def auth_is_admin?
    controller.is_admin?
  end
end