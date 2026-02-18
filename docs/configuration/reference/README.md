# Configuration Reference

Complete reference for all configuration options in P4NTH30N.

## Overview

P4NTH30N uses a layered configuration system:

```
Environment Variables (highest priority)
    ↓
appsettings.Production.json (gitignored)
    ↓
appsettings.Staging.json (gitignored)
    ↓
appsettings.Development.json (committed)
    ↓
appsettings.json (base defaults, committed)
```

## Configuration Files

### appsettings.json (Base)

```json
{
  "P4NTH30N": {
    "Environment": "Development",
    "Version": "2.0.0"
  },
  "MongoDB": {
    "ConnectionString": "mongodb://localhost:27017/P4NTH30N",
    "DatabaseName": "P4NTH30N",
    "MaxConnectionPoolSize": 100,
    "ServerSelectionTimeoutMs": 5000
  },
  "H0UND": {
    "Polling": {
      "IntervalSeconds": 30,
      "RetryAttempts": 3,
      "TimeoutSeconds": 10,
      "JitterMs": 500
    },
    "Analytics": {
      "IntervalSeconds": 10,
      "DpdMinimumPoints": 25,
      "DpdHighThreshold": 10.0
    },
    "Dashboard": {
      "Enabled": true,
      "RefreshRateMs": 1000,
      "ShowDetails": true
    }
  },
  "H4ND": {
    "Automation": {
      "PollIntervalSeconds": 5,
      "SpinTimeoutSeconds": 30,
      "RetryAttempts": 3,
      "GrandCheckRetries": 40,
      "GrandCheckIntervalMs": 500
    },
    "Browser": {
      "Headless": false,
      "ExtensionPath": "RUL3S/auto-override",
      "UserDataDir": "./chrome-data",
      "WindowWidth": 1920,
      "WindowHeight": 1080
    },
    "Safety": {
      "HealthCheckIntervalMinutes": 5,
      "MaxConsecutiveErrors": 10
    }
  },
  "W4TCHD0G": {
    "Vision": {
      "FrameRate": 2,
      "FrameWidth": 1280,
      "FrameHeight": 720,
      "BufferSize": 10,
      "SourceName": "Game Capture"
    },
    "OBS": {
      "WebSocketUrl": "ws://localhost:4455",
      "Password": null,
      "ReconnectionPolicy": {
        "MaxRetries": 5,
        "BaseDelayMs": 1000,
        "MaxDelayMs": 30000,
        "BackoffMultiplier": 2.0
      }
    },
    "RTMP": {
      "ServerUrl": "rtmp://localhost:1935/live",
      "StreamKey": "foureyes",
      "BufferTimeMs": 1000
    },
    "Safety": {
      "DailySpendLimit": 1000.00,
      "ConsecutiveLossLimit": 10,
      "KillSwitchCode": "CONFIRM-RESUME-P4NTH30N"
    },
    "Alerts": {
      "Console": true,
      "File": true,
      "FilePath": "win-events.log",
      "Webhook": {
        "Enabled": false,
        "Url": null,
        "TimeoutMs": 5000
      }
    }
  },
  "Security": {
    "MasterKeyPath": "C:\\ProgramData\\P4NTH30N\\master.key",
    "Encryption": {
      "Algorithm": "AES-256-GCM",
      "KeyRotationDays": 365
    }
  },
  "Caching": {
    "Enabled": true,
    "DefaultExpirationMinutes": 5,
    "MaxSizeMB": 100
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft": "Warning",
      "P4NTH30N": "Debug"
    },
    "File": {
      "Enabled": true,
      "Path": "logs/p4nth30n.log",
      "RollingInterval": "Day",
      "RetainedFileCountLimit": 7
    }
  }
}
```

## Environment Variables

### Core Settings

| Variable | Description | Default |
|----------|-------------|---------|
| `P4NTH30N_ENVIRONMENT` | Active environment | `Development` |
| `P4NTH30N_MONGODB_URI` | MongoDB connection string | `mongodb://localhost:27017/P4NTH30N` |
| `P4NTH30N_MONGODB_DB` | MongoDB database name | `P4NTH30N` |
| `P4NTH30N_VERSION` | Application version | `2.0.0` |

### Security

| Variable | Description | Default |
|----------|-------------|---------|
| `P4NTH30N_SECURITY_MASTERKEYPATH` | Master encryption key path | `C:\ProgramData\P4NTH30N\master.key` |
| `P4NTH30N_SECURITY_KEY_ROTATION_DAYS` | Days between key rotation | `365` |

### H0UND Settings

| Variable | Description | Default |
|----------|-------------|---------|
| `P4NTH30N_H0UND_POLLING_INTERVAL_SECONDS` | Polling interval | `30` |
| `P4NTH30N_H0UND_POLLING_RETRY_ATTEMPTS` | API retry attempts | `3` |
| `P4NTH30N_H0UND_ANALYTICS_INTERVAL_SECONDS` | Analytics run interval | `10` |
| `P4NTH30N_H0UND_DPD_MINIMUM_POINTS` | Min data points for DPD | `25` |
| `P4NTH30N_H0UND_DASHBOARD_ENABLED` | Enable dashboard | `true` |

### H4ND Settings

| Variable | Description | Default |
|----------|-------------|---------|
| `P4NTH30N_H4ND_POLL_INTERVAL_SECONDS` | Signal poll interval | `5` |
| `P4NTH30N_H4ND_SPIN_TIMEOUT_SECONDS` | Max spin duration | `30` |
| `P4NTH30N_H4ND_BROWSER_HEADLESS` | Run Chrome headless | `false` |
| `P4NTH30N_H4ND_SAFETY_HEALTH_CHECK_MINUTES` | Health check interval | `5` |

### W4TCHD0G Settings

| Variable | Description | Default |
|----------|-------------|---------|
| `P4NTH30N_W4TCHD0G_OBS_WEBSOCKET_URL` | OBS WebSocket URL | `ws://localhost:4455` |
| `P4NTH30N_W4TCHD0G_FRAME_RATE` | Vision frame rate (FPS) | `2` |
| `P4NTH30N_W4TCHD0G_RTMPSERVER` | RTMP server URL | `rtmp://localhost:1935/live` |
| `P4NTH30N_SAFETY_DAILY_SPEND_LIMIT` | Daily spend limit (USD) | `1000` |
| `P4NTH30N_SAFETY_CONSECUTIVE_LOSS_LIMIT` | Max consecutive losses | `10` |
| `P4NTH30N_SAFETY_KILL_SWITCH_CODE` | Kill switch override code | *(required)* |

### Caching

| Variable | Description | Default |
|----------|-------------|---------|
| `P4NTH30N_CACHING_ENABLED` | Enable caching | `true` |
| `P4NTH30N_CACHING_DEFAULT_EXPIRATION_MINUTES` | Default cache TTL | `5` |

### Logging

| Variable | Description | Default |
|----------|-------------|---------|
| `P4NTH30N_LOGGING_LOGLEVEL_DEFAULT` | Default log level | `Information` |
| `P4NTH30N_LOGGING_FILE_ENABLED` | Enable file logging | `true` |

## Configuration by Environment

### Development (appsettings.Development.json)

```json
{
  "P4NTH30N": {
    "Environment": "Development"
  },
  "MongoDB": {
    "ConnectionString": "mongodb://localhost:27017/P4NTH30N_Dev"
  },
  "H4ND": {
    "Browser": {
      "Headless": false
    }
  },
  "Logging": {
    "LogLevel": {
      "Default": "Debug",
      "P4NTH30N": "Debug"
    }
  }
}
```

### Production (appsettings.Production.json)

```json
{
  "P4NTH30N": {
    "Environment": "Production"
  },
  "MongoDB": {
    "ConnectionString": "mongodb://prod-server:27017/P4NTH30N",
    "MaxConnectionPoolSize": 200
  },
  "H4ND": {
    "Browser": {
      "Headless": true
    },
    "Safety": {
      "HealthCheckIntervalMinutes": 2
    }
  },
  "W4TCHD0G": {
    "Alerts": {
      "Webhook": {
        "Enabled": true,
        "Url": "https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
      }
    }
  },
  "Logging": {
    "LogLevel": {
      "Default": "Warning",
      "P4NTH30N": "Information"
    }
  }
}
```

## Configuration Sections

### MongoDB Configuration

```csharp
public class MongoDBOptions
{
    public string ConnectionString { get; set; } = "mongodb://localhost:27017/P4NTH30N";
    public string DatabaseName { get; set; } = "P4NTH30N";
    public int MaxConnectionPoolSize { get; set; } = 100;
    public int ServerSelectionTimeoutMs { get; set; } = 5000;
    public int SocketTimeoutMs { get; set; } = 30000;
    public int ConnectTimeoutMs { get; set; } = 10000;
    public bool RetryWrites { get; set; } = true;
    public int MaxRetryAttempts { get; set; } = 3;
}
```

### H0UND Configuration

```csharp
public class H0UNDOptions
{
    public PollingOptions Polling { get; set; } = new();
    public AnalyticsOptions Analytics { get; set; } = new();
    public DashboardOptions Dashboard { get; set; } = new();
}

public class PollingOptions
{
    public int IntervalSeconds { get; set; } = 30;
    public int RetryAttempts { get; set; } = 3;
    public int TimeoutSeconds { get; set; } = 10;
    public int JitterMs { get; set; } = 500;
    public int MaxConcurrentPolls { get; set; } = 5;
}

public class AnalyticsOptions
{
    public int IntervalSeconds { get; set; } = 10;
    public int DpdMinimumPoints { get; set; } = 25;
    public double DpdHighThreshold { get; set; } = 10.0;
    public bool GenerateSignals { get; set; } = true;
}

public class DashboardOptions
{
    public bool Enabled { get; set; } = true;
    public int RefreshRateMs { get; set; } = 1000;
    public bool ShowDetails { get; set; } = true;
    public int MaxHistoryHours { get; set; } = 24;
}
```

### H4ND Configuration

```csharp
public class H4NDOptions
{
    public AutomationOptions Automation { get; set; } = new();
    public BrowserOptions Browser { get; set; } = new();
    public SafetyOptions Safety { get; set; } = new();
}

public class AutomationOptions
{
    public int PollIntervalSeconds { get; set; } = 5;
    public int SpinTimeoutSeconds { get; set; } = 30;
    public int RetryAttempts { get; set; } = 3;
    public int GrandCheckRetries { get; set; } = 40;
    public int GrandCheckIntervalMs { get; set; } = 500;
    public bool ListenForSignals { get; set; } = true;
}

public class BrowserOptions
{
    public bool Headless { get; set; } = false;
    public string ExtensionPath { get; set; } = "RUL3S/auto-override";
    public string UserDataDir { get; set; } = "./chrome-data";
    public int WindowWidth { get; set; } = 1920;
    public int WindowHeight { get; set; } = 1080;
    public string ChromeBinaryPath { get; set; } = null;
}

public class SafetyOptions
{
    public int HealthCheckIntervalMinutes { get; set; } = 5;
    public int MaxConsecutiveErrors { get; set; } = 10;
    public bool AutoLogoutOnError { get; set; } = true;
}
```

### W4TCHD0G Configuration

```csharp
public class W4TCHD0GOptions
{
    public VisionOptions Vision { get; set; } = new();
    public OBSOptions OBS { get; set; } = new();
    public RTMPOptions RTMP { get; set; } = new();
    public SafetyMonitorOptions Safety { get; set; } = new();
    public AlertOptions Alerts { get; set; } = new();
}

public class VisionOptions
{
    public int FrameRate { get; set; } = 2;
    public int FrameWidth { get; set; } = 1280;
    public int FrameHeight { get; set; } = 720;
    public int BufferSize { get; set; } = 10;
    public string SourceName { get; set; } = "Game Capture";
    public int ProcessingTimeoutMs { get; set; } = 5000;
}

public class OBSOptions
{
    public string WebSocketUrl { get; set; } = "ws://localhost:4455";
    public string Password { get; set; } = null;
    public ReconnectionPolicyOptions ReconnectionPolicy { get; set; } = new();
}

public class ReconnectionPolicyOptions
{
    public int MaxRetries { get; set; } = 5;
    public int BaseDelayMs { get; set; } = 1000;
    public int MaxDelayMs { get; set; } = 30000;
    public double BackoffMultiplier { get; set; } = 2.0;
}

public class RTMPOptions
{
    public string ServerUrl { get; set; } = "rtmp://localhost:1935/live";
    public string StreamKey { get; set; } = "foureyes";
    public int BufferTimeMs { get; set; } = 1000;
}

public class SafetyMonitorOptions
{
    public decimal DailySpendLimit { get; set; } = 1000.00m;
    public int ConsecutiveLossLimit { get; set; } = 10;
    public string KillSwitchCode { get; set; }
    public decimal DailyLossLimit { get; set; } = 100.00m;
}

public class AlertOptions
{
    public bool Console { get; set; } = true;
    public bool File { get; set; } = true;
    public string FilePath { get; set; } = "win-events.log";
    public WebhookAlertOptions Webhook { get; set; } = new();
}

public class WebhookAlertOptions
{
    public bool Enabled { get; set; } = false;
    public string Url { get; set; } = null;
    public int TimeoutMs { get; set; } = 5000;
    public string Method { get; set; } = "POST";
    public Dictionary<string, string> Headers { get; set; } = new();
}
```

### Security Configuration

```csharp
public class SecurityOptions
{
    public string MasterKeyPath { get; set; } = @"C:\ProgramData\P4NTH30N\master.key";
    public EncryptionOptions Encryption { get; set; } = new();
}

public class EncryptionOptions
{
    public string Algorithm { get; set; } = "AES-256-GCM";
    public int KeyRotationDays { get; set; } = 365;
    public int KeyLengthBytes { get; set; } = 32;
    public int NonceLengthBytes { get; set; } = 12;
    public int TagLengthBytes { get; set; } = 16;
}
```

## Configuration Validation

### Startup Validation

```csharp
public class ConfigurationValidator
{
    public static void Validate(IConfiguration configuration)
    {
        var options = configuration.GetSection("P4NTH30N").Get<P4NTH30NOptions>();
        
        // Required settings
        if (string.IsNullOrEmpty(options.Security?.MasterKeyPath))
        {
            throw new ConfigurationException("Security.MasterKeyPath is required");
        }
        
        if (string.IsNullOrEmpty(options.W4TCHD0G?.Safety?.KillSwitchCode))
        {
            throw new ConfigurationException("W4TCHD0G.Safety.KillSwitchCode is required");
        }
        
        // Range validation
        if (options.H0UND?.Polling?.IntervalSeconds < 10)
        {
            throw new ConfigurationException("H0UND.Polling.IntervalSeconds must be >= 10");
        }
        
        if (options.W4TCHD0G?.Safety?.DailySpendLimit <= 0)
        {
            throw new ConfigurationException("W4TCHD0G.Safety.DailySpendLimit must be > 0");
        }
        
        // File existence
        if (!File.Exists(options.Security.MasterKeyPath))
        {
            throw new ConfigurationException(
                $"Master key not found at {options.Security.MasterKeyPath}");
        }
    }
}
```

## Configuration Examples

### Minimal Configuration

```json
{
  "MongoDB": {
    "ConnectionString": "mongodb://localhost:27017/P4NTH30N"
  },
  "W4TCHD0G": {
    "Safety": {
      "KillSwitchCode": "YOUR-CODE-HERE"
    }
  },
  "Security": {
    "MasterKeyPath": "C:\\P4NTH30N\\master.key"
  }
}
```

### Development Configuration

```json
{
  "P4NTH30N": {
    "Environment": "Development"
  },
  "MongoDB": {
    "ConnectionString": "mongodb://localhost:27017/P4NTH30N_Dev"
  },
  "H0UND": {
    "Polling": {
      "IntervalSeconds": 60
    }
  },
  "H4ND": {
    "Browser": {
      "Headless": false
    }
  },
  "Logging": {
    "LogLevel": {
      "Default": "Debug"
    }
  }
}
```

### Production Configuration

```json
{
  "P4NTH30N": {
    "Environment": "Production"
  },
  "MongoDB": {
    "ConnectionString": "mongodb://prod-mongo:27017/P4NTH30N",
    "MaxConnectionPoolSize": 200
  },
  "H4ND": {
    "Browser": {
      "Headless": true
    },
    "Automation": {
      "PollIntervalSeconds": 3
    }
  },
  "W4TCHD0G": {
    "Alerts": {
      "Webhook": {
        "Enabled": true,
        "Url": "https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
      }
    }
  },
  "Logging": {
    "LogLevel": {
      "Default": "Warning"
    }
  }
}
```

## Troubleshooting

### Configuration Not Loading

1. Check file name is correct (case-sensitive on Linux)
2. Verify JSON is valid
3. Check file is in output directory
4. Review build action (Content, Copy if newer)

### Environment Variables Not Working

1. Check variable name format (double underscore for nested)
2. Verify no typos in variable name
3. Restart application after setting
4. Check variable is in correct scope

### Validation Errors

1. Review error message for missing fields
2. Check file paths exist
3. Verify numeric values are in valid ranges
4. Ensure required fields are populated

---

**Related**: [Setup Guide](../../SETUP.md) | [Environment Setup](../../getting-started/setup.md) | [Security](../../security/SECURITY.md)
