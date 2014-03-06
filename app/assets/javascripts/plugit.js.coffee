jQuery ->
  if (proxy = $('#csrf_proxy'))
    csrfParam = proxy.data('csrf-param')
    csrfToken = proxy.data('csrf-token')
    if (csrfParam? && csrfToken?)
      metaToken = '<meta name="csrf-token" content="' + csrfToken + '">'
      metaParam = '<meta name="csrf-param" content="' + csrfParam + '">'
      $('head').append(metaParam).append(metaToken)