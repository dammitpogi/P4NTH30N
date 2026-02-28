using System.Windows.Forms;

namespace H0UND.Infrastructure.Tray;

public sealed class TrayHost : IDisposable
{
    private readonly NotifyIcon _notifyIcon;
    private readonly ToolStripMenuItem _showHideItem;
    private readonly ITrayCallback _callback;
    private bool _isConsoleVisible = true;
    private bool _disposed;

    public TrayHost(ITrayCallback callback)
    {
        _callback = callback ?? throw new ArgumentNullException(nameof(callback));

        var contextMenu = new ContextMenuStrip();
        _showHideItem = new ToolStripMenuItem("Hide Dashboard", null, OnShowHideClick);
        contextMenu.Items.Add(_showHideItem);
        contextMenu.Items.Add(new ToolStripSeparator());
        contextMenu.Items.Add("Exit", null, OnExitClick);

        _notifyIcon = new NotifyIcon
        {
            Icon = ResolveTrayIcon(),
            Text = "P4NTHE0N Dashboard",
            Visible = true,
            ContextMenuStrip = contextMenu,
        };

        _notifyIcon.DoubleClick += OnTrayDoubleClick;
    }

    private static System.Drawing.Icon ResolveTrayIcon()
    {
        try
        {
            if (!string.IsNullOrWhiteSpace(Environment.ProcessPath))
            {
                var processIcon = System.Drawing.Icon.ExtractAssociatedIcon(
                    Environment.ProcessPath);
                if (processIcon is not null)
                {
                    return processIcon;
                }
            }
        }
        catch
        {
        }

        return System.Drawing.SystemIcons.Application;
    }

    private void OnTrayDoubleClick(object? sender, EventArgs e)
    {
        ToggleVisibility();
    }

    private void OnShowHideClick(object? sender, EventArgs e)
    {
        ToggleVisibility();
    }

    private void OnExitClick(object? sender, EventArgs e)
    {
        _callback.OnExitRequested();
    }

    private void ToggleVisibility()
    {
        if (_isConsoleVisible)
        {
            _callback.OnHideRequested();
            _isConsoleVisible = false;
            _showHideItem.Text = "Show Dashboard";
            return;
        }

        _callback.OnShowRequested();
        _isConsoleVisible = true;
        _showHideItem.Text = "Hide Dashboard";
    }

    public void ShowBalloonTip(string title, string message, ToolTipIcon icon = ToolTipIcon.Info)
    {
        if (_disposed)
        {
            return;
        }

        _notifyIcon.ShowBalloonTip(3000, title, message, icon);
    }

    public void UpdateTooltip(string tooltip)
    {
        if (_disposed)
        {
            return;
        }

        _notifyIcon.Text = tooltip.Length > 63 ? tooltip[..63] : tooltip;
    }

    public void Dispose()
    {
        if (_disposed)
        {
            return;
        }

        _disposed = true;
        _notifyIcon.Visible = false;
        _notifyIcon.Dispose();
    }
}
