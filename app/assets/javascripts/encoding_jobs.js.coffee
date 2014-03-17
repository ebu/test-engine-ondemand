# Define global namespace if not already done
window.ebu ?= {}

# Called whenever a new variant job should be rendered
window.ebu.add_fields = (link, association, content) ->
  new_id = new Date().getTime()
  $('#variant_jobs_list .list-group').append(content.replace(/new_variant_job/g, new_id))
  attach_handlers($('[data-id=' + new_id + ']'))
  $('#variant_jobs_list .panel-body').hide()

window.ebu.format_preset = (preset) ->
  preset.replace(/\@(.*?)\@/g, '<span class="label label-info" data-variable="$1">$1</span>')
  
window.ebu.fill_preset = (preset, substitutions) ->
  $.each substitutions, (key, value) ->
    preset = preset.replace("@" + key + "@", value)
  preset
  
# Add interaction handlers to newly inserted variant job
attach_handlers = (elm) ->
  # Dismiss handler
  elm.find('button').on 'click', (event) ->
    $(this).parent().remove()
    if $('#variant_jobs_list ul').children().length == 0
      $('#variant_jobs_list .panel-body').show()

  # Select box change
  select_box = elm.find('select[name*="encoder_preset"]')
  select_box.on 'change', update_presets
  select_box.change()

# Event handler to update presets and show relevant fields
update_presets = (event) ->
  selected = $(this).find(':selected')
  preview = $(this).parent().find('.encoder_preset_preview')
  variables_container = $(this).parent().find('.encoder_preset_variables')
  preview.html(ebu.format_preset(selected.attr('data-preset')))
  variables = $.map preview.find('[data-variable]'), (item) -> $(item).attr('data-variable')
  variables_container.html('')
  variables.forEach (v) ->
    template = '<div class="input-group input-group-sm"><span class="input-group-addon">' + v + '</span>' +
               '<input type="text" class="form-control" data-variable="' + v + '" data-required="true"/></div>'
    variables_container.append(template)

post_processing_change_handler = (event) ->
  selected = $(this).find(':selected')
  preview = $(this).parent().find('.post_processing_preset_preview')
  variables_container = $(this).parent().find('.post_processing_preset_variables')
  preview.html(ebu.format_preset(selected.attr('data-preset')))
  variables = $.map preview.find('[data-variable]'), (item) -> $(item).attr('data-variable')
  variables_container.html('')
  variables.forEach (v) ->
    template = '<div class="input-group input-group-sm"><span class="input-group-addon">' + v + '</span>' +
               '<input type="text" class="form-control" data-variable="' + v + '" data-required="true"/></div>'
    variables_container.append(template)
  
# Submit handler
submit_handler = (event) ->
  # Don't allow submit if there are no variant jobs
  if ($('#variant_jobs_list ul li').length == 0)
    alert('Please specify at least one variant job before submitting an encoding job.')
    return false
    
  # Flatten all variant jobs variable fields into hidden form field
  $.each $('#variant_jobs_list li[data-id]'), (index, item) =>
    flatten_input_fields(
      $(item).find('.encoder_preset_variables input[data-variable]'),
      $(item).find('select[name*="encoder_preset"] :selected').attr('data-preset'),
      $(item).find('input[name*="encoder_flags"]')
    )
  # Flatten post processing variable fields into hidden form field
  flatten_input_fields(
    $('.post_processing_preset_variables input[data-variable]'),
    $('select[name*="post_processing_template"] :selected').attr('data-preset'),
    $('input[name*="post_processing_flags"]')
  )
  

flatten_input_fields = (source_fields, preset_template, target_field) ->
  vars = {}
  $.each source_fields, (i, variable) =>
    key = $(variable).attr('data-variable')
    value = $(variable).val()
    vars[key] = value
  preset = ebu.fill_preset(preset_template, vars)
  target_field.val(preset)
  
# Setup handlers when page loads
jQuery ->
  if ($('#plugit_wrapper').data('controller') == 'encoding_jobs' && ['new', 'create'].indexOf($('#plugit_wrapper').data('action')) != -1)
    # Setup form processors
    $('#new_encoding_job').on 'submit', submit_handler # Handle form submit
    select_box = $('#encoding_job_post_processing_template_id')
    select_box.on 'change', post_processing_change_handler
    select_box.change()
  else if ($('#plugit_wrapper').data('controller') == 'encoding_jobs' && $('#plugit_wrapper').data('action') == 'show')
    # Setup auto job status refresh
    setup_job_refresh()
    

# Job refresh handler
setup_job_refresh = () ->
  status = $('div[data-status]').data('status')
  if (["failed", "success"].indexOf(status) == -1)
    setTimeout refresh_status, 4000

refresh_status = () ->
  status_url = $('div[data-status]').data('status-url')
  xhr = new XMLHttpRequest()
  xhr.addEventListener("load", update_status, false);
  xhr.open("get", status_url)
  xhr.send()
  
update_status = (evt) ->
  data = evt.target.response
  $("#encoding_job_wrapper").empty().html(data)
  setup_job_refresh()
