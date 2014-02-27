# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
presets = {
  encoder_preset: {
    video: '-t @Maximum length to transcode@ -f mp4 -vcodec libx264 -profile:v main -level:v 3.1 -s @Video size in pixels (e.g. 320x180)@ -aspect 16:9 -b:v @Target bitrate@k -an -maxrate @Max. bitrate@k -minrate @Min. bitrate@k -bufsize 9216k -keyint_min @Min. GOP length in frames@ -g @Max. GOP length in frames@ -flags +cgop -sc_threshold 0 -pix_fmt yuv420p -threads 4',
    audio: '-t @Maximum length to transcode@ -f mp4 -vn -acodec mp2 -ar @Audio samplerate@ -ab @Target bitrate@k -ac @Number of audio channels@'
  },
  post_processing_preset: {
    generic: '-dash @Segment duration in ms.@ -profile onDemand -rap -frag-rap -url-template -segment-name %s_ -segment-ext mp4'
  }
}

jQuery ->
  if ($('body').attr('data-controller') == 'preset_templates' && ($('body').attr('data-action') == 'new' || $('body').attr('data-action') == 'create'))
    $('#preset_template_preset_type').on 'change', changeHandler
    $('#preset_template_preset_type').change()
  else if ($('body').attr('data-controller') == 'preset_templates' && $('body').attr('data-action') == 'index')
    addTabHandler()

addTabHandler = () ->
  $('#preset_tabs a').click (e) ->
    e.preventDefault()
    $(this).tab('show')
  
changeHandler = (event) =>
  updatePrefillButtons(event.currentTarget.value)

updatePrefillButtons = (preset) =>
  available_presets = presets[preset]
  prefill_buttons = $('#prefill_buttons')
  prefill_buttons.html('')
  
  $.each available_presets, (index, value) =>
    button = document.createElement('button')
    button.className = 'btn btn-info btn-xs'
    button.setAttribute('data-value', value)
    button.setAttribute('type', 'button')
    button.innerText = index
    prefill_buttons[0].appendChild(button)
    $(button).on 'click', ->
      $('#preset_template_template_text').val(event.currentTarget.getAttribute('data-value'))
      false
