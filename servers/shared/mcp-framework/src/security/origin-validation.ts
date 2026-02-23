const ALLOWED_ORIGIN_REGEXES = [
  /^http:\/\/localhost:\d+$/,
  /^http:\/\/127\.0\.0\.1:\d+$/,
];

export type OriginValidationResult =
  | { valid: true }
  | { valid: false; reason: string };

export function validateOrigin(origin: string): boolean {
  return ALLOWED_ORIGIN_REGEXES.some((pattern) => pattern.test(origin));
}

export function validateRequiredOriginHeader(
  origin: string | undefined,
): OriginValidationResult {
  if (!origin) {
    return { valid: false, reason: 'Missing Origin header' };
  }

  if (origin === 'null') {
    return { valid: false, reason: 'Null Origin header is not allowed' };
  }

  if (!validateOrigin(origin)) {
    return { valid: false, reason: `Origin '${origin}' is not allowed` };
  }

  return { valid: true };
}
