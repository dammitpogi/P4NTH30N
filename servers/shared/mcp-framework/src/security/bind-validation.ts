const ALLOWED_BIND_ADDRESSES = new Set(['127.0.0.1', 'localhost']);

export function validateBindAddress(host: string): boolean {
  return ALLOWED_BIND_ADDRESSES.has(host.trim().toLowerCase());
}

export function assertSecureBindAddress(host: string): void {
  if (!validateBindAddress(host)) {
    throw new Error(
      `Invalid bind address '${host}'. Only 127.0.0.1/localhost is allowed.`,
    );
  }
}
