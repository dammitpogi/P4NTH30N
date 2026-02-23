const ALLOWED_HOST_REGEXES = [
  /^localhost(?::\d+)?$/i,
  /^127\.0\.0\.1(?::\d+)?$/,
];

export type HostValidationResult =
  | { valid: true }
  | { valid: false; reason: string };

export function validateHost(host: string): boolean {
  return ALLOWED_HOST_REGEXES.some((pattern) => pattern.test(host));
}

export function validateRequiredHostHeader(
  host: string | undefined,
): HostValidationResult {
  if (!host) {
    return { valid: false, reason: 'Missing Host header' };
  }

  if (!validateHost(host)) {
    return { valid: false, reason: `Host '${host}' is not allowed` };
  }

  return { valid: true };
}
