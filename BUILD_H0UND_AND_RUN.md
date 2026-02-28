# H0UND Build and Run Guide

## Purpose

This guide explains where H0UND build artifacts are written and how to run
`P4NTHE0N.exe` without runtime loader errors.

## Current Output Behavior

Repository-level defaults in `Directory.Build.props` send most project outputs
to:

- `C:\Users\paulc\OneDrive\Desktop\build\<ProjectName>\bin\...`
- `C:\Users\paulc\OneDrive\Desktop\build\<ProjectName>\obj\...`

H0UND is intentionally overridden to use local project paths:

- `H0UND\bin\...`
- `H0UND\obj\...`

The H0UND override is defined in `Directory.Build.props` with:

`<PropertyGroup Condition="'$(MSBuildProjectName)' == 'H0UND'">`

## Build

From repository root:

```powershell
dotnet build .\H0UND\H0UND.csproj -c Release
```

Expected executable output:

`H0UND\bin\Release\net10.0-windows7.0\P4NTHE0N.exe`

## Run

```powershell
.\H0UND\bin\Release\net10.0-windows7.0\P4NTHE0N.exe
```

Headless/service mode (skip all dashboard rendering and splash UI):

```powershell
.\H0UND\bin\Release\net10.0-windows7.0\P4NTHE0N.exe --no-ui
```

If Windows shows `This app can't run on your PC`, publish first and run the
published executable instead:

```powershell
dotnet publish .\H0UND\H0UND.csproj -c Release -r win-x64 --self-contained false -o .\H0UND\bin\Publish\win-x64
.\H0UND\bin\Publish\win-x64\P4NTHE0N.exe
```

## Troubleshooting

### Error: `hostpolicy.dll` not found / `runtimeconfig.json` missing

If you see:

- `The library 'hostpolicy.dll' ... was not found`
- `... P4NTHE0N.runtimeconfig.json was not found`

Then the app is being launched from the wrong output folder or from a partial
copy.

In this repository, `bin\Release\net10.0-windows7.0\P4NTHE0N.exe` can be a
stale zero-byte file from older outputs. Prefer the published `win-x64` exe.

Verify these files exist in the same folder as `P4NTHE0N.exe`:

- `P4NTHE0N.runtimeconfig.json`
- `P4NTHE0N.deps.json`
- `P4NTHE0N.dll`

Quick fix:

1. Rebuild with the command above.
2. Run the executable from `H0UND\bin\Release\net10.0-windows7.0\`.
