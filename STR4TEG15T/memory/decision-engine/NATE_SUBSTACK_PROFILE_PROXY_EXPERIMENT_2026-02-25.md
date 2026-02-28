# Nate Substack Profile/Proxy Experiment - 2026-02-25

## Objective

Test whether session isolation (profiles/incognito) or proxy routing can clear Substack OTP throttle and restore paid capture path.

## Session Isolation Results

- `chromium-incognito`: submit returns throttle state, OTP input not visible.
- `chromium-profile-A`: submit returns throttle state, OTP input not visible.
- `chromium-profile-B`: submit returns throttle state, OTP input not visible.

## Browser Engine Coverage

- `firefox`: not installed in local Playwright runtime.
- `webkit`: not installed in local Playwright runtime.

## Proxy Coverage

- Environment proxy variables: none.
- Local proxy endpoint probes:
  - `http://127.0.0.1:7890` -> `ERR_PROXY_CONNECTION_FAILED`
  - `http://127.0.0.1:8080` -> `ERR_PROXY_CONNECTION_FAILED`
  - `http://127.0.0.1:3128` -> `ERR_PROXY_CONNECTION_FAILED`
  - `socks5://127.0.0.1:1080` -> `ERR_PROXY_CONNECTION_FAILED`

## Conclusion

- Profile switching and incognito alone are insufficient under current provider throttle state.
- Proxy strategy cannot proceed without a live proxy endpoint.
- Continue cooldown-first OTP strategy; use proxy path only when endpoint is available.

## Evidence

- `STR4TEG15T/tools/workspace/tools/substack-scraper/profile-matrix-results.json`
