# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('#file_asset_resource').on 'change', (event) =>
    maxSize = parseInt(event.currentTarget.getAttribute('data-size-limit'), 10)
    submitButton = $('#submit')
    if event.currentTarget.files?
      file = event.currentTarget.files[0]
      info = $('#file_asset_info')
      info.html('<p>Name: ' + file.name + '<br/>' +
                'Size: ' + getReadableFileSize(file.size) + '<br/>' +
                'Type: ' + (file.type || '(unknown)') + '</p>')
      if file.size > maxSize
        alert = "<div class='alert alert-danger'>File is too big to upload. Please try a smaller file.</div>"
        info.append(alert)
        submitButton.attr("disabled", "disabled")
      else
        submitButton.removeAttr("disabled")

getReadableFileSize = (size) ->
  i = 0
  byteUnits = [' B', ' kB', ' MB', ' GB', ' TB', 'PB', 'EB', 'ZB', 'YB']
  while size > 1024
    size = size / 1024
    i++

  Math.max(size, 0.1).toFixed(1) + byteUnits[i];
