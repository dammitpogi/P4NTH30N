namespace H0UND.Services.Orchestration;

public class ExponentialBackoffRetryPolicy
{
    private readonly int _maxRetries;
    private readonly TimeSpan _baseDelay;
    private readonly TimeSpan _maxDelay;

    public ExponentialBackoffRetryPolicy(
        int maxRetries = 5,
        int baseDelaySeconds = 5,
        int maxDelaySeconds = 60)
    {
        _maxRetries = maxRetries;
        _baseDelay = TimeSpan.FromSeconds(baseDelaySeconds);
        _maxDelay = TimeSpan.FromSeconds(maxDelaySeconds);
    }

    public async Task ExecuteAsync(Func<Task> action, Func<Exception, bool> isRetryable)
    {
        for (var attempt = 0; attempt < _maxRetries; attempt++)
        {
            try
            {
                await action();
                return;
            }
            catch (Exception ex) when (isRetryable(ex) && attempt < _maxRetries - 1)
            {
                var delay = CalculateDelay(attempt);
                await Task.Delay(delay);
            }
        }
    }

    private TimeSpan CalculateDelay(int attempt)
    {
        var delay = TimeSpan.FromTicks(_baseDelay.Ticks * (1L << attempt));
        return delay > _maxDelay ? _maxDelay : delay;
    }
}
