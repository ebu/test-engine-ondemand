# Define global namespace if not already done
window.ebu ?= {}

# Called whenever a new variant job should be rendered
window.ebu.add_fields = (link, association, content) ->
  new_id = new Date().getTime()
  $('#variant_jobs_list .list-group').append(content.replace(/new_variant_job/g, new_id))
  $('#variant_jobs_list .panel-body').hide()

# Dismiss the parent elm of a dismiss button
window.ebu.dismiss = (elm) ->
  $(elm).parent().remove()
  if $('#variant_jobs_list ul').children().length == 0
    $('#variant_jobs_list .panel-body').show()