---
title: SOLID Principles in Swift
date: 2022-04-09 10.12
description: Maintainable, flexible and understandable code is something we should all strive for. Requirements today could change in the future and having code which can easily be modified without affect the rest of the codebase allows for easier changes. SOLID is a mnemonic used to aid in the architecture of software to make it more easily changeable.
---

Maintainable, flexible and understandable code is something we should all strive for. Requirements today could change in the future and having code which can easily be modified without affect the rest of the codebase allows for easier changes.

SOLID is a mnemonic used to aid in the architecture of software to make it more easily changeable. It stands for:

* **S**ingle Responsibility Principle
* **O**pen/Closed Principle
* **L**iskov Substitution Principle
* **I**nterface Segregation Principle
* **D**ependency Inversion Principle

Adopting these principles will aid in maintaining a project as it grows. They aid to avoid code smells and refactoring later on.

Lets explore each one, in the context of Swift.

## Single Responsibility Principle (SRP)

> A class should have only a single responsibility/job.

Or putting it another way,

> There should never be more than one reason for a class to change.

Sounds simple right? A class should have one job, and one job only. No more, no less. If a class is doing multiple things which aren't related consider splitting that class up. It helps you keep classes clean, focused and easier to test.

## Open/Closed Principle (OCP)

> A class should be open for extension, but closed for modification

## Liskov Substitution Principle (LSP)

> Any class should be able to be replaced by one of its subclasses without affecting anything else.

## Interface Segregation Principle (ISP)

> Many interfaces are better than one general-purpose interface.

## Dependency Inversion Principle (DIP)

> Depend on abstractions, not concrete classes.
