jQuery ->
  if (proxy = $('#csrf_proxy'))
    csrfParam = proxy.data('csrf-param')
    csrfToken = proxy.data('csrf-token')
    if (csrfParam? && csrfToken?)
      metaToken = '<meta name="csrf-token" content="' + csrfToken + '">'
      metaParam = '<meta name="csrf-param" content="' + csrfParam + '">'
      $('head').append(metaParam).append(metaToken)
  
  $('form').on 'submit', handleSubmit

handleSubmit = (e) ->
  valid = true
  if (fields = $('form *[data-required]'))
    $.each fields, (i, f) =>
      if $(f).val() == ''
        valid = false
  if (!valid)
    alert("Please fill in all fields before submitting.")
    false
  else
    true