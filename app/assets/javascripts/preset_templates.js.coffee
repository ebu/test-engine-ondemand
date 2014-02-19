# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
presets = {
  encoder_preset: {
    video: '-t @maxlen@ -f mp4 -vcodec libx264 -profile:v main -level:v 3.1 -s @size@ -aspect 16:9 -b:v @bitr@k -an -maxrate @maxb@k -minrate @minb@k -bufsize 9216k -keyint_min @keyint@ -g 120 -flags +cgop -sc_threshold 0 -pix_fmt yuv420p -threads 4',
    audio: '-t @maxlen@ -f mp4 -vn -acodec faac -ar @samplerate@ -ab @bitr@k -ac @channels@'
  },
  post_processing_preset: {
    generic: '-dash @seg_dur@ -profile onDemand -rap -frag-rap -url-template -segment-name %s_ -segment-ext mp4'
  }
}

jQuery ->
  if ($('body').attr('data-controller') == 'preset_templates' && ($('body').attr('data-action') == 'new' || $('body').attr('data-action') == 'create'))
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
