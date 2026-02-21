# Tool Output: tool_c78147f37001XLHrKO5hStl9CB
**Date**: 2026-02-19 22:45:35 UTC
**Size**: 59,655 bytes

```
H4ND running (PID: 7956, Mem: 61.52MB)

=== H4ND Log ===
[MongoConnectionOptions] Using: mongodb://192.168.56.1:27017/ / P4NTH30N
[CdpHealthCheck] HTTP /json/version: OK
[CDP] Connected to Chrome at 192.168.56.1:9222
[CdpHealthCheck] WebSocket handshake: OK
[CdpHealthCheck] Round-trip eval(1+1)=2 in 3.7ms: OK
[CDP:FireKirin] Login failed for healthcheck: [CDP] Selector 'input[name='loginName'], #loginName, input[type='text']' not found for focus within 10000ms
[CdpHealthCheck] Login flow simulation: FAIL (expected for test creds)
[CdpHealthCheck] Overall: HEALTHY (12513ms)
[H4ND] CDP pre-flight OK: HTTP=True, WS=True, RT=True (3.7ms), Login=True
[SpinHealthEndpoint] Listening on http://localhost:9280/health
[H4ND] FourEyes event bus + command pipeline initialized
[VisionCommandListener] Started listening for vision commands
            .d8888b.     .d8888b.    888888888     .d8888b.  
           d88P  Y88b   d88P  Y88b   888          d88P  Y88b 
           888    888   Y88b. d88P   888          888        
888  888   888    888    "Y88888"    8888888b.    888d888b.  
888  888   888    888   .d8P""Y8b.        "Y88b   888P "Y88b 
Y88  88P   888    888   888    888          888   888    888 
 Y8bd8P    Y88b  d88Pd8bY88b  d88Pd8bY88b  d88Pd8bY88b  d88P 
  Y88P      "Y8888P" Y8P "Y8888P" Y8P "Y8888P" Y8P "Y8888P"  
                                                             
                                                             
                                                             

A timeout occurred after 29998ms selecting a server using CompositeServerSelector{ Selectors = ReadPreferenceServerSelector{ ReadPreference = { Mode : Primary } }, LatencyLimitingServerSelector{ AllowedLatencyRange = 00:00:00.0150000 }, OperationsCountServerSelector }. Client view of cluster state is { ClusterId : "1", Type : "ReplicaSet", State : "Disconnected", Servers : [{ ServerId: "{ ClusterId : 1, EndPoint : "Unspecified/localhost:27017" }", EndPoint: "Unspecified/localhost:27017", ReasonChanged: "Heartbeat", State: "Disconnected", ServerVersion: , TopologyVersion: , Type: "Unknown", HeartbeatException: "MongoDB.Driver.MongoConnectionException: An exception occurred while opening a connection to the server.
 ---> System.Net.Sockets.SocketException (10061): No connection could be made because the target machine actively refused it. [::1]:27017
   at System.Net.Sockets.Socket.DoConnect(EndPoint endPointSnapshot, SocketAddress socketAddress)
   at System.Net.Sockets.Socket.Connect(EndPoint remoteEP)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.Connect(Socket socket, EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.CreateStream(EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   --- End of inner exception stack trace ---
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   at MongoDB.Driver.Core.Connections.BinaryConnection.Open(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.InitializeConnection(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.Heartbeat(CancellationToken cancellationToken)", LastHeartbeatTimestamp: "2026-02-19T22:41:15.7711989Z", LastUpdateTimestamp: "2026-02-19T22:41:15.7712015Z" }] }.
System.TimeoutException: A timeout occurred after 29998ms selecting a server using CompositeServerSelector{ Selectors = ReadPreferenceServerSelector{ ReadPreference = { Mode : Primary } }, LatencyLimitingServerSelector{ AllowedLatencyRange = 00:00:00.0150000 }, OperationsCountServerSelector }. Client view of cluster state is { ClusterId : "1", Type : "ReplicaSet", State : "Disconnected", Servers : [{ ServerId: "{ ClusterId : 1, EndPoint : "Unspecified/localhost:27017" }", EndPoint: "Unspecified/localhost:27017", ReasonChanged: "Heartbeat", State: "Disconnected", ServerVersion: , TopologyVersion: , Type: "Unknown", HeartbeatException: "MongoDB.Driver.MongoConnectionException: An exception occurred while opening a connection to the server.
 ---> System.Net.Sockets.SocketException (10061): No connection could be made because the target machine actively refused it. [::1]:27017
   at System.Net.Sockets.Socket.DoConnect(EndPoint endPointSnapshot, SocketAddress socketAddress)
   at System.Net.Sockets.Socket.Connect(EndPoint remoteEP)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.Connect(Socket socket, EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.CreateStream(EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   --- End of inner exception stack trace ---
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   at MongoDB.Driver.Core.Connections.BinaryConnection.Open(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.InitializeConnection(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.Heartbeat(CancellationToken cancellationToken)", LastHeartbeatTimestamp: "2026-02-19T22:41:15.7711989Z", LastUpdateTimestamp: "2026-02-19T22:41:15.7712015Z" }] }.
   at MongoDB.Driver.Core.Clusters.Cluster.SelectServer(OperationContext operationContext, IServerSelector selector)
   at MongoDB.Driver.Core.Clusters.IClusterExtensions.SelectServerAndPinIfNeeded(IClusterInternal cluster, OperationContext operationContext, ICoreSessionHandle session, IServerSelector selector, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Bindings.ReadPreferenceBinding.GetReadChannelSource(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Bindings.ReadBindingHandle.GetReadChannelSource(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Operations.RetryableReadContext.AcquireOrReplaceChannel(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Operations.RetryableReadContext.Create(OperationContext operationContext, IReadBinding binding, Boolean retryRequested)
   at MongoDB.Driver.Core.Operations.FindOperation`1.Execute(OperationContext operationContext, IReadBinding binding)
   at MongoDB.Driver.OperationExecutor.ExecuteReadOperation[TResult](OperationContext operationContext, IClientSessionHandle session, IReadOperation`1 operation, ReadPreference readPreference, Boolean allowChannelPinning)
   at MongoDB.Driver.MongoCollectionImpl`1.ExecuteReadOperation[TResult](IClientSessionHandle session, IReadOperation`1 operation, ReadPreference explicitReadPreference, Nullable`1 timeout, CancellationToken cancellationToken)
   at MongoDB.Driver.MongoCollectionImpl`1.ExecuteReadOperation[TResult](IClientSessionHandle session, IReadOperation`1 operation, Nullable`1 timeout, CancellationToken cancellationToken)
   at MongoDB.Driver.MongoCollectionImpl`1.FindSync[TProjection](IClientSessionHandle session, FilterDefinition`1 filter, FindOptions`2 options, CancellationToken cancellationToken)
   at MongoDB.Driver.MongoCollectionImpl`1.FindSync[TProjection](FilterDefinition`1 filter, FindOptions`2 options, CancellationToken cancellationToken)
   at MongoDB.Driver.FindFluent`2.ToCursor(CancellationToken cancellationToken)
   at MongoDB.Driver.IAsyncCursorSourceExtensions.FirstOrDefault[TDocument](IAsyncCursorSource`1 source, CancellationToken cancellationToken)
   at MongoDB.Driver.IFindFluentExtensions.FirstOrDefault[TDocument,TProjection](IFindFluent`2 find, CancellationToken cancellationToken)
   at P4NTH30N.C0MMON.Infrastructure.Persistence.Signals.GetNext() in c:\P4NTH30N\C0MMON\Infrastructure\Persistence\Repositories.cs:line 220
   at Program.Main(String[] args) in c:\P4NTH30N\H4ND\H4ND.cs:line 138
            .d8888b.     .d8888b.    888888888     .d8888b.  
           d88P  Y88b   d88P  Y88b   888          d88P  Y88b 
           888    888   Y88b. d88P   888          888        
888  888   888    888    "Y88888"    8888888b.    888d888b.  
888  888   888    888   .d8P""Y8b.        "Y88b   888P "Y88b 
Y88  88P   888    888   888    888          888   888    888 
 Y8bd8P    Y88b  d88Pd8bY88b  d88Pd8bY88b  d88Pd8bY88b  d88P 
  Y88P      "Y8888P" Y8P "Y8888P" Y8P "Y8888P" Y8P "Y8888P"  
                                                             
                                                             
                                                             

A timeout occurred after 29985ms selecting a server using CompositeServerSelector{ Selectors = ReadPreferenceServerSelector{ ReadPreference = { Mode : Primary } }, LatencyLimitingServerSelector{ AllowedLatencyRange = 00:00:00.0150000 }, OperationsCountServerSelector }. Client view of cluster state is { ClusterId : "1", Type : "ReplicaSet", State : "Disconnected", Servers : [{ ServerId: "{ ClusterId : 1, EndPoint : "Unspecified/localhost:27017" }", EndPoint: "Unspecified/localhost:27017", ReasonChanged: "Heartbeat", State: "Disconnected", ServerVersion: , TopologyVersion: , Type: "Unknown", HeartbeatException: "MongoDB.Driver.MongoConnectionException: An exception occurred while opening a connection to the server.
 ---> System.Net.Sockets.SocketException (10061): No connection could be made because the target machine actively refused it. [::1]:27017
   at System.Net.Sockets.Socket.DoConnect(EndPoint endPointSnapshot, SocketAddress socketAddress)
   at System.Net.Sockets.Socket.Connect(EndPoint remoteEP)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.Connect(Socket socket, EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.CreateStream(EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   --- End of inner exception stack trace ---
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   at MongoDB.Driver.Core.Connections.BinaryConnection.Open(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.InitializeConnection(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.Heartbeat(CancellationToken cancellationToken)", LastHeartbeatTimestamp: "2026-02-19T22:41:49.3482059Z", LastUpdateTimestamp: "2026-02-19T22:41:49.3482066Z" }] }.
System.TimeoutException: A timeout occurred after 29985ms selecting a server using CompositeServerSelector{ Selectors = ReadPreferenceServerSelector{ ReadPreference = { Mode : Primary } }, LatencyLimitingServerSelector{ AllowedLatencyRange = 00:00:00.0150000 }, OperationsCountServerSelector }. Client view of cluster state is { ClusterId : "1", Type : "ReplicaSet", State : "Disconnected", Servers : [{ ServerId: "{ ClusterId : 1, EndPoint : "Unspecified/localhost:27017" }", EndPoint: "Unspecified/localhost:27017", ReasonChanged: "Heartbeat", State: "Disconnected", ServerVersion: , TopologyVersion: , Type: "Unknown", HeartbeatException: "MongoDB.Driver.MongoConnectionException: An exception occurred while opening a connection to the server.
 ---> System.Net.Sockets.SocketException (10061): No connection could be made because the target machine actively refused it. [::1]:27017
   at System.Net.Sockets.Socket.DoConnect(EndPoint endPointSnapshot, SocketAddress socketAddress)
   at System.Net.Sockets.Socket.Connect(EndPoint remoteEP)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.Connect(Socket socket, EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.CreateStream(EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   --- End of inner exception stack trace ---
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   at MongoDB.Driver.Core.Connections.BinaryConnection.Open(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.InitializeConnection(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.Heartbeat(CancellationToken cancellationToken)", LastHeartbeatTimestamp: "2026-02-19T22:41:49.3482059Z", LastUpdateTimestamp: "2026-02-19T22:41:49.3482066Z" }] }.
   at MongoDB.Driver.Core.Clusters.Cluster.SelectServer(OperationContext operationContext, IServerSelector selector)
   at MongoDB.Driver.Core.Clusters.IClusterExtensions.SelectServerAndPinIfNeeded(IClusterInternal cluster, OperationContext operationContext, ICoreSessionHandle session, IServerSelector selector, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Bindings.ReadPreferenceBinding.GetReadChannelSource(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Bindings.ReadBindingHandle.GetReadChannelSource(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Operations.RetryableReadContext.AcquireOrReplaceChannel(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Operations.RetryableReadContext.Create(OperationContext operationContext, IReadBinding binding, Boolean retryRequested)
   at MongoDB.Driver.Core.Operations.FindOperation`1.Execute(OperationContext operationContext, IReadBinding binding)
   at MongoDB.Driver.OperationExecutor.ExecuteReadOperation[TResult](OperationContext operationContext, IClientSessionHandle session, IReadOperation`1 operation, ReadPreference readPreference, Boolean allowChannelPinning)
   at MongoDB.Driver.MongoCollectionImpl`1.ExecuteReadOperation[TResult](IClientSessionHandle session, IReadOperation`1 operation, ReadPreference explicitReadPreference, Nullable`1 timeout, CancellationToken cancellationToken)
   at MongoDB.Driver.MongoCollectionImpl`1.ExecuteReadOperation[TResult](IClientSessionHandle session, IReadOperation`1 operation, Nullable`1 timeout, CancellationToken cancellationToken)
   at MongoDB.Driver.MongoCollectionImpl`1.FindSync[TProjection](IClientSessionHandle session, FilterDefinition`1 filter, FindOptions`2 options, CancellationToken cancellationToken)
   at MongoDB.Driver.MongoCollectionImpl`1.FindSync[TProjection](FilterDefinition`1 filter, FindOptions`2 options, CancellationToken cancellationToken)
   at MongoDB.Driver.FindFluent`2.ToCursor(CancellationToken cancellationToken)
   at MongoDB.Driver.IAsyncCursorSourceExtensions.FirstOrDefault[TDocument](IAsyncCursorSource`1 source, CancellationToken cancellationToken)
   at MongoDB.Driver.IFindFluentExtensions.FirstOrDefault[TDocument,TProjection](IFindFluent`2 find, CancellationToken cancellationToken)
   at P4NTH30N.C0MMON.Infrastructure.Persistence.Signals.GetNext() in c:\P4NTH30N\C0MMON\Infrastructure\Persistence\Repositories.cs:line 220
   at Program.Main(String[] args) in c:\P4NTH30N\H4ND\H4ND.cs:line 138
            .d8888b.     .d8888b.    888888888     .d8888b.  
           d88P  Y88b   d88P  Y88b   888          d88P  Y88b 
           888    888   Y88b. d88P   888          888        
888  888   888    888    "Y88888"    8888888b.    888d888b.  
888  888   888    888   .d8P""Y8b.        "Y88b   888P "Y88b 
Y88  88P   888    888   888    888          888   888    888 
 Y8bd8P    Y88b  d88Pd8bY88b  d88Pd8bY88b  d88Pd8bY88b  d88P 
  Y88P      "Y8888P" Y8P "Y8888P" Y8P "Y8888P" Y8P "Y8888P"  
                                                             
                                                             
                                                             

A timeout occurred after 30014ms selecting a server using CompositeServerSelector{ Selectors = ReadPreferenceServerSelector{ ReadPreference = { Mode : Primary } }, LatencyLimitingServerSelector{ AllowedLatencyRange = 00:00:00.0150000 }, OperationsCountServerSelector }. Client view of cluster state is { ClusterId : "1", Type : "ReplicaSet", State : "Disconnected", Servers : [{ ServerId: "{ ClusterId : 1, EndPoint : "Unspecified/localhost:27017" }", EndPoint: "Unspecified/localhost:27017", ReasonChanged: "Heartbeat", State: "Disconnected", ServerVersion: , TopologyVersion: , Type: "Unknown", HeartbeatException: "MongoDB.Driver.MongoConnectionException: An exception occurred while opening a connection to the server.
 ---> System.Net.Sockets.SocketException (10061): No connection could be made because the target machine actively refused it. [::1]:27017
   at System.Net.Sockets.Socket.DoConnect(EndPoint endPointSnapshot, SocketAddress socketAddress)
   at System.Net.Sockets.Socket.Connect(EndPoint remoteEP)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.Connect(Socket socket, EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.CreateStream(EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   --- End of inner exception stack trace ---
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   at MongoDB.Driver.Core.Connections.BinaryConnection.Open(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.InitializeConnection(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.Heartbeat(CancellationToken cancellationToken)", LastHeartbeatTimestamp: "2026-02-19T22:42:25.6716942Z", LastUpdateTimestamp: "2026-02-19T22:42:25.6716946Z" }] }.
System.TimeoutException: A timeout occurred after 30014ms selecting a server using CompositeServerSelector{ Selectors = ReadPreferenceServerSelector{ ReadPreference = { Mode : Primary } }, LatencyLimitingServerSelector{ AllowedLatencyRange = 00:00:00.0150000 }, OperationsCountServerSelector }. Client view of cluster state is { ClusterId : "1", Type : "ReplicaSet", State : "Disconnected", Servers : [{ ServerId: "{ ClusterId : 1, EndPoint : "Unspecified/localhost:27017" }", EndPoint: "Unspecified/localhost:27017", ReasonChanged: "Heartbeat", State: "Disconnected", ServerVersion: , TopologyVersion: , Type: "Unknown", HeartbeatException: "MongoDB.Driver.MongoConnectionException: An exception occurred while opening a connection to the server.
 ---> System.Net.Sockets.SocketException (10061): No connection could be made because the target machine actively refused it. [::1]:27017
   at System.Net.Sockets.Socket.DoConnect(EndPoint endPointSnapshot, SocketAddress socketAddress)
   at System.Net.Sockets.Socket.Connect(EndPoint remoteEP)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.Connect(Socket socket, EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.CreateStream(EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   --- End of inner exception stack trace ---
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   at MongoDB.Driver.Core.Connections.BinaryConnection.Open(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.InitializeConnection(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.Heartbeat(CancellationToken cancellationToken)", LastHeartbeatTimestamp: "2026-02-19T22:42:25.6716942Z", LastUpdateTimestamp: "2026-02-19T22:42:25.6716946Z" }] }.
   at MongoDB.Driver.Core.Clusters.Cluster.SelectServer(OperationContext operationContext, IServerSelector selector)
   at MongoDB.Driver.Core.Clusters.IClusterExtensions.SelectServerAndPinIfNeeded(IClusterInternal cluster, OperationContext operationContext, ICoreSessionHandle session, IServerSelector selector, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Bindings.ReadPreferenceBinding.GetReadChannelSource(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Bindings.ReadBindingHandle.GetReadChannelSource(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Operations.RetryableReadContext.AcquireOrReplaceChannel(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Operations.RetryableReadContext.Create(OperationContext operationContext, IReadBinding binding, Boolean retryRequested)
   at MongoDB.Driver.Core.Operations.FindOperation`1.Execute(OperationContext operationContext, IReadBinding binding)
   at MongoDB.Driver.OperationExecutor.ExecuteReadOperation[TResult](OperationContext operationContext, IClientSessionHandle session, IReadOperation`1 operation, ReadPreference readPreference, Boolean allowChannelPinning)
   at MongoDB.Driver.MongoCollectionImpl`1.ExecuteReadOperation[TResult](IClientSessionHandle session, IReadOperation`1 operation, ReadPreference explicitReadPreference, Nullable`1 timeout, CancellationToken cancellationToken)
   at MongoDB.Driver.MongoCollectionImpl`1.ExecuteReadOperation[TResult](IClientSessionHandle session, IReadOperation`1 operation, Nullable`1 timeout, CancellationToken cancellationToken)
   at MongoDB.Driver.MongoCollectionImpl`1.FindSync[TProjection](IClientSessionHandle session, FilterDefinition`1 filter, FindOptions`2 options, CancellationToken cancellationToken)
   at MongoDB.Driver.MongoCollectionImpl`1.FindSync[TProjection](FilterDefinition`1 filter, FindOptions`2 options, CancellationToken cancellationToken)
   at MongoDB.Driver.FindFluent`2.ToCursor(CancellationToken cancellationToken)
   at MongoDB.Driver.IAsyncCursorSourceExtensions.FirstOrDefault[TDocument](IAsyncCursorSource`1 source, CancellationToken cancellationToken)
   at MongoDB.Driver.IFindFluentExtensions.FirstOrDefault[TDocument,TProjection](IFindFluent`2 find, CancellationToken cancellationToken)
   at P4NTH30N.C0MMON.Infrastructure.Persistence.Signals.GetNext() in c:\P4NTH30N\C0MMON\Infrastructure\Persistence\Repositories.cs:line 220
   at Program.Main(String[] args) in c:\P4NTH30N\H4ND\H4ND.cs:line 138
            .d8888b.     .d8888b.    888888888     .d8888b.  
           d88P  Y88b   d88P  Y88b   888          d88P  Y88b 
           888    888   Y88b. d88P   888          888        
888  888   888    888    "Y88888"    8888888b.    888d888b.  
888  888   888    888   .d8P""Y8b.        "Y88b   888P "Y88b 
Y88  88P   888    888   888    888          888   888    888 
 Y8bd8P    Y88b  d88Pd8bY88b  d88Pd8bY88b  d88Pd8bY88b  d88P 
  Y88P      "Y8888P" Y8P "Y8888P" Y8P "Y8888P" Y8P "Y8888P"  
                                                             
                                                             
                                                             

A timeout occurred after 29999ms selecting a server using CompositeServerSelector{ Selectors = ReadPreferenceServerSelector{ ReadPreference = { Mode : Primary } }, LatencyLimitingServerSelector{ AllowedLatencyRange = 00:00:00.0150000 }, OperationsCountServerSelector }. Client view of cluster state is { ClusterId : "1", Type : "ReplicaSet", State : "Disconnected", Servers : [{ ServerId: "{ ClusterId : 1, EndPoint : "Unspecified/localhost:27017" }", EndPoint: "Unspecified/localhost:27017", ReasonChanged: "Heartbeat", State: "Disconnected", ServerVersion: , TopologyVersion: , Type: "Unknown", HeartbeatException: "MongoDB.Driver.MongoConnectionException: An exception occurred while opening a connection to the server.
 ---> System.Net.Sockets.SocketException (10061): No connection could be made because the target machine actively refused it. [::1]:27017
   at System.Net.Sockets.Socket.DoConnect(EndPoint endPointSnapshot, SocketAddress socketAddress)
   at System.Net.Sockets.Socket.Connect(EndPoint remoteEP)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.Connect(Socket socket, EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.CreateStream(EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   --- End of inner exception stack trace ---
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   at MongoDB.Driver.Core.Connections.BinaryConnection.Open(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.InitializeConnection(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.Heartbeat(CancellationToken cancellationToken)", LastHeartbeatTimestamp: "2026-02-19T22:42:59.3473036Z", LastUpdateTimestamp: "2026-02-19T22:42:59.3473048Z" }] }.
System.TimeoutException: A timeout occurred after 29999ms selecting a server using CompositeServerSelector{ Selectors = ReadPreferenceServerSelector{ ReadPreference = { Mode : Primary } }, LatencyLimitingServerSelector{ AllowedLatencyRange = 00:00:00.0150000 }, OperationsCountServerSelector }. Client view of cluster state is { ClusterId : "1", Type : "ReplicaSet", State : "Disconnected", Servers : [{ ServerId: "{ ClusterId : 1, EndPoint : "Unspecified/localhost:27017" }", EndPoint: "Unspecified/localhost:27017", ReasonChanged: "Heartbeat", State: "Disconnected", ServerVersion: , TopologyVersion: , Type: "Unknown", HeartbeatException: "MongoDB.Driver.MongoConnectionException: An exception occurred while opening a connection to the server.
 ---> System.Net.Sockets.SocketException (10061): No connection could be made because the target machine actively refused it. [::1]:27017
   at System.Net.Sockets.Socket.DoConnect(EndPoint endPointSnapshot, SocketAddress socketAddress)
   at System.Net.Sockets.Socket.Connect(EndPoint remoteEP)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.Connect(Socket socket, EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.CreateStream(EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   --- End of inner exception stack trace ---
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   at MongoDB.Driver.Core.Connections.BinaryConnection.Open(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.InitializeConnection(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.Heartbeat(CancellationToken cancellationToken)", LastHeartbeatTimestamp: "2026-02-19T22:42:59.3473036Z", LastUpdateTimestamp: "2026-02-19T22:42:59.3473048Z" }] }.
   at MongoDB.Driver.Core.Clusters.Cluster.SelectServer(OperationContext operationContext, IServerSelector selector)
   at MongoDB.Driver.Core.Clusters.IClusterExtensions.SelectServerAndPinIfNeeded(IClusterInternal cluster, OperationContext operationContext, ICoreSessionHandle session, IServerSelector selector, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Bindings.ReadPreferenceBinding.GetReadChannelSource(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Bindings.ReadBindingHandle.GetReadChannelSource(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Operations.RetryableReadContext.AcquireOrReplaceChannel(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Operations.RetryableReadContext.Create(OperationContext operationContext, IReadBinding binding, Boolean retryRequested)
   at MongoDB.Driver.Core.Operations.FindOperation`1.Execute(OperationContext operationContext, IReadBinding binding)
   at MongoDB.Driver.OperationExecutor.ExecuteReadOperation[TResult](OperationContext operationContext, IClientSessionHandle session, IReadOperation`1 operation, ReadPreference readPreference, Boolean allowChannelPinning)
   at MongoDB.Driver.MongoCollectionImpl`1.ExecuteReadOperation[TResult](IClientSessionHandle session, IReadOperation`1 operation, ReadPreference explicitReadPreference, Nullable`1 timeout, CancellationToken cancellationToken)
   at MongoDB.Driver.MongoCollectionImpl`1.ExecuteReadOperation[TResult](IClientSessionHandle session, IReadOperation`1 operation, Nullable`1 timeout, CancellationToken cancellationToken)
   at MongoDB.Driver.MongoCollectionImpl`1.FindSync[TProjection](IClientSessionHandle session, FilterDefinition`1 filter, FindOptions`2 options, CancellationToken cancellationToken)
   at MongoDB.Driver.MongoCollectionImpl`1.FindSync[TProjection](FilterDefinition`1 filter, FindOptions`2 options, CancellationToken cancellationToken)
   at MongoDB.Driver.FindFluent`2.ToCursor(CancellationToken cancellationToken)
   at MongoDB.Driver.IAsyncCursorSourceExtensions.FirstOrDefault[TDocument](IAsyncCursorSource`1 source, CancellationToken cancellationToken)
   at MongoDB.Driver.IFindFluentExtensions.FirstOrDefault[TDocument,TProjection](IFindFluent`2 find, CancellationToken cancellationToken)
   at P4NTH30N.C0MMON.Infrastructure.Persistence.Signals.GetNext() in c:\P4NTH30N\C0MMON\Infrastructure\Persistence\Repositories.cs:line 220
   at Program.Main(String[] args) in c:\P4NTH30N\H4ND\H4ND.cs:line 138
            .d8888b.     .d8888b.    888888888     .d8888b.  
           d88P  Y88b   d88P  Y88b   888          d88P  Y88b 
           888    888   Y88b. d88P   888          888        
888  888   888    888    "Y88888"    8888888b.    888d888b.  
888  888   888    888   .d8P""Y8b.        "Y88b   888P "Y88b 
Y88  88P   888    888   888    888          888   888    888 
 Y8bd8P    Y88b  d88Pd8bY88b  d88Pd8bY88b  d88Pd8bY88b  d88P 
  Y88P      "Y8888P" Y8P "Y8888P" Y8P "Y8888P" Y8P "Y8888P"  
                                                             
                                                             
                                                             

A timeout occurred after 30000ms selecting a server using CompositeServerSelector{ Selectors = ReadPreferenceServerSelector{ ReadPreference = { Mode : Primary } }, LatencyLimitingServerSelector{ AllowedLatencyRange = 00:00:00.0150000 }, OperationsCountServerSelector }. Client view of cluster state is { ClusterId : "1", Type : "ReplicaSet", State : "Disconnected", Servers : [{ ServerId: "{ ClusterId : 1, EndPoint : "Unspecified/localhost:27017" }", EndPoint: "Unspecified/localhost:27017", ReasonChanged: "Heartbeat", State: "Disconnected", ServerVersion: , TopologyVersion: , Type: "Unknown", HeartbeatException: "MongoDB.Driver.MongoConnectionException: An exception occurred while opening a connection to the server.
 ---> System.Net.Sockets.SocketException (10061): No connection could be made because the target machine actively refused it. [::1]:27017
   at System.Net.Sockets.Socket.DoConnect(EndPoint endPointSnapshot, SocketAddress socketAddress)
   at System.Net.Sockets.Socket.Connect(EndPoint remoteEP)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.Connect(Socket socket, EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.CreateStream(EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   --- End of inner exception stack trace ---
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   at MongoDB.Driver.Core.Connections.BinaryConnection.Open(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.InitializeConnection(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.Heartbeat(CancellationToken cancellationToken)", LastHeartbeatTimestamp: "2026-02-19T22:43:35.6068949Z", LastUpdateTimestamp: "2026-02-19T22:43:35.6068951Z" }] }.
System.TimeoutException: A timeout occurred after 30000ms selecting a server using CompositeServerSelector{ Selectors = ReadPreferenceServerSelector{ ReadPreference = { Mode : Primary } }, LatencyLimitingServerSelector{ AllowedLatencyRange = 00:00:00.0150000 }, OperationsCountServerSelector }. Client view of cluster state is { ClusterId : "1", Type : "ReplicaSet", State : "Disconnected", Servers : [{ ServerId: "{ ClusterId : 1, EndPoint : "Unspecified/localhost:27017" }", EndPoint: "Unspecified/localhost:27017", ReasonChanged: "Heartbeat", State: "Disconnected", ServerVersion: , TopologyVersion: , Type: "Unknown", HeartbeatException: "MongoDB.Driver.MongoConnectionException: An exception occurred while opening a connection to the server.
 ---> System.Net.Sockets.SocketException (10061): No connection could be made because the target machine actively refused it. [::1]:27017
   at System.Net.Sockets.Socket.DoConnect(EndPoint endPointSnapshot, SocketAddress socketAddress)
   at System.Net.Sockets.Socket.Connect(EndPoint remoteEP)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.Connect(Socket socket, EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.CreateStream(EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   --- End of inner exception stack trace ---
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   at MongoDB.Driver.Core.Connections.BinaryConnection.Open(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.InitializeConnection(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.Heartbeat(CancellationToken cancellationToken)", LastHeartbeatTimestamp: "2026-02-19T22:43:35.6068949Z", LastUpdateTimestamp: "2026-02-19T22:43:35.6068951Z" }] }.
   at MongoDB.Driver.Core.Clusters.Cluster.SelectServer(OperationContext operationContext, IServerSelector selector)
   at MongoDB.Driver.Core.Clusters.IClusterExtensions.SelectServerAndPinIfNeeded(IClusterInternal cluster, OperationContext operationContext, ICoreSessionHandle session, IServerSelector selector, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Bindings.ReadPreferenceBinding.GetReadChannelSource(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Bindings.ReadBindingHandle.GetReadChannelSource(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Operations.RetryableReadContext.AcquireOrReplaceChannel(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Operations.RetryableReadContext.Create(OperationContext operationContext, IReadBinding binding, Boolean retryRequested)
   at MongoDB.Driver.Core.Operations.FindOperation`1.Execute(OperationContext operationContext, IReadBinding binding)
   at MongoDB.Driver.OperationExecutor.ExecuteReadOperation[TResult](OperationContext operationContext, IClientSessionHandle session, IReadOperation`1 operation, ReadPreference readPreference, Boolean allowChannelPinning)
   at MongoDB.Driver.MongoCollectionImpl`1.ExecuteReadOperation[TResult](IClientSessionHandle session, IReadOperation`1 operation, ReadPreference explicitReadPreference, Nullable`1 timeout, CancellationToken cancellationToken)
   at MongoDB.Driver.MongoCollectionImpl`1.ExecuteReadOperation[TResult](IClientSessionHandle session, IReadOperation`1 operation, Nullable`1 timeout, CancellationToken cancellationToken)
   at MongoDB.Driver.MongoCollectionImpl`1.FindSync[TProjection](IClientSessionHandle session, FilterDefinition`1 filter, FindOptions`2 options, CancellationToken cancellationToken)
   at MongoDB.Driver.MongoCollectionImpl`1.FindSync[TProjection](FilterDefinition`1 filter, FindOptions`2 options, CancellationToken cancellationToken)
   at MongoDB.Driver.FindFluent`2.ToCursor(CancellationToken cancellationToken)
   at MongoDB.Driver.IAsyncCursorSourceExtensions.FirstOrDefault[TDocument](IAsyncCursorSource`1 source, CancellationToken cancellationToken)
   at MongoDB.Driver.IFindFluentExtensions.FirstOrDefault[TDocument,TProjection](IFindFluent`2 find, CancellationToken cancellationToken)
   at P4NTH30N.C0MMON.Infrastructure.Persistence.Signals.GetNext() in c:\P4NTH30N\C0MMON\Infrastructure\Persistence\Repositories.cs:line 220
   at Program.Main(String[] args) in c:\P4NTH30N\H4ND\H4ND.cs:line 138
            .d8888b.     .d8888b.    888888888     .d8888b.  
           d88P  Y88b   d88P  Y88b   888          d88P  Y88b 
           888    888   Y88b. d88P   888          888        
888  888   888    888    "Y88888"    8888888b.    888d888b.  
888  888   888    888   .d8P""Y8b.        "Y88b   888P "Y88b 
Y88  88P   888    888   888    888          888   888    888 
 Y8bd8P    Y88b  d88Pd8bY88b  d88Pd8bY88b  d88Pd8bY88b  d88P 
  Y88P      "Y8888P" Y8P "Y8888P" Y8P "Y8888P" Y8P "Y8888P"  
                                                             
                                                             
                                                             

A timeout occurred after 30004ms selecting a server using CompositeServerSelector{ Selectors = ReadPreferenceServerSelector{ ReadPreference = { Mode : Primary } }, LatencyLimitingServerSelector{ AllowedLatencyRange = 00:00:00.0150000 }, OperationsCountServerSelector }. Client view of cluster state is { ClusterId : "1", Type : "ReplicaSet", State : "Disconnected", Servers : [{ ServerId: "{ ClusterId : 1, EndPoint : "Unspecified/localhost:27017" }", EndPoint: "Unspecified/localhost:27017", ReasonChanged: "Heartbeat", State: "Disconnected", ServerVersion: , TopologyVersion: , Type: "Unknown", HeartbeatException: "MongoDB.Driver.MongoConnectionException: An exception occurred while opening a connection to the server.
 ---> System.Net.Sockets.SocketException (10061): No connection could be made because the target machine actively refused it. [::1]:27017
   at System.Net.Sockets.Socket.DoConnect(EndPoint endPointSnapshot, SocketAddress socketAddress)
   at System.Net.Sockets.Socket.Connect(EndPoint remoteEP)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.Connect(Socket socket, EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.CreateStream(EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   --- End of inner exception stack trace ---
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   at MongoDB.Driver.Core.Connections.BinaryConnection.Open(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.InitializeConnection(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.Heartbeat(CancellationToken cancellationToken)", LastHeartbeatTimestamp: "2026-02-19T22:44:09.4170835Z", LastUpdateTimestamp: "2026-02-19T22:44:09.4170836Z" }] }.
System.TimeoutException: A timeout occurred after 30004ms selecting a server using CompositeServerSelector{ Selectors = ReadPreferenceServerSelector{ ReadPreference = { Mode : Primary } }, LatencyLimitingServerSelector{ AllowedLatencyRange = 00:00:00.0150000 }, OperationsCountServerSelector }. Client view of cluster state is { ClusterId : "1", Type : "ReplicaSet", State : "Disconnected", Servers : [{ ServerId: "{ ClusterId : 1, EndPoint : "Unspecified/localhost:27017" }", EndPoint: "Unspecified/localhost:27017", ReasonChanged: "Heartbeat", State: "Disconnected", ServerVersion: , TopologyVersion: , Type: "Unknown", HeartbeatException: "MongoDB.Driver.MongoConnectionException: An exception occurred while opening a connection to the server.
 ---> System.Net.Sockets.SocketException (10061): No connection could be made because the target machine actively refused it. [::1]:27017
   at System.Net.Sockets.Socket.DoConnect(EndPoint endPointSnapshot, SocketAddress socketAddress)
   at System.Net.Sockets.Socket.Connect(EndPoint remoteEP)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.Connect(Socket socket, EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.CreateStream(EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   --- End of inner exception stack trace ---
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   at MongoDB.Driver.Core.Connections.BinaryConnection.Open(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.InitializeConnection(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.Heartbeat(CancellationToken cancellationToken)", LastHeartbeatTimestamp: "2026-02-19T22:44:09.4170835Z", LastUpdateTimestamp: "2026-02-19T22:44:09.4170836Z" }] }.
   at MongoDB.Driver.Core.Clusters.Cluster.SelectServer(OperationContext operationContext, IServerSelector selector)
   at MongoDB.Driver.Core.Clusters.IClusterExtensions.SelectServerAndPinIfNeeded(IClusterInternal cluster, OperationContext operationContext, ICoreSessionHandle session, IServerSelector selector, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Bindings.ReadPreferenceBinding.GetReadChannelSource(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Bindings.ReadBindingHandle.GetReadChannelSource(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Operations.RetryableReadContext.AcquireOrReplaceChannel(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Operations.RetryableReadContext.Create(OperationContext operationContext, IReadBinding binding, Boolean retryRequested)
   at MongoDB.Driver.Core.Operations.FindOperation`1.Execute(OperationContext operationContext, IReadBinding binding)
   at MongoDB.Driver.OperationExecutor.ExecuteReadOperation[TResult](OperationContext operationContext, IClientSessionHandle session, IReadOperation`1 operation, ReadPreference readPreference, Boolean allowChannelPinning)
   at MongoDB.Driver.MongoCollectionImpl`1.ExecuteReadOperation[TResult](IClientSessionHandle session, IReadOperation`1 operation, ReadPreference explicitReadPreference, Nullable`1 timeout, CancellationToken cancellationToken)
   at MongoDB.Driver.MongoCollectionImpl`1.ExecuteReadOperation[TResult](IClientSessionHandle session, IReadOperation`1 operation, Nullable`1 timeout, CancellationToken cancellationToken)
   at MongoDB.Driver.MongoCollectionImpl`1.FindSync[TProjection](IClientSessionHandle session, FilterDefinition`1 filter, FindOptions`2 options, CancellationToken cancellationToken)
   at MongoDB.Driver.MongoCollectionImpl`1.FindSync[TProjection](FilterDefinition`1 filter, FindOptions`2 options, CancellationToken cancellationToken)
   at MongoDB.Driver.FindFluent`2.ToCursor(CancellationToken cancellationToken)
   at MongoDB.Driver.IAsyncCursorSourceExtensions.FirstOrDefault[TDocument](IAsyncCursorSource`1 source, CancellationToken cancellationToken)
   at MongoDB.Driver.IFindFluentExtensions.FirstOrDefault[TDocument,TProjection](IFindFluent`2 find, CancellationToken cancellationToken)
   at P4NTH30N.C0MMON.Infrastructure.Persistence.Signals.GetNext() in c:\P4NTH30N\C0MMON\Infrastructure\Persistence\Repositories.cs:line 220
   at Program.Main(String[] args) in c:\P4NTH30N\H4ND\H4ND.cs:line 138
            .d8888b.     .d8888b.    888888888     .d8888b.  
           d88P  Y88b   d88P  Y88b   888          d88P  Y88b 
           888    888   Y88b. d88P   888          888        
888  888   888    888    "Y88888"    8888888b.    888d888b.  
888  888   888    888   .d8P""Y8b.        "Y88b   888P "Y88b 
Y88  88P   888    888   888    888          888   888    888 
 Y8bd8P    Y88b  d88Pd8bY88b  d88Pd8bY88b  d88Pd8bY88b  d88P 
  Y88P      "Y8888P" Y8P "Y8888P" Y8P "Y8888P" Y8P "Y8888P"  
                                                             
                                                             
                                                             

A timeout occurred after 30004ms selecting a server using CompositeServerSelector{ Selectors = ReadPreferenceServerSelector{ ReadPreference = { Mode : Primary } }, LatencyLimitingServerSelector{ AllowedLatencyRange = 00:00:00.0150000 }, OperationsCountServerSelector }. Client view of cluster state is { ClusterId : "1", Type : "ReplicaSet", State : "Disconnected", Servers : [{ ServerId: "{ ClusterId : 1, EndPoint : "Unspecified/localhost:27017" }", EndPoint: "Unspecified/localhost:27017", ReasonChanged: "Heartbeat", State: "Disconnected", ServerVersion: , TopologyVersion: , Type: "Unknown", HeartbeatException: "MongoDB.Driver.MongoConnectionException: An exception occurred while opening a connection to the server.
 ---> System.Net.Sockets.SocketException (10061): No connection could be made because the target machine actively refused it. [::1]:27017
   at System.Net.Sockets.Socket.DoConnect(EndPoint endPointSnapshot, SocketAddress socketAddress)
   at System.Net.Sockets.Socket.Connect(EndPoint remoteEP)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.Connect(Socket socket, EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.CreateStream(EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   --- End of inner exception stack trace ---
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   at MongoDB.Driver.Core.Connections.BinaryConnection.Open(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.InitializeConnection(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.Heartbeat(CancellationToken cancellationToken)", LastHeartbeatTimestamp: "2026-02-19T22:44:45.6730343Z", LastUpdateTimestamp: "2026-02-19T22:44:45.6730345Z" }] }.
System.TimeoutException: A timeout occurred after 30004ms selecting a server using CompositeServerSelector{ Selectors = ReadPreferenceServerSelector{ ReadPreference = { Mode : Primary } }, LatencyLimitingServerSelector{ AllowedLatencyRange = 00:00:00.0150000 }, OperationsCountServerSelector }. Client view of cluster state is { ClusterId : "1", Type : "ReplicaSet", State : "Disconnected", Servers : [{ ServerId: "{ ClusterId : 1, EndPoint : "Unspecified/localhost:27017" }", EndPoint: "Unspecified/localhost:27017", ReasonChanged: "Heartbeat", State: "Disconnected", ServerVersion: , TopologyVersion: , Type: "Unknown", HeartbeatException: "MongoDB.Driver.MongoConnectionException: An exception occurred while opening a connection to the server.
 ---> System.Net.Sockets.SocketException (10061): No connection could be made because the target machine actively refused it. [::1]:27017
   at System.Net.Sockets.Socket.DoConnect(EndPoint endPointSnapshot, SocketAddress socketAddress)
   at System.Net.Sockets.Socket.Connect(EndPoint remoteEP)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.Connect(Socket socket, EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.TcpStreamFactory.CreateStream(EndPoint endPoint, CancellationToken cancellationToken)
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   --- End of inner exception stack trace ---
   at MongoDB.Driver.Core.Connections.BinaryConnection.OpenHelper(OperationContext operationContext)
   at MongoDB.Driver.Core.Connections.BinaryConnection.Open(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.InitializeConnection(OperationContext operationContext)
   at MongoDB.Driver.Core.Servers.ServerMonitor.Heartbeat(CancellationToken cancellationToken)", LastHeartbeatTimestamp: "2026-02-19T22:44:45.6730343Z", LastUpdateTimestamp: "2026-02-19T22:44:45.6730345Z" }] }.
   at MongoDB.Driver.Core.Clusters.Cluster.SelectServer(OperationContext operationContext, IServerSelector selector)
   at MongoDB.Driver.Core.Clusters.IClusterExtensions.SelectServerAndPinIfNeeded(IClusterInternal cluster, OperationContext operationContext, ICoreSessionHandle session, IServerSelector selector, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Bindings.ReadPreferenceBinding.GetReadChannelSource(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Bindings.ReadBindingHandle.GetReadChannelSource(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Operations.RetryableReadContext.AcquireOrReplaceChannel(OperationContext operationContext, IReadOnlyCollection`1 deprioritizedServers)
   at MongoDB.Driver.Core.Operations.RetryableReadContext.Create(OperationContext operationContext, IReadBinding binding, B

... (truncated)
```
