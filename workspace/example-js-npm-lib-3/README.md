# Example JavaScript Library Part 3

This is a continuation of the example series, in which common static code analysis and formatting are added to the project.

Prerequisites

- Git Setup: https://github.com/jvalentino/setup-git
- Part 1: https://github.com/jvalentino/example-js-npm-lib-1
- Part 2: https://github.com/jvalentino/example-js-npm-lib-2

# Format

The prettier plugin is being used to format code when this command is run:

```bash
$ npm run format

> example-js-npm-lib-3@1.0.0 format
> npx prettier-eslint "src/**/*.js" --write -l info

success formatting 1 file with prettier-eslint
```

# Check

The eslint plugin is being used to run static code analysis on the source code, and if issues are found per .eslint.json, fail the build:

```bash
$ npm run check

> example-js-npm-lib-3@1.0.0 check
> npx eslint --fix src --format html -o build/eslint.html
```

It also produces an html report at build/eslint.html.