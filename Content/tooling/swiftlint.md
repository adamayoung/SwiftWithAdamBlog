---
title: SwiftLint
date: 2022-01-19 21:09
description: Linting is the automated checking of your source code to flag programming errors, bugs, stylistic errors, and suspicious constructs. SwiftLint is a linter specifically for Swift code. But how do you use it?
---

## What is a Linter?

Linting is the automated checking of your source code to flag programming errors, bugs, stylistic errors, and suspicious constructs. This is done by using a lint tool (otherwise known as linter). A lint tool is a basic static code analyzer.

## Why should you use a Linter in your development process?

Linting is a way to reduce errors and improve the overall quality of your code. Using lint tools can help you accelerate development and reduce costs by finding errors earlier. The earlier a problem is found, the cheaper it is to fix.

It also helps when you share the codebase with a team. A linter can ensure everyone is following the same coding styles.

## How does it fit in with your development workflow?

Typically, you'd add the linting step before building/compiling code. The process might look like:

1. Write some code
2. Build it
3. Linter analyses your code
4. Warnings and errors are shown along with any compiler errors
5. Fix linting issues
6. Built it again

## Introducing SwiftLint

[SwiftLint](https://github.com/realm/SwiftLint) is a linter specifically for Swift code.

> A tool to enforce Swift style and conventions, loosely based on the now archived GitHub Swift Style Guide. SwiftLint enforces the style guide rules that are generally accepted by the Swift community. These rules are well described in popular style guides like Ray Wenderlich's Swift Style Guide.

## Installing

SwiftLint can be installed in a number of ways. The most common being by homebrew.

```bash
brew install swiftlint
```

Many CI/CD services like GitHub Actions, Bitrise or TravisCI have swiftlint installed by default on their macOS environments, saving you the time of installing it yourself.

## Running via the Terminal

Once you have it installed, simply go to the root of your project or Swift Package in the terminal and run

```bash
swiftlint
```

The command will log all the places it's found a volation in your code, followed by summary of total violations.

## Running in an Xcode Project

Xcode project targets can be configured to run custom build phases as part of the build process.

1. Open your project in Xcode
2. Select the Project in the Project Navigator
3. Select the main target in your project
4. Click on the **Build Phases** tab
5. Add a new **Run Script Phase**
6. Add the following script

```bash
if which swiftlint >/dev/null; then
    swiftlint
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
```

Now whenever you build your target, SwiftLint will show you any violations as warnings or errors in your source code.

## Running in a Swift Package

Unfortunately you cannot currently configure Swift Package Manager to run custom build phase scripts like you can with Xcode projects.

A proposal in Swift, called Package Manager Extensible Build Tools [(SE-0303)](https://github.com/apple/swift-evolution/blob/main/proposals/0303-swiftpm-extensible-build-tools.md) has been implemented, and is available in Swift 5.6, which is not yet released.

## Configure Linting Rules

The standard set of linting rules can be in the [Rule Directory Reference](https://realm.github.io/SwiftLint/rule-directory.html). But you may want to tweak this rules to suit your own style. These custom rules can be added to a file called `.swiftlint.yml` in the directory where you will run swiftlint from.

Example `.swiftlint.yml` file:

```yml
excluded:
  - .build

identifier_name:
  min_length:
    error: 4
  max_length: 60
  excluded:
    - id
    - lhs
    - rhs
    - url
```

See the SwiftLint [README.md](https://github.com/realm/SwiftLint/blob/master/README.md) for more details on rules and how to create custom ones.

## Strict mode

By default, any warnings that SwiftLint raises won't actually fail the linting - because they're just warnings and not errors. However, in some cases you may want to fail the linting when it does find warnings. One example might be when linting as part of your CI pipeline. To use SwiftLint in strict mode,

```bash
swiftlint --strict
```

## Running as part of your CI pipeline

Part of any good Software Development Lifecycle is the use of CI (Continuous Integration) pipelines. It automates a lot of the checking and testing of our code which would otherwise have to be done manually. Linting your code is a common task as part of this.

### GitHub Actions

I use [GitHub Actions](https://github.com/features/actions) as my primary CI/CD tool. For public repositories it's free to use. The macOS environments available with GitHub Actions come with SwiftLint installed by default, saving you time installing it yourself.

Here's an example workflow which checks out the repository and lints all `.swift` source files:

```yaml
name: CI

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  lint:
    name: Lint
    runs-on: macos-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with:
          fetch-depth: 0

      - name: swiftlint
        run: swiftlint --strict
```
