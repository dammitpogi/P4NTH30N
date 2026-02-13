# RUL3S/

## Responsibility
Resource override system that manipulates browser behavior for game automation. Provides JavaScript injection, header manipulation, and asset override capabilities to enable H4ND automation agent to interact with FireKirin and OrionStars game portals.

## Design

### Architecture Patterns
- **Chrome Extension Structure**: Manifest-based extension with background scripts and UI components
- **Rule-Based Engine**: JSON configuration defines override rules for URLs and resources
- **Content Script Injection**: Injects JavaScript into game pages to expose automation hooks
- **Header Interception**: Modifies HTTP headers to bypass restrictions and enable automation
- **Asset Override**: Replaces game assets with modified versions for automation compatibility

### Core Components

**Resource Rules** (`resource_override_rules.json` - 9.2MB):
- Massive JSON configuration defining override patterns
- URL pattern matching for FireKirin and OrionStars domains
- JavaScript injection rules for exposing game internals
- Header manipulation for CORS, authentication, and security bypass
- Asset replacement mappings

**Game-Specific Configurations**:
- `play.firekirin.in/`: FireKirin platform overrides
- `web.orionstars.org/`: OrionStars platform overrides
- Each platform has game-specific subdirectories (15L9X, Fish, hallfirekirin, etc.)

**BaseCode Pattern**:
- Shared game engine code in `BaseCode/` directories
- `assets/script/` contains core game logic
- `assets/` contains game assets (images, audio, config)
- Standardized structure across different games

**Chrome Extension** (`auto-override/`):
- `manifest.json`: Extension metadata and permissions
- `src/background/`: Background service worker
  - `background.js`: Main background logic
  - `headerHandling.js`: Request/response interception
  - `requestHandling.js`: HTTP request manipulation
  - `mainStorage.js`: Extension storage management
- `src/ui/`: Extension popup and devtools UI
  - `devtools.html/js`: Developer tools panel
  - `options.html/js`: Extension options
  - `editor.js`: Rule editor interface
- `lib/`: Third-party libraries (Ace editor, jQuery, beautify)

## Flow

### JavaScript Injection Flow
1. Browser navigates to game URL (e.g., play.firekirin.in)
2. Extension matches URL against `resource_override_rules.json` patterns
3. Content script injection rules trigger
4. JavaScript injected into page context
5. Injected code exposes game internals:
   - Game state objects
   - Spin functions
   - Jackpot values
   - Balance information
6. H4ND agent can now interact with exposed automation hooks

### Header Manipulation Flow
1. Game page makes HTTP request for API endpoint
2. Extension intercepts request via `webRequest` API
3. `headerHandling.js` modifies headers:
   - Add CORS headers for cross-origin requests
   - Modify authentication tokens
   - Bypass security restrictions
4. Request proceeds with modified headers
5. Response may also be modified before reaching page

### Asset Override Flow
1. Game attempts to load asset (image, script, config)
2. Extension matches asset URL against override rules
3. Original request blocked or redirected
4. Replacement asset served from extension storage or local URL
5. Game receives modified asset without detecting change

### Rule Matching Flow
1. Extension loads `resource_override_rules.json` at startup
2. Rules parsed into efficient matching structures
3. For each web request, test against URL patterns
4. First matching rule wins
5. Rule defines: JavaScript to inject, headers to modify, assets to replace
6. Modifications applied before request/response completes

## Integration

**Consumed By**:
- `H4ND`: Automation agent uses injected JavaScript hooks to control games
- `HUN7ER`: May use for data collection if direct API access unavailable

**Dependencies**:
- Chrome Extension APIs: `webRequest`, `webNavigation`, `storage`, `tabs`
- Third-party libraries: Ace editor (rule editing), jQuery (DOM manipulation)

**File Structure**:
```
RUL3S/
├── resource_override_rules.json    # Main rule configuration (9.2MB)
├── auto-override/                  # Chrome extension source
│   ├── manifest.json
│   ├── src/background/             # Service worker
│   └── src/ui/                     # Extension UI
├── play.firekirin.in/              # FireKirin platform overrides
│   ├── web_mobile/
│   │   ├── BaseCode/               # Shared game engine
│   │   └── hallfirekirin/          # Specific game overrides
│   └── resource_override_rules.json
└── web.orionstars.org/             # OrionStars platform overrides
    └── hot_play/
        ├── BaseCode/
        └── hallorionstars/
```

## Rule Configuration

**Rule Types**:
1. **JavaScript Injection**: Inject code into page context
2. **Header Modification**: Add, remove, or modify HTTP headers
3. **Asset Replacement**: Replace remote assets with local versions
4. **Request Blocking**: Prevent specific requests from completing
5. **Response Modification**: Modify response data before page receives it

**Pattern Matching**:
- URL wildcards and regex patterns
- Domain-specific rules
- Path-based matching
- Query parameter matching

**Example Rule Structure**:
```json
{
  "pattern": "*://play.firekirin.in/*",
  "type": "javascript",
  "script": "window.gameAPI = { spin: function() { ... } }"
}
```

## Performance Considerations

**Rule Matching**: 
- 9.2MB rules file loaded into memory
- Efficient pattern matching critical for performance
- Rules evaluated on every request

**Injection Overhead**:
- JavaScript injection adds page load time
- Large injected scripts may impact game performance
- Content scripts run in isolated contexts

**Memory Usage**:
- Extension background script persistent
- Rule cache in memory
- Injected scripts per tab

## Security Implications

**Bypass Mechanisms**:
- CORS bypass for cross-origin requests
- Security header removal
- Authentication token injection
- Certificate validation bypass

**Detection Risk**:
- Game platforms may detect automation
- Pattern matching may identify injected scripts
- Unusual request patterns flagged
- Account ban risk if detected

**Mitigations**:
- Stealth injection techniques
- Request pattern randomization
- Header spoofing
- Behavioral mimicry

## Maintenance

**Rule Updates**:
- Game platform changes break rules frequently
- Requires continuous maintenance
- Version tracking for game updates
- Rapid response to platform changes

**Debugging Tools**:
- Extension devtools panel
- Request/response logging
- Rule testing interface
- Real-time injection visualization

**Backup Systems**:
- Multiple rule variants for redundancy
- Fallback rules when primary fails
- A/B testing of rule effectiveness
