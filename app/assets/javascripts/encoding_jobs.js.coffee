# Define global namespace if not already done
window.ebu ?= {}

# Called whenever a new variant job should be rendered
window.ebu.add_fields = (link, association, content) ->
  new_id = new Date().getTime()
  $('#variant_jobs_list .list-group').append(content.replace(/new_variant_job/g, new_id))
  attach_handlers($('[data-id=' + new_id + ']'))
  $('#variant_jobs_list .panel-body').hide()

window.ebu.format_preset = (preset, substitutions) ->
  preset.replace(/\@(.*?)\@/g, '<span class="label label-info" data-variable="$1">@$1@</span>')
  
# Add interaction handlers to newly inserted variant job
attach_handlers = (elm) ->
  # Dismiss handler
  elm.find('button').on 'click', (event) ->
    $(this).parent().remove()
    if $('#variant_jobs_list ul').children().length == 0
      $('#variant_jobs_list .panel-body').show()

  # Select box change
  select_box = elm.find('select[name*="encoder_preset"]')
  select_box.on 'change', (event) ->
    selected = $(this).find(':selected')
    $(this).parent().find('.encoder_preset_preview').html(ebu.format_preset(selected.attr('data-preset')))
  select_box.change()
  # Show relevant preset fields