# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
presets = {
  encoder_preset: {
    video: '-f mp4 -vcodec libx264 -profile:v baseline -level:v 3.1 -s @Video size in pixels (e.g. 320x180)@ -b:v @Target bitrate@k -an -maxrate @Max. bitrate@k -minrate @Min. bitrate@k -keyint_min @Min. GOP length in frames@ -g @Max. GOP length in frames@ -threads 4',
    audio: '-f mp4 -vn -acodec libfaac -ar @Audio samplerate@ -ab @Target bitrate@k -ac @Number of audio channels@ -metadata:s:0 language=@Language of audio track@'
  },
  post_processing_preset: {
    generic: '-dash @Segment duration in ms.@ -profile onDemand -rap -frag-rap -url-template -segment-name %s_ -segment-ext mp4'
  }
}

jQuery ->
  if ($('#plugit_wrapper').data('controller') == 'preset_templates' && ($('#plugit_wrapper').data('action') == 'new' || $('#plugit_wrapper').data('action') == 'create'))
    $('#preset_template_preset_type').on 'change', changeHandler
    $('#preset_template_preset_type').change()

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
