self.addEventListener('push', (event) => {
  if (
    self.Notification == null ||
    self.Notification.permission !== 'granted'
  ) {
    return;
  }

  const title = 'サンプル通知';
  const options = {
    body: event.data.text(),
  };

  event.waitUntil(
    self.registration.showNotification(title, options),
  );
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  event.waitUntil(
    self.clients.openWindow('/'),
  );
});
