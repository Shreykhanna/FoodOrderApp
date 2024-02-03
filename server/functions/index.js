require('dotenv').config()
const stripe = require('stripe')(process.env.STRIPE_SECRET_TEST_KEY)

module.exports.handler = async (event) => {
  if(type==='pay'){
    var { paymentMethodId, items, currency, useStripeSdk, orderAmount,type } =
      event
    orderAmount = 100
    try {
      if (paymentMethodId) {
        const params = {
          amount: orderAmount,
          confirm: true,
          confirmation_method: 'manual',
          currency: currency,
          payment_method: paymentMethodId,
          use_stripe_id: useStripeSdk,
        }
        const intent = await stripe.paymentIntents.create(params)
        console.log(`Intent:${intent}`)
        return res.send(generateResponse(intent))
      }
      return res.sendStatus(400)
    } catch (e) {
      return res.send({ error: e.message })
  }
}else if(type==='confirm'){
  const { paymentIntentId } = req.body
    try {
      if (paymentIntentId) {
        const intent = await stripe.paymentIntents.confirm(paymentIntentId)
        return res.send(generateResponse(intent))
      }
      return res.sendStatus(400)
    } catch (e) {
      return res.send({ error: e.message })
    }
}
};

const generateResponse = function (intent) {
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
