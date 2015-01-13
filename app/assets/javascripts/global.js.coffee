jQuery ->
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