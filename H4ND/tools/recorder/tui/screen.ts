// ANSI Terminal Rendering Primitives

const ESC = '\x1b';

// Colors
export const c = {
  reset:    `${ESC}[0m`,
  bold:     `${ESC}[1m`,
  dim:      `${ESC}[2m`,
  italic:   `${ESC}[3m`,
  underline:`${ESC}[4m`,
  inverse:  `${ESC}[7m`,
  // Foreground
  black:    `${ESC}[30m`,
  red:      `${ESC}[31m`,
  green:    `${ESC}[32m`,
  yellow:   `${ESC}[33m`,
  blue:     `${ESC}[34m`,
  magenta:  `${ESC}[35m`,
  cyan:     `${ESC}[36m`,
  white:    `${ESC}[37m`,
  gray:     `${ESC}[90m`,
  brightRed:    `${ESC}[91m`,
  brightGreen:  `${ESC}[92m`,
  brightYellow: `${ESC}[93m`,
  brightBlue:   `${ESC}[94m`,
  brightMagenta:`${ESC}[95m`,
  brightCyan:   `${ESC}[96m`,
  brightWhite:  `${ESC}[97m`,
  // Background
  bgBlack:  `${ESC}[40m`,
  bgRed:    `${ESC}[41m`,
  bgGreen:  `${ESC}[42m`,
  bgYellow: `${ESC}[43m`,
  bgBlue:   `${ESC}[44m`,
  bgMagenta:`${ESC}[45m`,
  bgCyan:   `${ESC}[46m`,
  bgWhite:  `${ESC}[47m`,
  bgGray:   `${ESC}[100m`,
};

// Cursor movement
export function moveTo(row: number, col: number): string {
  return `${ESC}[${row};${col}H`;
}

export function clearScreen(): string {
  return `${ESC}[2J${ESC}[H`;
}

export function clearLine(): string {
  return `${ESC}[2K`;
}

export function hideCursor(): string {
  return `${ESC}[?25l`;
}

export function showCursor(): string {
  return `${ESC}[?25h`;
}

// Box drawing characters
export const box = {
  tl: '┌', tr: '┐', bl: '└', br: '┘',
  h: '─', v: '│',
  lt: '├', rt: '┤', tt: '┬', bt: '┴', cross: '┼',
  // Double
  dtl: '╔', dtr: '╗', dbl: '╚', dbr: '╝',
  dh: '═', dv: '║',
  // Rounded
  rtl: '╭', rtr: '╮', rbl: '╰', rbr: '╯',
};

// Draw a box with optional title
export function drawBox(row: number, col: number, width: number, height: number, title?: string, color: string = c.cyan): string {
  let out = '';
  // Top border
  out += moveTo(row, col) + color + box.tl + box.h.repeat(width - 2) + box.tr + c.reset;
  if (title) {
    const titleStr = ` ${title} `;
    const titleCol = col + 2;
    out += moveTo(row, titleCol) + c.bold + c.brightCyan + titleStr + c.reset;
  }
  // Sides
  for (let r = 1; r < height - 1; r++) {
    out += moveTo(row + r, col) + color + box.v + c.reset;
    out += moveTo(row + r, col + width - 1) + color + box.v + c.reset;
  }
  // Bottom border
  out += moveTo(row + height - 1, col) + color + box.bl + box.h.repeat(width - 2) + box.br + c.reset;
  return out;
}

// Draw horizontal separator inside a box
export function drawSep(row: number, col: number, width: number, color: string = c.cyan): string {
  return moveTo(row, col) + color + box.lt + box.h.repeat(width - 2) + box.rt + c.reset;
}

// Write text at position, truncated to maxLen
export function writeAt(row: number, col: number, text: string, maxLen?: number): string {
  const t = maxLen ? text.slice(0, maxLen) : text;
  return moveTo(row, col) + t;
}

// Pad/truncate string to exact width
export function pad(text: string, width: number, align: 'left' | 'right' | 'center' = 'left'): string {
  // Strip ANSI for length calculation
  const stripped = text.replace(/\x1b\[[0-9;]*m/g, '');
  if (stripped.length >= width) {
    // Need to truncate - tricky with ANSI codes, just do a rough cut
    return text.slice(0, width + (text.length - stripped.length));
  }
  const padding = width - stripped.length;
  if (align === 'right') return ' '.repeat(padding) + text;
  if (align === 'center') {
    const left = Math.floor(padding / 2);
    return ' '.repeat(left) + text + ' '.repeat(padding - left);
  }
  return text + ' '.repeat(padding);
}

// Status icons
export const icon = {
  play:       '▶',
  pause:      '⏸',
  stop:       '⏹',
  check:      '✓',
  cross:      '✗',
  dot:        '●',
  circle:     '○',
  arrow:      '►',
  arrowDown:  '▼',
  breakpoint: '🔴',
  camera:     '📸',
  cursor:     '▸',
  running:    '⟳',
  warning:    '⚠',
};

// Render a progress bar
export function progressBar(current: number, total: number, width: number = 20): string {
  const filled = Math.round((current / total) * width);
  const empty = width - filled;
  return c.green + '█'.repeat(filled) + c.gray + '░'.repeat(empty) + c.reset;
}

// Get terminal size
export function getTermSize(): { rows: number; cols: number } {
  return {
    rows: process.stdout.rows || 40,
    cols: process.stdout.columns || 120,
  };
}

// Flush output buffer in one write
export function flush(content: string): void {
  process.stdout.write(content);
}

// Word-wrap text to fit within a given width
export function wordWrap(text: string, width: number): string[] {
  if (!text || width <= 0) return [];
  
  const words = text.split(' ');
  const lines: string[] = [];
  let currentLine = '';
  
  for (const word of words) {
    // If word itself is longer than width, break it up
    if (word.length > width) {
      if (currentLine.length > 0) {
        lines.push(currentLine);
        currentLine = '';
      }
      // Break long word into chunks
      for (let i = 0; i < word.length; i += width) {
        lines.push(word.slice(i, i + width));
      }
      continue;
    }
    
    if (currentLine.length === 0) {
      currentLine = word;
    } else if (currentLine.length + 1 + word.length <= width) {
      currentLine += ' ' + word;
    } else {
      lines.push(currentLine);
      currentLine = word;
    }
  }
  
  if (currentLine.length > 0) {
    lines.push(currentLine);
  }
  
  return lines;
}
