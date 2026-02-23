/**
 * Input filtering utilities for TUI text editing
 * Prevents ANSI escape sequences and control characters from being inserted into text fields
 */

export interface FilteredInput {
  char: string | null;
  isSpecialKey: boolean;
  keyName?: string;
}

/**
 * Filter raw terminal input to extract printable characters only
 * Returns null for special keys (arrows, function keys, etc.)
 */
export function filterInput(data: string): FilteredInput {
  // Empty input
  if (!data || data.length === 0) {
    return { char: null, isSpecialKey: false };
  }

  // Single printable ASCII character (32-126)
  if (data.length === 1) {
    const code = data.charCodeAt(0);
    
    // Backspace (127 or 8)
    if (code === 127 || code === 8) {
      return { char: null, isSpecialKey: true, keyName: 'backspace' };
    }
    
    // Enter (13 or 10)
    if (code === 13 || code === 10) {
      return { char: null, isSpecialKey: true, keyName: 'enter' };
    }
    
    // Tab (9)
    if (code === 9) {
      return { char: null, isSpecialKey: true, keyName: 'tab' };
    }
    
    // Escape (27)
    if (code === 27) {
      return { char: null, isSpecialKey: true, keyName: 'escape' };
    }
    
    // Ctrl+C (3)
    if (code === 3) {
      return { char: null, isSpecialKey: true, keyName: 'ctrl-c' };
    }
    
    // Ctrl+S (19)
    if (code === 19) {
      return { char: null, isSpecialKey: true, keyName: 'ctrl-s' };
    }
    
    // Ctrl+D (4)
    if (code === 4) {
      return { char: null, isSpecialKey: true, keyName: 'ctrl-d' };
    }
    
    // Printable ASCII
    if (code >= 32 && code <= 126) {
      return { char: data, isSpecialKey: false };
    }
    
    // Other control characters - ignore
    return { char: null, isSpecialKey: true };
  }

  // ANSI escape sequences (start with ESC [)
  if (data.startsWith('\x1b[')) {
    const seq = data.slice(2);
    
    // Arrow keys
    if (seq === 'A') return { char: null, isSpecialKey: true, keyName: 'up' };
    if (seq === 'B') return { char: null, isSpecialKey: true, keyName: 'down' };
    if (seq === 'C') return { char: null, isSpecialKey: true, keyName: 'right' };
    if (seq === 'D') return { char: null, isSpecialKey: true, keyName: 'left' };
    
    // Home/End
    if (seq === 'H' || seq === '1~') return { char: null, isSpecialKey: true, keyName: 'home' };
    if (seq === 'F' || seq === '4~') return { char: null, isSpecialKey: true, keyName: 'end' };
    
    // Page Up/Down
    if (seq === '5~') return { char: null, isSpecialKey: true, keyName: 'pageup' };
    if (seq === '6~') return { char: null, isSpecialKey: true, keyName: 'pagedown' };
    
    // Delete
    if (seq === '3~') return { char: null, isSpecialKey: true, keyName: 'delete' };
    
    // Insert
    if (seq === '2~') return { char: null, isSpecialKey: true, keyName: 'insert' };
    
    // Function keys F1-F12
    if (seq.match(/^1[0-9]~$/)) return { char: null, isSpecialKey: true, keyName: 'function' };
    
    // Other escape sequences - ignore
    return { char: null, isSpecialKey: true };
  }

  // Alt+ combinations (ESC followed by character)
  if (data.startsWith('\x1b') && data.length === 2) {
    return { char: null, isSpecialKey: true, keyName: 'alt-' + data[1] };
  }

  // Multi-byte UTF-8 characters (allow them)
  if (data.length > 1 && !data.startsWith('\x1b')) {
    // Basic UTF-8 validation - if it's valid UTF-8, allow it
    try {
      const decoded = Buffer.from(data, 'utf8').toString('utf8');
      if (decoded === data) {
        return { char: data, isSpecialKey: false };
      }
    } catch {
      // Invalid UTF-8 - ignore
    }
  }

  // Unknown sequence - ignore
  return { char: null, isSpecialKey: true };
}

/**
 * Check if input should be allowed in a text field
 */
export function isAllowedInTextField(data: string): boolean {
  const filtered = filterInput(data);
  return filtered.char !== null;
}

/**
 * Extract only printable characters from input
 */
export function extractPrintableChar(data: string): string | null {
  const filtered = filterInput(data);
  return filtered.char;
}

/**
 * Check if input is a navigation key (arrows, tab, etc.)
 */
export function isNavigationKey(data: string): boolean {
  const filtered = filterInput(data);
  if (!filtered.isSpecialKey || !filtered.keyName) return false;
  
  const navKeys = ['up', 'down', 'left', 'right', 'tab', 'enter', 'escape'];
  return navKeys.includes(filtered.keyName);
}

/**
 * Check if input is backspace
 */
export function isBackspace(data: string): boolean {
  const filtered = filterInput(data);
  return filtered.keyName === 'backspace';
}

/**
 * Check if input is enter
 */
export function isEnter(data: string): boolean {
  const filtered = filterInput(data);
  return filtered.keyName === 'enter';
}

/**
 * Check if input is escape
 */
export function isEscape(data: string): boolean {
  const filtered = filterInput(data);
  return filtered.keyName === 'escape';
}

/**
 * Check if input is tab
 */
export function isTab(data: string): boolean {
  const filtered = filterInput(data);
  return filtered.keyName === 'tab';
}
