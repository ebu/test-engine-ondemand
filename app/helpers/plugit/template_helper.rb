module Plugit::TemplateHelper
  def plugit_link_to_mpd(job)
    link_to('Raw MPD', plugit_stream_url_for(job), class: 'btn btn-default btn-sm')
  end
  
  def plugit_link_to_play(job)
    link_to('Open in Dash.js player', "{{ebuio_baseUrl}}play/#{job.id}", class: 'btn btn-primary btn-sm')
  end
  
  def plugit_stream_url_for(job)
    "/media/" + ['dash', job.randomized_id, 'dash.mpd'].join('/')
  end
  
end
