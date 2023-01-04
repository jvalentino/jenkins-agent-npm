#!/bin/bash
set -x
cd example-js-npm-lib-3
rm -rf node_modules || true
npm install
npm run format
npm run check
npm run test
npm run verify
npm run build

echo " "
echo "Validation..."
[ ! -f build/eslint.html ] && echo "build/eslint.html does not exist." && exit 1
[ ! -f coverage/index.html ] && echo "coverage/index.html does not exist." && exit 1
[ ! -f dist/example-js-npm-lib-3.cjs.js ] && echo "dist/example-js-npm-lib-3.cjs.js does not exist." && exit 1
[ ! -f dist/example-js-npm-lib-3.esm.js ] && echo "dist/example-js-npm-lib-3.esm.js does not exist." && exit 1
[ ! -f dist/example-js-npm-lib-3.umd.js ] && echo "dist/example-js-npm-lib-3.umd.js does not exist." && exit 1

echo "Validation Done"