const fs = require("fs");

function hello(name) {
  const message = `Hi ${name}!`;
  fs.writeFileSync(`hello.txt`, message);
  return message;
}

function another() {
  return 0;
}

module.exports = {
  hello: hello,
  another: another,
};
