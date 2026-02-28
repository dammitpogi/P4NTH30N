# C0MMON/Versioning

## Responsibility

Application versioning and release management for P4NTHE0N. Provides centralized version information across all agents and components.

## When Working Here

- **Single source of truth**: One place for version info
- **Semantic versioning**: Follow SemVer guidelines
- **Build integration**: Automate version increments
- **Display formatting**: Human-readable version strings

## Core Components

### AppVersion.cs
Centralized version management:
- `GetInformationalVersion`: Returns full version from assembly attribute (e.g., "1.0.0+20260217")
- `GetDisplayVersion`: Returns version without build metadata (e.g., "1.0.0")
- Uses AssemblyInformationalVersionAttribute for version storage

## Version Format

```csharp
// Get full informational version (includes build metadata)
string fullVersion = AppVersion.GetInformationalVersion();
// Returns: "1.0.0+20260217" or "1.0.0.0"

// Get display version (clean, without metadata)
string displayVersion = AppVersion.GetDisplayVersion();
// Returns: "1.0.0"
```

## Usage

```csharp
// In agent header
Console.WriteLine(AppVersion.GetDisplayVersion());

// In logs
logger.Info($"Starting P4NTHE0N {AppVersion.GetInformationalVersion()}");

// Display version without build metadata
Console.WriteLine($"Version: {AppVersion.GetDisplayVersion()}");
```

## Versioning Strategy

- **Major**: Breaking changes, architectural updates
- **Minor**: New features, backward compatible
- **Patch**: Bug fixes, optimizations
- **Build**: CI/CD build number

## Build Integration

Recommended approach with Directory.Build.props:
```xml
<PropertyGroup>
  <VersionPrefix>0.8.6</VersionPrefix>
  <VersionSuffix>beta</VersionSuffix>
  <BuildNumber>$([System.DateTime]::Now.ToString('yyyyMMdd'))</BuildNumber>
</PropertyGroup>
```

## Future Enhancements

- Git commit SHA integration
- Automatic version bumping
- Release notes generation
- API version negotiation

## Recent Updates (2026-02-19)

### CDP Migration Versioning
- **Version 2.0.0**: Major version for CDP migration from Selenium
- **Component Versioning**: Track individual component versions (H4ND, C0MMON, RUL3S)
- **Migration Flags**: Version flags for CDP compatibility checks
- **Feature Toggles**: Version-based feature enablement for gradual rollout

### Enhanced Version Display
- **Component Versions**: Display H4ND, C0MMON, and infrastructure versions
- **CDP Version**: Track Chrome DevTools Protocol compatibility
- **Migration Status**: Show current migration state and compatibility
- **Build Metadata**: Enhanced build information including CDP migration status
