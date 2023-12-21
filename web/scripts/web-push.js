async function checkIsWebPushSupported() {
  if (!('Notification' in window)) return false
  if (!('serviceWorker' in navigator)) return false
  try {
    const sw = await navigator.serviceWorker.ready
    return 'pushManager' in sw
  } catch (e) {
    return false
  }
}

async function checkIsSubscribedWebPush() {
  if (!(await checkIsWebPushSupported())) {
    return false
  }
  const swRegistration = await navigator.serviceWorker.ready
  const subscription = await swRegistration.pushManager.getSubscription()
  return subscription != null
}

async function subscribeWebPush(validPublicKey) {
  const RESPONSE_CODE = Object.freeze({
    SUCCEED: 'SUCCEED',
    NOT_SUPPORTED: 'NOT_SUPPORTED',
    DENIED: 'DENIED',
    CANCELED: 'CANCELED',
  })

  const generateResponse = (code, data = null) => {
    const response = {
      data,
      code,
    }
    return JSON.stringify(response)
  }

  if (!(await checkIsWebPushSupported())) {
    return generateResponse(RESPONSE_CODE.NOT_SUPPORTED)
  }

  if (window.Notification.permission === 'default') {
    const result = await window.Notification.requestPermission();
    if (result === 'default') {
      return generateResponse(RESPONSE_CODE.CANCELED)
    }
  }
  if (window.Notification.permission === 'denied') {
    return generateResponse(RESPONSE_CODE.DENIED)
  }

  const subscription = await navigator.serviceWorker.ready
    .then(worker => worker.pushManager
      .subscribe({
        userVisibleOnly: true,
        applicationServerKey: validPublicKey,
      })
    )
  const { endpoint, keys } = subscription.toJSON();

  if (endpoint == null || keys == null) {
    return generateResponse(RESPONSE_CODE.NOT_SUPPORTED)
  }

  const data = {
    endpoint,
    p256dh: keys.p256dh,
    auth: keys.auth,
  }
  return generateResponse(RESPONSE_CODE.SUCCEED, data)
}
