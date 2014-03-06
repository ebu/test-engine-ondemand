# Specific helper functions to generate valid PlugIt links and URLs.
#
# Most of these functions revolve around getting a valid URL to a resource
# and then modifying it to obtain a URL that the PlugIt framework deems valid.
module PlugitHelper
  def plugit_link_to_mpd(job)
    link_to('Raw MPD', plugit_stream_url_for(job), class: 'btn btn-default btn-sm')
  end
  
  def plugit_link_to_play(job)
    link_to('Open in Dash.js player', "{{ebuio_baseUrl}}play/#{job.id}", class: 'btn btn-primary btn-sm')
  end
  
  def plugit_stream_url_for(job)
    "/media/" + ['dash', job.randomized_id, 'dash.mpd'].join('/')
  end

  def plugit_link_to(name = nil, options = nil, html_options = nil, &block)
    link_to(name, options, html_options, &block).gsub(
      %r[href="/#{Rails.application.config.ebu_plugit_local_root}],
      %Q[href="/#{Rails.application.config.ebu_plugit_root}]
    ).html_safe
  end
end