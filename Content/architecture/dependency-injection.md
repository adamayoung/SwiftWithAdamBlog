---
title: Dependency Injection
date: 2022-02-01 19:41
description: Dependency Injection allows us to create more maintainable code which is easier to test.
---

In a nutshell, dependency injection means creating dependencies outside of the class that uses them and passing those dependencies to it, rather than the class creating them itself.

## Without Dependency Injection

```swift
class RandomNumberGenerator {

    func generate() -> Int {
        Int.random(in: 1...10)
    }

}

class SomeService {

    let generator = RandomNumberGenerator()

    func nextNumber() -> Int {
        generator.generate()
    }

}

let service = SomeService()
let number = service.nextNumber()
```

Although this does the job of getting the next number, it's not very maintainable or easy to test. What if you wanted to change the number generator to a different implementation? How would you even test `SomeService`?

## With Dependency Injection

```swift
protocol NumberGenerator {

    func generate() -> Int

}

final class RandomNumberGenerator: NumberGenerator {

    func generate() -> Int {
        Int.random(in: 1...10)
    }

}

final class SomeService {

    private let generator: NumberGenerator

    init(generator: NumberGenerator) {
        self.generator = generator
    }

    func nextNumber() -> Int {
        generator.generate()
    }

}

let generator = RandomNumberGenerator()
let service = SomeService(generator: generator)
let number = service.nextNumber()
```

`SomeService` requires something that implements `NumberGenerator`, but it doesn't care about what specific implementation it's using. If some point in the future we wanted to use a Fibonacci number generator, all we'd have to do is create a `FibonacciNumberGenerator` class which implements `NumberGenerator` and pass that to `SomeService` when we initialise it. The `SomeService` class wouldn't need to change at all.

## Unit testing with Dependency Injection

How would you test `SomeService`'s `nextNumber()` method is returning the correct number if you used our first example? It would be pretty hard!

If we use the second example we could make a mock number generator and get it to return the numbers of our choice when setting up the test.

```swift
final class MockNumberGenerator: NumberGenerator {

    let numbers: [Int]
    private var index = 0

    init(numbers: [Int]) {
        self.numbers = numbers
    }

    func generate() -> Int {
        let number = numbers[index % numbers.count]
        index += 1
        return number
    }

}

final class SomeServiceTests: XCTestCase {

    var service: SomeService!

    override func setUp() {
        super.setUp()
        let generator = MockNumberGenerator(numbers: [1, 2, 3, 4, 5])
        self.service = SomeService(generator: generator)
    }

    override func tearDown() {
        self.service = nil
        super.tearDown()
    }

    func testNextNumberReturnsCorrectNumbers() {
        XCTAssertEqual(service.nextNumber(), 1)
        XCTAssertEqual(service.nextNumber(), 2)
        XCTAssertEqual(service.nextNumber(), 3)
        XCTAssertEqual(service.nextNumber(), 4)
        XCTAssertEqual(service.nextNumber(), 5)
    }

}
```

Using a mock number generator lets us unit test `SomeService` in isolation. It doesn't matter what implementation of `NumberGenerator` we actually use with `SomeService` or if we change it at a later date, this test case and its tests will still be valid and won't need to change.

## How to use Dependency Injection in Real Life?

### Easiest way - To it yourself

The quickest and easiest way to start using dependency injection is to use Swift's default parameter value feature.

e.g.

```swift
final class SomeService {

    private let generator: NumberGenerator

    init(generator: NumberGenerator = RandomNumberGenerator()) {
        self.generator = generator
    }

    func nextNumber() -> Int {
        generator.generate()
    }

}
```

Then we create our `SomeService`:

```swift
let service = SomeService()
```

It also allows us to inject a different `NumberGenerator` if we want, or when we test it.

```swift
let generator = SomeOtherNumberGenerator()
let service = SomeService(generator: generator)
```

### Dependency Injection Frameworks

There are several Swift Dependency Frameworks out there. A few are,

* [Resolver](https://github.com/hmlongco/Resolver)
* [Cleanse](https://github.com/square/Cleanse)
* [Swinject](https://github.com/Swinject/Swinject)

They allow you to setup a Dependency Injection container and then resolve dependencies when you need them. They tend to deal with or warn you about cyclic dependencies too, something which the 'Do it yourself' way doesn't.

On the other hand, your whole codebase is tied to the framework you use. If at some point you want to use a different framework it's not always easy to rip out the old one.
