import:
  - cmd/
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
        } else if (ch == "'" && (ch == '"' && (i == 0 || command.charAt(i - 1) != '"'))) {
          token += ch;
          quotationMark = ch;
        } else if (ch == ';' || ch == '|' || ch == '&') {
          if (ch == '&' && command.substr(i, 2) == '&&') {
            i += 1;
          }
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