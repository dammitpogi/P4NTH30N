# Tool Output: tool_c6976f776001Sn7HVe3GfSL4Ce
**Date**: 2026-02-17 02:38:50 UTC
**Size**: 64,470 bytes

```

C:\Users\paulc\.config\opencode\CHANGELOG.md:
  7: - **Connectivity Error Detection**: Updated `background-manager.ts` to recognize "typo in the url or port" and "unable to connect" as retryable provider errors.

C:\Users\paulc\.config\opencode\AGENTS.md:
  251: - Compaction and retry logic (lines 524-540)
  295: 5. **On retry** → picks next available model from chain and updates current model tracking
  302:   - `retryWithNextModel()` - Uses current model tracking instead of faulty fallbackInfo lookup

C:\Users\paulc\.config\opencode\cache\bun.lock:
  194:     "proper-lockfile": ["proper-lockfile@4.1.2", "", { "dependencies": { "graceful-fs": "^4.2.4", "retry": "^0.12.0", "signal-exit": "^3.0.2" } }, "sha512-TjNPblN4BwAWMXU8s9AEz4JmQxnD1NNL7bNOY/AKUzyamc379FWASUhc/K1pL2noVb+XmZKLL68cjzLsiOAMaA=="],
  206:     "retry": ["retry@0.12.0", "", {}, "sha512-9LkiTwjUh6rT555DtE9rTX+BKByPfrMzEAtnlEtdEwr3Nkffwiihqe2bWADg+OQRjt9gl6ICdmB/ZFDCGAtSow=="],

C:\Users\paulc\.config\opencode\agents\orchestrator.md:
  741: #### Connectivity Retry Rule (Immediate)
  743: If a toast/error says `Model error: Unable to connect`, immediately retry the same prompt once.
  746: - Do not ask for confirmation before this one retry.
  747: - If retry fails, continue normal fallback/escalation behavior.

C:\Users\paulc\.config\opencode\models\config\sources.json:
  22:         "retry_after": 5

C:\Users\paulc\.config\opencode\skills\model-tester\SKILL.md:
  62: | 429 | Rate limited | Retry later |

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\ifbench\instructions.md:
  77:   - retry/backoff + rate limiting knobs (optional)
  332:   - retry 429/5xx with exponential backoff

C:\Users\paulc\.config\opencode\skills\update-agent-models\RESEARCH-BEST-PRACTICES.md:
  67: | Server Error | 500-599 | Retry → Fallback |
  68: | Rate Limit | 429 | Retry with backoff → Fallback |
  69: | Timeout | N/A | Retry → Fallback |
  87: ### 2.4 Retry Logic with Exponential Backoff
  90: const retryConfig = {
  177:   └─ Failure (Retryable)
  179:   Retry with Backoff
  195: 4. **Queue and retry**: Background processing for non-critical tasks
  282: - **Maxim AI**: Production retry/fallback/circuit breaker patterns

C:\Users\paulc\.config\opencode\skills\update-agent-models\test-models.sh:
  189:     local retry_count=0
  194:         while [ $retry_count -lt $max_retries ]; do
  202:             # Break on success or non-retryable error
  207:             retry_count=$((retry_count + 1))
  211:     # Retry without auth if auth failed with 401/403/402 (insufficient credits)
  213:         retry_count=0
  214:         while [ $retry_count -lt $max_retries ]; do
  219:             # Break on success or non-retryable error
  224:             retry_count=$((retry_count + 1))
  276:     local retry_count=0
  279:     # Try without key first for free models (with retry on connection failures)
  280:     while [ $retry_count -lt $max_retries ]; do
  285:         # Break on success or non-retryable error
  290:         retry_count=$((retry_count + 1))
  293:     # If auth required and we have a key, retry with auth
  295:         retry_count=0
  296:         while [ $retry_count -lt $max_retries ]; do
  302:             # Break on success or non-retryable error
  307:             retry_count=$((retry_count + 1))
  568:     # Retry with key if available

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\README.md:
  162:   - `max_retries`: Retry attempts to API (default: 50).

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\wget.py:
  600:     (ideally retry and continue download)

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip-25.0.1.dist-info\RECORD:
  267: pip/_internal/utils/__pycache__/retry.cpython-312.pyc,,
  292: pip/_internal/utils/retry.py,sha256=mhFbykXjhTnZfgzeuy-vl9c8nECnYn_CMtwNJX2tYzQ,1392
  834: pip/_vendor/urllib3/util/__pycache__/retry.cpython-312.pyc,,
  846: pip/_vendor/urllib3/util/retry.py,sha256=6ENvOZ8PBDzh8kgixpql9lIrb2dxH-k7ZmBanJF2Ng4,22050

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_vendor\__init__.py:
  98:     vendored("requests.packages.urllib3.util.retry")

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_vendor\urllib3\__init__.py:
  18: from .util.retry import Retry
  49:     "Retry",

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\src\matharena\api_client.py:
  354:                 executor.submit(self._run_query_with_retry, idx, query, ignore_tool_calls): idx
  550:     def _openai_batch_processing(self, queries, indices, retry_idx=0):
  555:             retry_idx (int, optional): Current retry index starting from 0.
  560:         if retry_idx >= self.max_retries:
  602:                 logger.warning(f"Error connecting to batch OpenAI. Retrying in 10s. Exception: {e}")
  623:                 logger.error(f"Error connecting to batch OpenAI. Retrying in 10s. Exception: {e}")
  642:                     results[index] = self.InternalRequestResult(conversation, input_tokens, output_tokens, n_retries=retry_idx)
  653:             repeat_results = self._openai_batch_processing(repeat_queries, retry_idx + 1)
  659:     def _anthropic_batch_processing(self, queries, indices, retry_idx=0):
  664:             retry_idx (int, optional): Current retry index starting from 0.
  669:         if retry_idx >= self.max_retries:
  709:                 logger.warning(f"Error connecting to Anthropic. Retrying in 10s. Exception: {e}")
  736:                 logger.error(f"Error connecting to batch Anthropic. Retrying in 10 seconds. Exception: {e}")
  746:                 results.append(self.InternalRequestResult(conversation, input_tokens, output_tokens, n_retries=retry_idx))
  756:             repeat_results = self._anthropic_batch_processing(repeat_queries, retry_idx + 1)
  766:     def _run_query_with_retry(self, idx, query, ignore_tool_calls=False):
  777:         retry_idx = 0
  780:         while retry_idx < self.max_retries:
  799:                     retry_idx += 1
  802:                     if retry_idx > 3:
  925:             # Inner retry to get a response
  1102:             # Inner retry to get a response
  1135:                                 f"Got OpenAI CC max context length error. Reducing max output tokens to {max_output_tokens} and retrying. Exception: {e}"

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_vendor\urllib3\util\__init__.py:
  7: from .retry import Retry
  31:     "Retry",

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_vendor\urllib3\util\wait.py:
  42:     def _retry_on_intr(fn, timeout):
  47:     def _retry_on_intr(fn, timeout):
  85:     rready, wready, xready = _retry_on_intr(fn, timeout)
  106:     return bool(_retry_on_intr(do_poll, timeout))
  119:         _retry_on_intr(poll_obj.poll, 0)

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_vendor\requests\status_codes.py:
  88:     449: ("retry_with", "retry"),

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_vendor\urllib3\util\retry.py:
  14:     MaxRetryError,
  25: # Data structure for representing the metadata of requests that result in a retry.
  35: class _RetryMeta(type):
  39:             "Using 'Retry.DEFAULT_METHOD_WHITELIST' is deprecated and "
  40:             "will be removed in v2.0. Use 'Retry.DEFAULT_ALLOWED_METHODS' instead",
  48:             "Using 'Retry.DEFAULT_METHOD_WHITELIST' is deprecated and "
  49:             "will be removed in v2.0. Use 'Retry.DEFAULT_ALLOWED_METHODS' instead",
  57:             "Using 'Retry.DEFAULT_REDIRECT_HEADERS_BLACKLIST' is deprecated and "
  58:             "will be removed in v2.0. Use 'Retry.DEFAULT_REMOVE_HEADERS_ON_REDIRECT' instead",
  66:             "Using 'Retry.DEFAULT_REDIRECT_HEADERS_BLACKLIST' is deprecated and "
  67:             "will be removed in v2.0. Use 'Retry.DEFAULT_REMOVE_HEADERS_ON_REDIRECT' instead",
  75:             "Using 'Retry.BACKOFF_MAX' is deprecated and "
  76:             "will be removed in v2.0. Use 'Retry.DEFAULT_BACKOFF_MAX' instead",
  84:             "Using 'Retry.BACKOFF_MAX' is deprecated and "
  85:             "will be removed in v2.0. Use 'Retry.DEFAULT_BACKOFF_MAX' instead",
  91: @six.add_metaclass(_RetryMeta)
  92: class Retry(object):
  93:     """Retry configuration.
  95:     Each retry attempt will create a new Retry object with updated values, so
  100:         retries = Retry(connect=5, read=2, redirect=5)
  106:         response = http.request('GET', 'http://example.com/', retries=Retry(10))
  112:     Errors will be wrapped in :class:`~urllib3.exceptions.MaxRetryError` unless
  121:         Set to ``0`` to fail on the first retry.
  126:         How many connection-related errors to retry on.
  131:         Set to ``0`` to fail on the first retry of this type.
  134:         How many times to retry on read errors.
  139:         Set to ``0`` to fail on the first retry of this type.
  148:         Set to ``0`` to fail on the first retry of this type.
  153:         How many times to retry on bad status codes.
  158:         Set to ``0`` to fail on the first retry of this type.
  161:         How many times to retry on other errors.
  167:         Set to ``0`` to fail on the first retry of this type.
  170:         for unexpected edge cases and avoid infinite retry loops.
  173:         Set of uppercased HTTP method verbs that we should retry on.
  175:         By default, we only retry on methods which are considered to be
  177:         same state). See :attr:`Retry.DEFAULT_ALLOWED_METHODS`.
  179:         Set to a ``False`` value to retry on any verb.
  187:         A set of integer HTTP status codes that we should force a retry on.
  188:         A retry is initiated if the request method is in ``allowed_methods``
  202:         than :attr:`Retry.DEFAULT_BACKOFF_MAX`.
  207:         exhausted, to raise a MaxRetryError, or to return a response with a
  216:         each call to :meth:`~Retry.increment`. The list is in the order
  219:     :param bool respect_retry_after_header:
  220:         Whether to respect Retry-After header on status codes defined as
  221:         :attr:`Retry.RETRY_AFTER_STATUS_CODES` or not.
  235:     RETRY_AFTER_STATUS_CODES = frozenset([413, 429, 503])
  259:         respect_retry_after_header=True,
  273:                 "Using 'method_whitelist' with Retry is deprecated and "
  301:         self.respect_retry_after_header = respect_retry_after_header
  320:             respect_retry_after_header=self.respect_retry_after_header,
  331:                     "Using 'method_whitelist' with Retry is deprecated and "
  348:         if isinstance(retries, Retry):
  373:     def parse_retry_after(self, retry_after):
  375:         if re.match(r"^\s*[0-9]+\s*$", retry_after):
  376:             seconds = int(retry_after)
  378:             retry_date_tuple = email.utils.parsedate_tz(retry_after)
  379:             if retry_date_tuple is None:
  380:                 raise InvalidHeader("Invalid Retry-After header: %s" % retry_after)
  381:             if retry_date_tuple[9] is None:  # Python 2
  386:                 retry_date_tuple = retry_date_tuple[:9] + (0,) + retry_date_tuple[10:]
  388:             retry_date = email.utils.mktime_tz(retry_date_tuple)
  389:             seconds = retry_date - time.time()
  396:     def get_retry_after(self, response):
  397:         """Get the value of Retry-After in seconds."""
  399:         retry_after = response.headers.get("Retry-After")
  401:         if retry_after is None:
  404:         return self.parse_retry_after(retry_after)
  406:     def sleep_for_retry(self, response=None):
  407:         retry_after = self.get_retry_after(response)
  408:         if retry_after:
  409:             time.sleep(retry_after)
  421:         """Sleep between retry attempts.
  423:         This method will respect a server's ``Retry-After`` response header
  429:         if self.respect_retry_after_header and response:
  430:             slept = self.sleep_for_retry(response)
  438:         request, so it should be safe to retry.
  450:     def _is_method_retryable(self, method):
  454:         # TODO: For now favor if the Retry implementation sets its own method_whitelist
  458:                 "Using 'method_whitelist' with Retry is deprecated and "
  470:     def is_retry(self, method, status_code, has_retry_after=False):
  471:         """Is this method/status code retryable? (Based on allowlists and control
  473:         respect the Retry-After header, whether this header is present, and
  477:         if not self._is_method_retryable(method):
  485:             and self.respect_retry_after_header
  486:             and has_retry_after
  487:             and (status_code in self.RETRY_AFTER_STATUS_CODES)
  492:         retry_counts = (
  500:         retry_counts = list(filter(None, retry_counts))
  501:         if not retry_counts:
  504:         return min(retry_counts) < 0
  515:         """Return a new Retry object with incremented retry counters.
  523:         :return: A new ``Retry`` object.
  543:             # Connect retry?
  550:             # Read retry?
  551:             if read is False or not self._is_method_retryable(method):
  557:             # Other retry?
  562:             # Redirect retry?
  583:         new_retry = self.new(
  593:         if new_retry.is_exhausted():
  594:             raise MaxRetryError(_pool, url, error or ResponseError(cause))
  596:         log.debug("Incremented Retry for (url='%s'): %r", url, new_retry)
  598:         return new_retry
  610:                 "Using 'method_whitelist' with Retry is deprecated and "
  616:             return getattr(super(Retry, self), item)
  618:             return getattr(Retry, item)
  622: Retry.DEFAULT = Retry(3)

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_vendor\urllib3\util\request.py:
  127:                 "An error occurred when rewinding request body for redirect/retry."
  132:             "request body during a redirect/retry."

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_vendor\requests\exceptions.py:
  83:     Requests that produced this error are safe to retry.
  131: class RetryError(RequestException):

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_vendor\urllib3\response.py:
  182:         The retries contains the last :class:`~urllib3.util.retry.Retry` that

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_vendor\urllib3\poolmanager.py:
  11:     MaxRetryError,
  20: from .util.retry import Retry
  47:     "key_retries",  # int or Retry
  393:         if not isinstance(retries, Retry):
  394:             retries = Retry.from_int(retries, redirect=redirect)
  409:         except MaxRetryError:

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_vendor\requests\adapters.py:
  19:     MaxRetryError,
  29: from pip._vendor.urllib3.util.retry import Retry
  44:     RetryError,
  180:         made it to the server. By default, Requests does not retry failed
  182:         which we retry a request, import urllib3's ``Retry`` class and pass
  210:             self.max_retries = Retry(0, read=False)
  212:             self.max_retries = Retry.from_int(max_retries)
  684:         except MaxRetryError as e:
  691:                 raise RetryError(e, request=request)

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_vendor\urllib3\exceptions.py:
  77: class MaxRetryError(RequestError):
  179:     """Used as a container for an error reason supplied in a MaxRetryError."""

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_vendor\urllib3\contrib\appengine.py:
  50:     MaxRetryError,
  58: from ..util.retry import Retry
  122:         self.retries = retries or Retry.DEFAULT
  171:                 raise MaxRetryError(self, url, reason=e)
  198:                 raise MaxRetryError(self, url, "too many redirects")
  207:                 except MaxRetryError:
  209:                         raise MaxRetryError(self, url, "too many redirects")
  212:                 retries.sleep_for_retry(http_response)
  226:         # Check if we should retry the HTTP response.
  227:         has_retry_after = bool(http_response.headers.get("Retry-After"))
  228:         if retries.is_retry(method, http_response.status, has_retry_after):
  230:             log.debug("Retry: %s", url)
  295:         if not isinstance(retries, Retry):
  296:             retries = Retry.from_int(retries, redirect=redirect, default=self.retries)
  301:                 "recognize connect, read, or redirect retry parameters.",

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_vendor\urllib3\connectionpool.py:
  30:     MaxRetryError,
  47: from .util.retry import Retry
  158:         Retry configuration to use by default with requests in this pool.
  201:             retries = Retry.DEFAULT
  585:             :class:`~urllib3.exceptions.MaxRetryError` exception.
  587:             Pass ``None`` to retry until you receive a response. Pass a
  588:             :class:`~urllib3.util.retry.Retry` object for fine-grained control
  590:             Pass an integer number to retry connection errors that many times,
  591:             but no other types of errors. Pass zero to never retry.
  594:             immediately. Also, instead of raising a MaxRetryError on redirects,
  597:         :type retries: :class:`~urllib3.util.retry.Retry`, False, or an int.
  601:             303, 307, 308). Each redirect counts as a retry. Disabling retries
  635:             Position to seek to in file-like body in the event of a retry or
  650:         if not isinstance(retries, Retry):
  651:             retries = Retry.from_int(retries, redirect=redirect, default=self.retries)
  699:         # for future rewinds in the event of a redirect/retry.
  807:             # Keep track of the error for the retry warning.
  828:                 "Retrying (%r) after connection broken by '%r': %s", retries, err, url
  858:             except MaxRetryError:
  865:             retries.sleep_for_retry(response)
  883:         # Check if we should retry the HTTP response.
  884:         has_retry_after = bool(response.headers.get("Retry-After"))
  885:         if retries.is_retry(method, response.status, has_retry_after):
  888:             except MaxRetryError:
  896:             log.debug("Retry: %s", url)

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_vendor\pkg_resources\__init__.py:
  2073:                     # Windows, del old file and retry

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_internal\utils\temp_dir.py:
  211:                 # first try with @retry; retrying to handle ephemeral errors

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_internal\utils\retry.py:
  11: def retry(
  14:     """Decorator to automatically retry a function on error.
  20:     :param wait: The time to wait after an error before retrying, in seconds.
  28:         def retry_wrapped(*args: P.args, **kwargs: P.kwargs) -> T:
  40:         return retry_wrapped

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_internal\utils\misc.py:
  44: from pip._internal.utils.retry import retry
  124: # Retry every half second for up to 3 seconds
  125: @retry(stop_after_delay=3, wait=0.5)

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_internal\utils\filesystem.py:
  12: from pip._internal.utils.retry import retry
  67: replace = retry(stop_after_delay=1, wait=0.25)(os.replace)

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_internal\network\session.py:
  350:         # Create our urllib3.Retry instance which will allow us to customize
  352:         retries = urllib3.Retry(
  359:             # retry it.

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip\_internal\index\collector.py:
  33: from pip._vendor.requests.exceptions import RetryError, SSLError
  370:     except RetryError as exc:

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip-25.0.1.dist-info\RECORD:
  267: pip/_internal/utils/__pycache__/retry.cpython-312.pyc,,
  292: pip/_internal/utils/retry.py,sha256=mhFbykXjhTnZfgzeuy-vl9c8nECnYn_CMtwNJX2tYzQ,1392
  834: pip/_vendor/urllib3/util/__pycache__/retry.cpython-312.pyc,,
  846: pip/_vendor/urllib3/util/retry.py,sha256=6ENvOZ8PBDzh8kgixpql9lIrb2dxH-k7ZmBanJF2Ng4,22050

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_vendor\__init__.py:
  98:     vendored("requests.packages.urllib3.util.retry")

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_vendor\urllib3\__init__.py:
  18: from .util.retry import Retry
  49:     "Retry",

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_vendor\urllib3\util\__init__.py:
  7: from .retry import Retry
  31:     "Retry",

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_vendor\urllib3\util\wait.py:
  42:     def _retry_on_intr(fn, timeout):
  47:     def _retry_on_intr(fn, timeout):
  85:     rready, wready, xready = _retry_on_intr(fn, timeout)
  106:     return bool(_retry_on_intr(do_poll, timeout))
  119:         _retry_on_intr(poll_obj.poll, 0)

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_vendor\urllib3\util\retry.py:
  14:     MaxRetryError,
  25: # Data structure for representing the metadata of requests that result in a retry.
  35: class _RetryMeta(type):
  39:             "Using 'Retry.DEFAULT_METHOD_WHITELIST' is deprecated and "
  40:             "will be removed in v2.0. Use 'Retry.DEFAULT_ALLOWED_METHODS' instead",
  48:             "Using 'Retry.DEFAULT_METHOD_WHITELIST' is deprecated and "
  49:             "will be removed in v2.0. Use 'Retry.DEFAULT_ALLOWED_METHODS' instead",
  57:             "Using 'Retry.DEFAULT_REDIRECT_HEADERS_BLACKLIST' is deprecated and "
  58:             "will be removed in v2.0. Use 'Retry.DEFAULT_REMOVE_HEADERS_ON_REDIRECT' instead",
  66:             "Using 'Retry.DEFAULT_REDIRECT_HEADERS_BLACKLIST' is deprecated and "
  67:             "will be removed in v2.0. Use 'Retry.DEFAULT_REMOVE_HEADERS_ON_REDIRECT' instead",
  75:             "Using 'Retry.BACKOFF_MAX' is deprecated and "
  76:             "will be removed in v2.0. Use 'Retry.DEFAULT_BACKOFF_MAX' instead",
  84:             "Using 'Retry.BACKOFF_MAX' is deprecated and "
  85:             "will be removed in v2.0. Use 'Retry.DEFAULT_BACKOFF_MAX' instead",
  91: @six.add_metaclass(_RetryMeta)
  92: class Retry(object):
  93:     """Retry configuration.
  95:     Each retry attempt will create a new Retry object with updated values, so
  100:         retries = Retry(connect=5, read=2, redirect=5)
  106:         response = http.request('GET', 'http://example.com/', retries=Retry(10))
  112:     Errors will be wrapped in :class:`~urllib3.exceptions.MaxRetryError` unless
  121:         Set to ``0`` to fail on the first retry.
  126:         How many connection-related errors to retry on.
  131:         Set to ``0`` to fail on the first retry of this type.
  134:         How many times to retry on read errors.
  139:         Set to ``0`` to fail on the first retry of this type.
  148:         Set to ``0`` to fail on the first retry of this type.
  153:         How many times to retry on bad status codes.
  158:         Set to ``0`` to fail on the first retry of this type.
  161:         How many times to retry on other errors.
  167:         Set to ``0`` to fail on the first retry of this type.
  170:         for unexpected edge cases and avoid infinite retry loops.
  173:         Set of uppercased HTTP method verbs that we should retry on.
  175:         By default, we only retry on methods which are considered to be
  177:         same state). See :attr:`Retry.DEFAULT_ALLOWED_METHODS`.
  179:         Set to a ``False`` value to retry on any verb.
  187:         A set of integer HTTP status codes that we should force a retry on.
  188:         A retry is initiated if the request method is in ``allowed_methods``
  202:         than :attr:`Retry.DEFAULT_BACKOFF_MAX`.
  207:         exhausted, to raise a MaxRetryError, or to return a response with a
  216:         each call to :meth:`~Retry.increment`. The list is in the order
  219:     :param bool respect_retry_after_header:
  220:         Whether to respect Retry-After header on status codes defined as
  221:         :attr:`Retry.RETRY_AFTER_STATUS_CODES` or not.
  235:     RETRY_AFTER_STATUS_CODES = frozenset([413, 429, 503])
  259:         respect_retry_after_header=True,
  273:                 "Using 'method_whitelist' with Retry is deprecated and "
  301:         self.respect_retry_after_header = respect_retry_after_header
  320:             respect_retry_after_header=self.respect_retry_after_header,
  331:                     "Using 'method_whitelist' with Retry is deprecated and "
  348:         if isinstance(retries, Retry):
  373:     def parse_retry_after(self, retry_after):
  375:         if re.match(r"^\s*[0-9]+\s*$", retry_after):
  376:             seconds = int(retry_after)
  378:             retry_date_tuple = email.utils.parsedate_tz(retry_after)
  379:             if retry_date_tuple is None:
  380:                 raise InvalidHeader("Invalid Retry-After header: %s" % retry_after)
  381:             if retry_date_tuple[9] is None:  # Python 2
  386:                 retry_date_tuple = retry_date_tuple[:9] + (0,) + retry_date_tuple[10:]
  388:             retry_date = email.utils.mktime_tz(retry_date_tuple)
  389:             seconds = retry_date - time.time()
  396:     def get_retry_after(self, response):
  397:         """Get the value of Retry-After in seconds."""
  399:         retry_after = response.headers.get("Retry-After")
  401:         if retry_after is None:
  404:         return self.parse_retry_after(retry_after)
  406:     def sleep_for_retry(self, response=None):
  407:         retry_after = self.get_retry_after(response)
  408:         if retry_after:
  409:             time.sleep(retry_after)
  421:         """Sleep between retry attempts.
  423:         This method will respect a server's ``Retry-After`` response header
  429:         if self.respect_retry_after_header and response:
  430:             slept = self.sleep_for_retry(response)
  438:         request, so it should be safe to retry.
  450:     def _is_method_retryable(self, method):
  454:         # TODO: For now favor if the Retry implementation sets its own method_whitelist
  458:                 "Using 'method_whitelist' with Retry is deprecated and "
  470:     def is_retry(self, method, status_code, has_retry_after=False):
  471:         """Is this method/status code retryable? (Based on allowlists and control
  473:         respect the Retry-After header, whether this header is present, and
  477:         if not self._is_method_retryable(method):
  485:             and self.respect_retry_after_header
  486:             and has_retry_after
  487:             and (status_code in self.RETRY_AFTER_STATUS_CODES)
  492:         retry_counts = (
  500:         retry_counts = list(filter(None, retry_counts))
  501:         if not retry_counts:
  504:         return min(retry_counts) < 0
  515:         """Return a new Retry object with incremented retry counters.
  523:         :return: A new ``Retry`` object.
  543:             # Connect retry?
  550:             # Read retry?
  551:             if read is False or not self._is_method_retryable(method):
  557:             # Other retry?
  562:             # Redirect retry?
  583:         new_retry = self.new(
  593:         if new_retry.is_exhausted():
  594:             raise MaxRetryError(_pool, url, error or ResponseError(cause))
  596:         log.debug("Incremented Retry for (url='%s'): %r", url, new_retry)
  598:         return new_retry
  610:                 "Using 'method_whitelist' with Retry is deprecated and "
  616:             return getattr(super(Retry, self), item)
  618:             return getattr(Retry, item)
  622: Retry.DEFAULT = Retry(3)

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_vendor\urllib3\util\request.py:
  127:                 "An error occurred when rewinding request body for redirect/retry."
  132:             "request body during a redirect/retry."

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_vendor\urllib3\response.py:
  182:         The retries contains the last :class:`~urllib3.util.retry.Retry` that

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_vendor\urllib3\poolmanager.py:
  11:     MaxRetryError,
  20: from .util.retry import Retry
  47:     "key_retries",  # int or Retry
  393:         if not isinstance(retries, Retry):
  394:             retries = Retry.from_int(retries, redirect=redirect)
  409:         except MaxRetryError:

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_vendor\urllib3\exceptions.py:
  77: class MaxRetryError(RequestError):
  179:     """Used as a container for an error reason supplied in a MaxRetryError."""

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_vendor\urllib3\contrib\appengine.py:
  50:     MaxRetryError,
  58: from ..util.retry import Retry
  122:         self.retries = retries or Retry.DEFAULT
  171:                 raise MaxRetryError(self, url, reason=e)
  198:                 raise MaxRetryError(self, url, "too many redirects")
  207:                 except MaxRetryError:
  209:                         raise MaxRetryError(self, url, "too many redirects")
  212:                 retries.sleep_for_retry(http_response)
  226:         # Check if we should retry the HTTP response.
  227:         has_retry_after = bool(http_response.headers.get("Retry-After"))
  228:         if retries.is_retry(method, http_response.status, has_retry_after):
  230:             log.debug("Retry: %s", url)
  295:         if not isinstance(retries, Retry):
  296:             retries = Retry.from_int(retries, redirect=redirect, default=self.retries)
  301:                 "recognize connect, read, or redirect retry parameters.",

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_vendor\urllib3\connectionpool.py:
  30:     MaxRetryError,
  47: from .util.retry import Retry
  158:         Retry configuration to use by default with requests in this pool.
  201:             retries = Retry.DEFAULT
  585:             :class:`~urllib3.exceptions.MaxRetryError` exception.
  587:             Pass ``None`` to retry until you receive a response. Pass a
  588:             :class:`~urllib3.util.retry.Retry` object for fine-grained control
  590:             Pass an integer number to retry connection errors that many times,
  591:             but no other types of errors. Pass zero to never retry.
  594:             immediately. Also, instead of raising a MaxRetryError on redirects,
  597:         :type retries: :class:`~urllib3.util.retry.Retry`, False, or an int.
  601:             303, 307, 308). Each redirect counts as a retry. Disabling retries
  635:             Position to seek to in file-like body in the event of a retry or
  650:         if not isinstance(retries, Retry):
  651:             retries = Retry.from_int(retries, redirect=redirect, default=self.retries)
  699:         # for future rewinds in the event of a redirect/retry.
  807:             # Keep track of the error for the retry warning.
  828:                 "Retrying (%r) after connection broken by '%r': %s", retries, err, url
  858:             except MaxRetryError:
  865:             retries.sleep_for_retry(response)
  883:         # Check if we should retry the HTTP response.
  884:         has_retry_after = bool(response.headers.get("Retry-After"))
  885:         if retries.is_retry(method, response.status, has_retry_after):
  888:             except MaxRetryError:
  896:             log.debug("Retry: %s", url)

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\vendor\lm-evaluation-harness\docs\API_guide.md:
  12: - Retrying failed requests

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\vendor\lm-evaluation-harness\lm_eval\models\utils.py:
  196: def retry_on_specific_exceptions(
  203:     """Retry on an LLM Provider's rate limit error with exponential backoff
  209:     @retry_on_specific_exceptions([RateLimitError], max_retries=3)

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\vendor\lm-evaluation-harness\lm_eval\models\textsynth.py:
  23: from lm_eval.models.utils import retry_on_specific_exceptions
  31:     Retry with back-off until they respond.
  39:     @retry_on_specific_exceptions(
  41:         max_retries=None,  # retry forever, consider changing

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\vendor\lm-evaluation-harness\lm_eval\models\gguf.py:
  69:                 time.sleep(delay)  # wait before retrying

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\vendor\lm-evaluation-harness\lm_eval\models\api_models.py:
  27:     from tenacity import RetryError, retry, stop_after_attempt, wait_exponential
  480:                     f"API request failed with error message: {response.text}. Retrying..."
  484:         except RetryError:
  523:                         f"Response text: {error_text}. Retrying..."
  525:                 # raising exception will retry the request
  545:             eval_logger.error(f"Exception:{repr(e)}, {outputs}, retrying.")
  589:             retry_: Callable[..., Awaitable[Any]] = retry(
  593:                 before_sleep=lambda retry_state: eval_logger.info(
  594:                     f"Retry attempt {retry_state.attempt_number}"
  600:                     retry_(
  649:                 outputs = retry(
  756:                 outputs = retry(

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\vendor\lm-evaluation-harness\lm_eval\models\anthropic_llms.py:
  11: from lm_eval.models.utils import handle_stop_sequences, retry_on_specific_exceptions
  56:             f"RateLimitError occurred: {e.__cause__}\n Retrying in {sleep_time} seconds"
  59:     @retry_on_specific_exceptions(
  61:         max_retries=None,  # retry forever, consider changing
  119:             f"RateLimitError occurred: {e.__cause__}\n Retrying in {sleep_time} seconds"
  122:     @retry_on_specific_exceptions(
  128:         max_retries=None,  # retry forever, consider changing

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\terminal-bench\terminal_bench\llms\lite_llm.py:
  20:     retry,
  21:     retry_if_not_exception_type,
  113:     @retry(
  116:         retry=retry_if_not_exception_type(

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\terminal-bench\terminal_bench\harness\harness.py:
  21: from tenacity import RetryError
  675:         except RetryError as e:

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_vendor\requests\adapters.py:
  19:     MaxRetryError,
  29: from pip._vendor.urllib3.util.retry import Retry
  44:     RetryError,
  180:         made it to the server. By default, Requests does not retry failed
  182:         which we retry a request, import urllib3's ``Retry`` class and pass
  210:             self.max_retries = Retry(0, read=False)
  212:             self.max_retries = Retry.from_int(max_retries)
  684:         except MaxRetryError as e:
  691:                 raise RetryError(e, request=request)

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_vendor\requests\exceptions.py:
  83:     Requests that produced this error are safe to retry.
  131: class RetryError(RequestException):

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_vendor\requests\status_codes.py:
  88:     449: ("retry_with", "retry"),

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\terminal-bench\adapters\swelancer\template\swe\run-tests.sh:
  83:     # we found a succesful test, can exit from our retry loop

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\terminal-bench\terminal_bench\agents\terminus_2\terminus_2.py:
  5: from tenacity import retry, stop_after_attempt
  320:     @retry(stop=stop_after_attempt(3))

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\terminal-bench\terminal_bench\agents\terminus_1.py:
  5: from tenacity import retry, retry_if_not_exception_type, stop_after_attempt
  117:     @retry(
  119:         retry=retry_if_not_exception_type(

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\terminal-bench\terminal_bench\agents\mcp_agents\mcp_terminus.py:
  19: from tenacity import retry, stop_after_attempt, wait_exponential
  76:     @retry(

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\tau2-bench\web\leaderboard\src\components\Leaderboard.jsx:
  459:           <button onClick={loadSubmissionData} className="retry-button">
  460:             Retry

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\terminal-bench\terminal_bench\agents\mcp_agents\mcp_server.py:
  7: from tenacity import retry, stop_after_attempt, wait_exponential
  98:     @retry(

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\tau2-bench\web\leaderboard\src\components\Leaderboard.css:
  1006: .retry-button {
  1019: .retry-button:hover {

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_vendor\pkg_resources\__init__.py:
  2073:                     # Windows, del old file and retry

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\terminal-bench\original-tasks\vul-flink\tests\test_outputs.py:
  13: def _wait_for_flink_rest(max_retries: int = 60, retry_delay_sec: float = 1.0) -> None:
  29:         time.sleep(retry_delay_sec)
  41:     retry_delay_sec: float = 1.0,
  80:             time.sleep(retry_delay_sec)

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\terminal-bench\original-tasks\unprivileged-headless-pyrender\solution.sh:
  15: # Download with retry
  22:     echo "Download attempt $i failed, retrying in 2 seconds..."

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\tau2-bench\web\leaderboard\public\submissions\toolorchestra_nvidia_2025-12-02\trajectories\toolorchestra_telecom_gpt-5_1trial.json:
  20174:           "content": "Here are the Step 1 results from check_network_status:\n- airplane_mode: ON\n- signal_strength: none\n- network_type: none\n- mobile_data_enabled: Yes\n- data_roaming_enabled: Yes\n\nAdditional note: it also shows the SIM status as missing and cellular connection as no_service. With airplane mode ON (and the SIM possibly not being detected), I won\u2019t be able to test mobile data or MMS yet.\n\nHow would you like me to proceed?\n- I can turn off Airplane Mode first and check whether the SIM is detected, then retry the mobile data test you mentioned.\n- Or I can continue to Step 2 (check_apn_settings) first\u2014just let me know your preference.\n\nAlso, yes\u2014please check my line\u2019s current data usage and plan limits for 555-123-2002. If I\u2019m out of data, I\u2019m okay with refueling up to 2 GB, but I don\u2019t want to change my plan.",
  20455: [Omitted long matching line]
  32402: [Omitted long matching line]
  34124: [Omitted long matching line]
  34198: [Omitted long matching line]
  39945:           "content": "{\"message\":\"Yes \u2014 please run check_wifi_calling_status now and share the exact output (Wi\u2011Fi Calling ON or OFF). \\n\\nWhy: Wi\u2011Fi Calling sometimes interferes with MMS, especially while roaming. If the check shows Wi\u2011Fi Calling is ON, I\u2019ll ask you to toggle it OFF (toggle_wifi_calling) and then retry sending the MMS. If it\u2019s OFF, I\u2019ll have you run check_app_permissions for the messaging app next to verify it has storage and SMS permissions.\"}",
  46998:           "content": "{\"message\":\"Yes \u2014 please turn Data Roaming ON now. Do this one step and report back. \\n\\nHow to turn Data Roaming ON:\\n- Android (general): Settings > Network & internet (or Connections) > Mobile network > Data roaming \u2192 toggle ON.\\n- iPhone: Settings > Cellular (or Mobile Data) > Cellular Data Options (or Mobile Data Options) > Data Roaming \u2192 toggle ON.\\n\\nAfter you turn it ON, wait 30\u201360 seconds for the phone to register on the roaming network, then run a speed test (e.g., speedtest.net) and tell me the result (download Mbps, upload Mbps, ping ms) or whether it says \u201cNo Connection.\u201d If the speed test still fails, do this single follow-up action and then re-run the test: toggle Mobile data OFF for 10 seconds, then ON, wait 30\u201360 seconds, and retry. Also confirm you have VPN disconnected. Report what happens and I\u2019ll tell you the next step.\"}",
  58047: [Omitted long matching line]
  61583: [Omitted long matching line]
  61609:           "content": "I tried sending one photo to my daughter, but it didn\u2019t go through. It just shows \u201cNot sent \u2014 tap to retry.\u201d\n\nWhat should we try next? Could you keep it very simple, please? I\u2019m feeling a bit anxious, but I\u2019m ready to follow your lead step by step.",
  61615: [Omitted long matching line]
  61681:           "content": "I found Wi\u2011Fi Calling was ON and I turned it OFF.\n\nI tried sending the photo again, but it still says \u201cNot sent \u2014 tap to retry.\u201d\n\nWhat\u2019s the next simple step? I\u2019m hanging in there, but I\u2019d really like to get this working.",
  61687: [Omitted long matching line]
  61778:           "content": "I followed the Android steps.\n\n- I found the Messages app permissions. It already had SMS and Phone, but Storage/Files & media was not allowed.\n- I granted Storage permission.\n\nI tried sending the photo again, but it still shows \u201cNot sent \u2014 tap to retry.\u201d\n\nWhat should we try next? Please keep it very simple. I\u2019m trying not to get flustered.",
  61784: [Omitted long matching line]
  61850:           "content": "Okay, I reset the APN settings to default and did a restart like you said.\n\nAfter the restart, I still see:\n- Signal bars: 4 bars.\n- Network label: 5G.\n- Mobile data: ON.\n\nI tried sending the photo again, but it still says \u201cNot sent \u2014 tap to retry.\u201d This is getting a bit frustrating. What should we try next? I\u2019ll follow your steps carefully.",
  61856: [Omitted long matching line]
  61944:           "content": "Here\u2019s what I found from those checks:\n\n- SIM status: It says the SIM card is active and working.\n- Messages app: Auto-download/Auto-retrieve MMS looked on to me, and the app has SMS, Phone, and Storage permissions.\n- APN MMSC: I see an MMSC URL listed: http://mms.carrier.com/mms/wapenc.\n- Small MMS test: I tried a smaller photo to myself, and it still shows \u201cNot sent \u2014 tap to retry.\u201d\n\nGiven all that, I\u2019m worried this might be something on the carrier side with roaming or MMS provisioning. I really don\u2019t want to change my plan, but if there are any small changes on your end, I\u2019m okay with that. I\u2019m still not comfortable sharing my date of birth, and I don\u2019t have a Customer ID. Is there any other way we can fix it, or can you transfer me to a human agent who might have other verification options?",
  61956: [Omitted long matching line]
  63301: [Omitted long matching line]
  64655: [Omitted long matching line]
  65002: [Omitted long matching line]
  66683: [Omitted long matching line]
  67304: [Omitted long matching line]
  71118:           "content": "Here\u2019s what I just did and saw:\n\n- Network Mode: Already set to 4G/5G preferred.\n- Reboot: Completed.\n- Status bar after reboot: Excellent signal (4 bars) | 5G | Data Enabled | Battery 80%.\n- MMS test: I tried sending a photo again, and the diagnostic still says the messaging app cannot send MMS.\n\nA little frustrating that it\u2019s still failing after all that. How would you like me to proceed next? I can do any of the following one at a time as you prefer:\n- Temporarily turn Wi\u2011Fi OFF and retry sending an MMS.\n- Check the messaging app\u2019s Background data/Data usage setting to ensure it\u2019s not restricted.\n- Clear the Messaging app\u2019s cache (and data if needed), then test again.\n- Try a different messaging app (if available) to see if MMS works there.\n- Reset network settings and reboot, then test again.\n\nPlease let me know which single step you\u2019d like me to try next.",
  72333: [Omitted long matching line]
  72345: [Omitted long matching line]
  80914:           "content": "Here\u2019s what I did and found:\n\n1) APN settings:\n   - APN name: internet\n   - MMSC URL: Not Set (blank)\n\nSince the MMSC was missing, I followed your steps:\n2) Reset APN settings: Done.\n3) Rebooted the phone: Completed.\n4) Test after reboot:\n   - can_send_mms: It still reports that my messaging app cannot send MMS.\n\nWhat should we try next? I can also retry sending a small picture MMS if you\u2019d like and report what happens.",
  84452: [Omitted long matching line]
  84616:           "content": "Thanks \u2014 I followed your steps.\n\n- Airplane Mode: OFF\n- Mobile Data: ON\n- Data Roaming: ON\n- Wi\u2011Fi: OFF\n- Status bar: No Signal, and I don\u2019t see any 4G/5G/3G indicator. It also shows \u201cData Disabled,\u201d and there\u2019s no roaming icon.\n\nI tried sending the MMS again, and it still won\u2019t go through.\n\nIn the network settings I\u2019m also seeing:\n- SIM Card Status: missing\n- Cellular connection: no service\n- Signal: none\n- Network type: none\n\nThis is a bit frustrating. Since it\u2019s showing the SIM as missing, should I reseat the SIM card next and then retry? Or do you want me to proceed with the APN/MMSC checks first?",
  93024: [Omitted long matching line]

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\terminal-bench\original-tasks\adaptive-rejection-sampler\solution.sh:
  46:             echo "Attempt $attempt failed, retrying..."

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_internal\utils\temp_dir.py:
  211:                 # first try with @retry; retrying to handle ephemeral errors

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\tau2-bench\web\leaderboard\public\submissions\toolorchestra_nvidia_2025-12-02\trajectories\toolorchestra_airline_gpt-5_1trial.json:
  21384: [Omitted long matching line]
  21390: [Omitted long matching line]
  21477: [Omitted long matching line]

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_internal\utils\retry.py:
  11: def retry(
  14:     """Decorator to automatically retry a function on error.
  20:     :param wait: The time to wait after an error before retrying, in seconds.
  28:         def retry_wrapped(*args: P.args, **kwargs: P.kwargs) -> T:
  40:         return retry_wrapped

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_internal\utils\misc.py:
  44: from pip._internal.utils.retry import retry
  124: # Retry every half second for up to 3 seconds
  125: @retry(stop_after_delay=3, wait=0.5)

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_internal\utils\filesystem.py:
  12: from pip._internal.utils.retry import retry
  67: replace = retry(stop_after_delay=1, wait=0.25)(os.replace)

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_internal\network\session.py:
  350:         # Create our urllib3.Retry instance which will allow us to customize
  352:         retries = urllib3.Retry(
  359:             # retry it.

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Lib\site-packages\pip\_internal\index\collector.py:
  33: from pip._vendor.requests.exceptions import RetryError, SSLError
  370:     except RetryError as exc:

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\tau2-bench\web\leaderboard\package-lock.json:
  937:         "@hum

... (truncated)
```
