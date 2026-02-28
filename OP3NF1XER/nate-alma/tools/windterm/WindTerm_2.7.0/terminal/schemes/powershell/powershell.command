import:
  - powershell/
  - git/
  - cmd/

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
        } else if (ch == "'" || ch == '"') {
          token += ch;
          quotationMark = ch;
        } else if (ch == '-' && command.substr(i, 4) == '-and') {
          tokens = [];
          token = '';
          i += 3;
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
    return { tokens: tokens };
  }