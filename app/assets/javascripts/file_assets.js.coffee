# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  if ($('#wrapper').data('controller') == 'file_assets' && $('#wrapper').data('action') == 'index')
    $('#file_asset_resource').on 'change', changeHandler
    $('#submit').on 'click', submitHandler

changeHandler = (event) =>
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
  
submitHandler = (event) =>
  xhr = new XMLHttpRequest()
  form = document.getElementById('new_file_asset')
  fd = new FormData(form);

  xhr.upload.addEventListener("progress", uploadProgress, false);
  xhr.addEventListener("load", uploadComplete, false);
  # xhr.addEventListener("error", uploadFailed, false);
  # xhr.addEventListener("abort", uploadCanceled, false);

  document.getElementById('upload_progress').style.display = 'block';
  
  xhr.open(form.getAttribute('method'), form.getAttribute('action'));
  xhr.send(fd);
  
  submitButton = $('#submit')
  inputElm = $('#file_asset_resource')
  inputBtn = $('.fileinput-button')
  
  submitButton.attr("disabled", "disabled")
  inputElm.attr("disabled", "disabled")
  inputBtn.attr("disabled", "disabled")

uploadComplete = (event) =>
  document.getElementById('upload_progress').style.display = 'none';
  document.getElementById('upload_progress').children[0].style.width = "0%"
  window.location.href = window.location.href;
  
uploadProgress = (event) =>
  pct = event.loaded * 100 / event.total
  document.getElementById('upload_progress').children[0].style.width = pct + "%"
  
getReadableFileSize = (size) ->
  i = 0
  byteUnits = [' B', ' kB', ' MB', ' GB', ' TB', 'PB', 'EB', 'ZB', 'YB']
  while size > 1024
    size = size / 1024
    i++

  if i == 0
    size + byteUnits[i];
  else    
    Math.max(size, 0.1).toFixed(1) + byteUnits[i];
