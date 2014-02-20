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
               '<input type="text" class="form-control" data-variable="' + v + '"/></div>'
    variables_container.append(template)

# Add submit hook to form
jQuery ->
  if ($('body').attr('data-controller') == 'encoding_jobs' && ['new', 'create'].indexOf($('body').attr('data-action')) != -1)
    $('#new_encoding_job').on 'submit', submit_handler

# Submit handler
submit_handler = (event) ->
  # Flatten all variable fields into hidden form field
  $.each $('#variant_jobs_list li[data-id]'), (index, item) =>
    vars = {}
    $.each $(item).find('.encoder_preset_variables input[data-variable]'), (i, variable) =>
      key = $(variable).attr('data-variable')
      value = $(variable).val()
      vars[key] = value
    preset = $(item).find('select[name*="encoder_preset"] :selected').attr('data-preset')
    preset = ebu.fill_preset(preset, vars)
    $(item).find('input[name*="encoder_flags"]').val(preset)