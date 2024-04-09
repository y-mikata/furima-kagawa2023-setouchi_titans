let payjpInstance = null;

export function getPayjpInstance() {
  if (!payjpInstance) {
    payjpInstance = Payjp(gon.public_key);
  }
  return payjpInstance;
}
