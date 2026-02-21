namespace T4CT1CS;

public class SimpleServiceProvider : IServiceProvider
{
	private readonly Dictionary<Type, object> _singletons = new();
	private readonly Dictionary<Type, Type> _transients = new();

	public T GetService<T>()
		where T : class
	{
		return (T)GetService(typeof(T));
	}

	public object GetService(Type type)
	{
		if (_singletons.TryGetValue(type, out var singleton))
		{
			return singleton;
		}

		if (_transients.TryGetValue(type, out var implementationType))
		{
			return CreateInstance(implementationType);
		}

		throw new InvalidOperationException($"Service of type {type.Name} is not registered");
	}

	private object CreateInstance(Type implementationType)
	{
		var constructors = implementationType.GetConstructors();
		var constructor = constructors.FirstOrDefault(c => c.GetParameters().Length > 0) ?? constructors.First();

		var parameters = constructor.GetParameters();
		var args = new object[parameters.Length];

		for (int i = 0; i < parameters.Length; i++)
		{
			var parameterType = parameters[i].ParameterType;
			args[i] = GetService(parameterType);
		}

		return Activator.CreateInstance(implementationType, args)!;
	}

	public void RegisterSingleton<T>(T instance)
		where T : class
	{
		_singletons[typeof(T)] = instance;
	}

	public void RegisterTransient<TInterface, TImplementation>()
		where TInterface : class
		where TImplementation : class, TInterface
	{
		_transients[typeof(TInterface)] = typeof(TImplementation);
	}
}
