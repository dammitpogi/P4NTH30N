namespace H0UND.Infrastructure.Tray;

public interface ITrayCallback
{
    void OnShowRequested();
    void OnHideRequested();
    void OnExitRequested();
}
