using H0UND.Infrastructure.Native;

namespace H0UND.Infrastructure.Tray;

public sealed class ConsoleWindowManager : IDisposable
{
    private readonly IntPtr _consoleHandle;
    private readonly NativeMethods.HandlerRoutine _ctrlHandler;
    private Func<bool>? _closeRequestedCallback;
    private bool _disposed;

    public ConsoleWindowManager()
    {
        _consoleHandle = NativeMethods.GetConsoleWindow();
        _ctrlHandler = new NativeMethods.HandlerRoutine(OnConsoleCtrlEvent);
        NativeMethods.SetConsoleCtrlHandler(_ctrlHandler, true);
    }

    public void SetCloseHandler(Func<bool> handler)
    {
        _closeRequestedCallback = handler;
    }

    private bool OnConsoleCtrlEvent(uint ctrlType)
    {
        if (ctrlType == NativeMethods.CTRL_CLOSE_EVENT)
        {
            return _closeRequestedCallback?.Invoke() ?? false;
        }

        return false;
    }

    public void Show()
    {
        if (_consoleHandle == IntPtr.Zero)
        {
            return;
        }

        NativeMethods.ShowWindow(_consoleHandle, NativeMethods.SW_SHOW);
        NativeMethods.SetForegroundWindow(_consoleHandle);
    }

    public void Hide()
    {
        if (_consoleHandle == IntPtr.Zero)
        {
            return;
        }

        NativeMethods.ShowWindow(_consoleHandle, NativeMethods.SW_HIDE);
    }

    public bool IsVisible =>
        _consoleHandle != IntPtr.Zero
        && NativeMethods.IsWindowVisible(_consoleHandle);

    public void Dispose()
    {
        if (_disposed)
        {
            return;
        }

        _disposed = true;
        NativeMethods.SetConsoleCtrlHandler(_ctrlHandler, false);
    }
}
