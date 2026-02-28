import:
  - linux/
  - git/

parser: |
  (command) => {
    let tokens = [];
    let token = '';
    let quotationMark = '';

    function __addToken() {
      if (token.length > 0) {
        tokens.push(token)
        token = ''
      }
    }

    for (let i = 0, count = command.length; i < count; i++) {
      let ch = command.charAt(i);

      if (quotationMark == '') {
        if (ch == ' ') {
          __addToken();
        } else if (ch == "'") {
          token += ch;
          quotationMark = ch;
        } else if (ch == '"') {
          let backslashes = 0;

          for (let j = i - 1; j >= 0; j--) {
            if (command.charAt(j) != '\\') {
              break;
            }
            backslashes += 1;
          }

          if (backslashes % 2 == 0) {
            token += ch;
            quotationMark = ch;
          }
        } else if ((ch == '&' && command.substr(i, 2) == '&&') || (ch == '|' && command.substr(i, 2) == '||')) {
          tokens = [];
          token = '';
          i += 1;
        } else if (ch == ';' || ch == '|') {
          tokens = [];
          token = '';
        } else {
          token += ch;
        }
      } else {
        token += ch;

        if (quotationMark == ch) {
          __addToken();
          quotationMark = '';
          continue;
        }
      }
    }
    __addToken();

    for (let i = tokens.length - 1; i >= 0; i--) {
      let token = tokens[i];

      if (token == '<' || token == '>'
        || token == '>>' || token == '<<'
        || token == '2>' || token == '2>>' || token == '2>&1') {
        tokens = tokens.splice(i, tokens.length - i);
      }
    }

    if (tokens.length > 0 && tokens[0] == 'sudo') {
      let subCommandIndex = 1;

      for (let i = 1; i < tokens.length; i++) {
        if (tokens[i].startsWith('-') == false) {
          break;
        }
        subCommandIndex += 1;
      }

      if (subCommandIndex < tokens.length) {
        tokens = tokens.splice(subCommandIndex, tokens.length - subCommandIndex);
      }
    }
    return { tokens: tokens };
  }