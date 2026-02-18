# Windsurf Follower

A VS Code extension that automatically follows and centers the view on recent code changes. Perfect for watching AI coding assistants like Windsurf, GitHub Copilot, or Cursor work in real-time.

## Features

- **Auto-center on changes**: Automatically scrolls and centers the editor view on the most recent code change
- **Smart filtering**: Choose to follow external changes (AI tools) or your own changes
- **Configurable debounce**: Adjust the delay before the view centers to avoid excessive jumping

## Usage

The extension activates automatically when VS Code starts. By default, it will follow external changes (like those made by Windsurf or other AI tools).

### Commands

- `Windsurf Follower: Enable` - Enable auto-following
- `Windsurf Follower: Disable` - Disable auto-following  
- `Windsurf Follower: Toggle` - Toggle auto-following on/off

### Configuration

Open VS Code settings and search for "Windsurf Follower":

- `windsurfFollower.enabled` - Enable/disable the extension
- `windsurfFollower.followExternalChanges` - Follow changes from external tools (default: true)
- `windsurfFollower.followSelfChanges` - Follow your own changes (default: false)
- `windsurfFollower.debounceMs` - Delay before centering (default: 100ms)

## Installation

### From Source

1. Clone or download this extension
2. Run `npm install`
3. Run `npm run compile`
4. Press F5 in VS Code to launch the Extension Development Host
5. Or package it with `vsce package` and install the `.vsix` file

## How It Works

The extension listens to `workspace.onDidChangeTextDocument` events to detect changes. When a change is detected:

1. It identifies the line where the change occurred
2. Waits for the configured debounce time
3. Centers the editor view on that line using `editor.revealRange()` with `TextEditorRevealType.InCenter`

## Requirements

- VS Code 1.74.0 or higher

## License

MIT
