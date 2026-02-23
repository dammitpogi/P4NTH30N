export { securityPlugin } from './plugins/security.js';
export type { SecurityPluginOptions } from './plugins/security.js';

export { assertSecureBindAddress, validateBindAddress } from './security/bind-validation.js';
export { corsConfig } from './security/cors-config.js';
export {
  validateHost,
  validateRequiredHostHeader,
} from './security/host-validation.js';
export {
  validateOrigin,
  validateRequiredOriginHeader,
} from './security/origin-validation.js';
