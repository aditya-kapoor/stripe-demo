$ ->
  Stripe.setPublishableKey($('meta[name="stripe-public-key"]').attr('content'))
  subscription.setupForm()

subscription =
  setupForm: ->
    $('#new_payment').submit ->
      $('input[type=submit]').attr('disabled', true)
      if $('#card_number').length
        subscription.processCard()
        false
      else
        true
  processCard: ->
    card =
      number:   $('#card_number').val()
      cvc:      $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear:  $('#card_year').val()
    Stripe.createToken(card, subscription.handleStripeResponse)
  handleStripeResponse: (status, response) ->
    if status == 200
      $('#payment_stripe_card_token').val(response.id)
      $('#new_payment')[0].submit()
    else
      $('#stripe_error').text(response.error.message)
      $('input[type=submit]').attr('disabled', false)
