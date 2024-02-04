const stripe = require('stripe')(process.env.STRIPE_SECRET_TEST_KEY)

module.exports.handler = async (event) => {
  var { _card, currency, useStripeSdk, confirmOrderDetails, type,idempotencyKey } = event
  const calculateOrderAmount = (itemPrice) => {
    return itemPrice * 100
  }
  if (type === 'pay') {
    // const paymentMethod = await stripe.paymentMethods.create({
    //   type:'card',
    //   card:_card
    // })
    try {
      const params = {
        amount: calculateOrderAmount(confirmOrderDetails.itemPrice),
        currency: currency,
        // confirm: true,
        payment_method_types: ['card'],
        // automatic_payment_methods: {
        //   enabled: true,
        //   allow_redirects: 'never'
        // }

      }
      const intent = await stripe.paymentIntents.create(params,{idempotencyKey:idempotencyKey})
      console.log("intent", intent)
      // const confirmIntent = await stripe.paymentIntents.confirm(intent.id,{ payment_method: intent.payment_method_types})
      console.log("confirmIntent", confirmIntent)
      console.log(`Intent:${intent}`)
      return { "clientSecret": intent.client_secret }
    }
    catch (e) {
      // return res.send({ error: e.message })
    }
  }
  else if (type === 'confirm') {
    const { paymentIntentId } = req.body
    try {
      if (paymentIntentId) {
        const intent = await stripe.paymentIntents.confirm({ paymentIntentId })
        return generateResponse(intent)
      }
      // return res.sendStatus(400)
    }
    catch (e) {
      // return res.send({ error: e.message })
    }
  }
};

const generateResponse = function(intent) {
  switch (intent.status) {
    case 'requires_action':
      return {
        clientSecret: intent.clientSecret,
          requiresAction: true,
          status: intent.status,
      }
    case 'requires_payment_method':
      return {
        error: 'Your card was denied, please provide a new payment method',
      }
    case 'succeeded':
      return { clientSecret: intent.clientSecret, status: intent.status }
  }
  return { error: 'Failed' }
}
