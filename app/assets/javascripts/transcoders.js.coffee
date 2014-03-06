# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  if ($('#plugit_wrapper').data('controller') == 'transcoders' && $('#plugit_wrapper').data('action') == 'index')
    refreshTranscoderStatus()

refreshTranscoderStatus = () =>
  list = $('td[data-availability-url]')
  for transcoder in list
    pingTranscoder(transcoder)
    
pingTranscoder = (transcoder) =>
  url = $(transcoder).attr('data-availability-url')
  $(transcoder).html('loading...')
  $.ajax url,
    type: 'GET',
    success: (data, textStatus, jqXHR) =>
      $(transcoder).html(data)
    error: (data, textStatus, jqXHR) =>
      $(transcoder).html("<span class='label label-default'>Unknown</span>")