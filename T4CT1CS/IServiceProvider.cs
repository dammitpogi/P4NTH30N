namespace T4CT1CS;

public interface IServiceProvider
{
    T GetService<T>() where T : class;
    object GetService(Type type);
    void RegisterSingleton<T>(T instance) where T : class;
    void RegisterTransient<TInterface, TImplementation>()
        where TInterface : class
        where TImplementation : class, TInterface;
}
