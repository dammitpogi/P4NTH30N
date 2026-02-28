using System;
using System.Collections.Generic;
using P4NTHE0N.C0MMON.Interfaces;

namespace P4NTHE0N.C0MMON.Infrastructure.Deployment;

/// <summary>
/// Factory for creating VM provider and file transfer implementations.
/// </summary>
public class VMProviderFactory : IVMProviderFactory
{
	private readonly Dictionary<VMProviderType, IVMProvider> _providers = new();
	private readonly Dictionary<VMProviderType, IVMFileTransfer> _fileTransfers = new();

	/// <summary>
	/// Initializes a new instance of the factory with default implementations.
	/// </summary>
	public VMProviderFactory()
	{
		// Register default implementations
		RegisterProvider(VMProviderType.HyperV, new HyperVProvider());
		RegisterProvider(VMProviderType.VirtualBox, new VirtualBoxProvider());

		RegisterFileTransfer(VMProviderType.HyperV, new HyperVFileTransfer());
		RegisterFileTransfer(VMProviderType.VirtualBox, new VirtualBoxFileTransfer());
	}

	/// <inheritdoc />
	public IReadOnlyList<VMProviderType> SupportedProviders { get; } = new[] { VMProviderType.HyperV, VMProviderType.VirtualBox };

	/// <inheritdoc />
	public IVMProvider CreateProvider(VMProviderType providerType)
	{
		if (_providers.TryGetValue(providerType, out IVMProvider? provider))
		{
			return provider;
		}

		throw new NotSupportedException($"VM provider type '{providerType}' is not supported.");
	}

	/// <inheritdoc />
	public IVMFileTransfer CreateFileTransfer(VMProviderType providerType)
	{
		if (_fileTransfers.TryGetValue(providerType, out IVMFileTransfer? fileTransfer))
		{
			return fileTransfer;
		}

		throw new NotSupportedException($"File transfer for provider type '{providerType}' is not supported.");
	}

	/// <summary>
	/// Registers a custom VM provider implementation.
	/// </summary>
	/// <param name="providerType">Type of provider.</param>
	/// <param name="provider">Provider implementation.</param>
	public void RegisterProvider(VMProviderType providerType, IVMProvider provider)
	{
		_providers[providerType] = provider ?? throw new ArgumentNullException(nameof(provider));
	}

	/// <summary>
	/// Registers a custom file transfer implementation.
	/// </summary>
	/// <param name="providerType">Type of provider.</param>
	/// <param name="fileTransfer">File transfer implementation.</param>
	public void RegisterFileTransfer(VMProviderType providerType, IVMFileTransfer fileTransfer)
	{
		_fileTransfers[providerType] = fileTransfer ?? throw new ArgumentNullException(nameof(fileTransfer));
	}
}
