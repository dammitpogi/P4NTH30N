using System;
using System.Threading.Tasks;
using P4NTHE0N.C0MMON.Entities;
using P4NTHE0N.C0MMON.Infrastructure.EventBus;

namespace P4NTHE0N.H4ND.Vision;

/// <summary>
/// FEAT-036: Publishes vision commands to the event bus for H4ND consumption.
/// Bridges vision system decisions to the H4ND execution pipeline.
/// </summary>
public sealed class VisionCommandPublisher
{
	private readonly InMemoryEventBus _eventBus;
	private long _published;

	public long TotalPublished => System.Threading.Interlocked.Read(ref _published);

	public VisionCommandPublisher(InMemoryEventBus eventBus)
	{
		_eventBus = eventBus ?? throw new ArgumentNullException(nameof(eventBus));
	}

	/// <summary>
	/// Publishes a vision command to the event bus.
	/// </summary>
	/// <param name="commandType">Type of command.</param>
	/// <param name="username">Target username.</param>
	/// <param name="game">Target game.</param>
	/// <param name="house">Target house.</param>
	/// <param name="confidence">Vision confidence (0.0-1.0).</param>
	/// <param name="reason">Reason for the command.</param>
	public async Task PublishAsync(
		VisionCommandType commandType,
		string username,
		string game,
		string house,
		double confidence,
		string reason
	)
	{
		VisionCommand command = new()
		{
			CommandType = commandType,
			TargetUsername = username,
			TargetGame = game,
			TargetHouse = house,
			Confidence = confidence,
			Reason = reason,
		};

		await _eventBus.PublishAsync(command);
		System.Threading.Interlocked.Increment(ref _published);
		Console.WriteLine($"[VisionCommandPublisher] Published {commandType} for {username}@{game} (conf: {confidence:F2})");
	}

	/// <summary>
	/// Publishes an existing vision command to the event bus.
	/// </summary>
	public async Task PublishAsync(VisionCommand command)
	{
		await _eventBus.PublishAsync(command);
		System.Threading.Interlocked.Increment(ref _published);
		Console.WriteLine($"[VisionCommandPublisher] Published {command.CommandType} for {command.TargetUsername}@{command.TargetGame}");
	}
}
