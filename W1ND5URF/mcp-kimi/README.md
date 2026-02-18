# Windsurf Cartography Extension

Auto-injects codemap.md files into AI context based on the Cartography system. Provides real-time architectural awareness to Windsurf's AI assistant when working in any directory that has a codemap.

## Features

- **Automatic Context Injection**: Detects when you open files and auto-injects the relevant codemap.md into AI context
- **Hierarchical Discovery**: Searches current directory and parent directories for codemap.md files
- **Status Bar Integration**: Shows current codemap context in the status bar
- **Toggle Control**: Enable/disable auto-injection via command palette
- **Configuration**: Customizable cartography path and context length limits

## Commands

- `Windsurf Cartography: Refresh Cartography Context` - Manually refresh context for current file
- `Windsurf Cartography: Show Current Codemap` - Display the currently active codemap
- `Windsurf Cartography: Toggle Auto-Injection` - Enable/disable automatic injection

## Configuration

- `windsurfCartography.enabled`: Enable/disable automatic codemap injection (default: `true`)
- `windsurfCartography.cartographyPath`: Path to Cartography configuration file (default: `.slim/cartography.json`)
- `windsurfCartography.maxContextLength`: Maximum character length for injected codemap content (default: `5000`)

## Installation

1. Run `npm install` to install dependencies
2. Run `npm run compile` to build the extension
3. Press F5 to launch Extension Development Host
4. Test by opening files in directories with codemap.md files

## How It Works

The extension monitors the active editor and:
1. Detects the current file's directory
2. Searches for codemap.md in current and parent directories
3. Injects the codemap content into Windsurf's AI context
4. Updates the status bar to show current context

## Integration with Cartography

This extension works with the Cartography system that maintains codemap.md files across your codebase. The codemaps provide:
- Architectural context
- Design patterns and abstractions
- Data flow documentation
- Integration points

## Requirements

- VS Code 1.85.0 or higher
- Cartography configuration (`.slim/cartography.json`) in workspace root

## License

MIT
