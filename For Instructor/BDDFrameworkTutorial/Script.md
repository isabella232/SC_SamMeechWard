# Screencast Metadata

## Screencast Title

Testing With a BDD Framework

## Screencast Description

Writing tests using `XCTest` alone can make it difficult to organize your tests and keep them readable and maintainable. Using a BDD testing framework helps solve these problems and makes it easier and more enjoyable to write tests. 

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4
* **Platform:** iOS 11
* **Editor**: Xcode 9


## Introduction

Hey what’s up everybody, this is Sam. In this video, I'm going to show you how to test your iOS apps using a BDD testing framework.

We'll take a look at how to structure your tests for better code reuse and readability using the `Quick` and `Nimble` BDD frameworks for swift. and we'll go over some best practices along the way.

Let's start with a brief overview of **BDD**

## Talking Head

### BDD 

_BDD_ or _Behavior Driven Development_ is a process that emerged from test-driven development in 2006. The topic of BDD covers the entire life cycle of the app development process, from planning the project, to writing the code.

BDD encourages you to specify the behavior of your app in terms of user stories which are broken down into scenarios that can be built and tested. 

The Topic of BDD is big enough that entire books have been written on the subject, but for today, we're just interested in a one part of BDD, testing with BDD frameworks.

### BDD Frameworks

When we write tests, we are testing the behavior of our code. If you were to test a function that 
sums two numbers together, you would create some numbers, call the function with those numbers, then write an assertion for what the function _should_ return. Some tests are more complicated than others, but every test will involve setting up some data, running some code that _should_ do something, and asserting that it does that thing.

**arrange**, **act**, **assert**.

* **arrange** any data that you need to test your code
* **act**, run the code that you're testing
* **assert** the code did what it was supposed to.

And before we even write any tests, we're already thinking about what we're testing. "If I run this function, with this data, it _should_ do this thing. But if I run it with _that_ data, it _should_ do _that_ thing"

The language we use when we're thinking about our tests, is our natural language. And it's consistent between tests. 

BDD testing frameworks are designed to make this repeated process of **arrange**, **act**, **assert**; much easier to implement, and they allow us to write out tests in a much more readable way that is easy to understand.

## Demo

### Quick and Nimble

Quick and Nimble have been some of the most popular BDD testing frameworks for Swift.

_Quick_ is the BDD testing framework. It outlines the structure of our tests.
_Nimble_ is the assertion library. It gives us readable assertions through a dsl.

One of my favorite things about BDD frameworks is that they are very consistent between other languages. Here's a BDD framework for Javascript https://mochajs.org/, and here's one for ruby http://rspec.info/

### The App

Let's take a look at the app we'll be testing.

I have the start of a new iOS game. Right now It just has two classes, a `Player` and a `PlayerUpgrader`.

* The `Player` class holds the current state of the player's lives and levels completed. It also exposes methods for reading and writing to these properties.

```swift
class Player {
  static let maximumLives = 3
  
  private var _lives = 0
  var lives: Int {
    return _lives
  }
  private var _levelsComplete = 0
  var levelsComplete: Int {
    return _levelsComplete
  }
  
  func set(lives: Int) throws {
    guard lives >= 0 else {
      throw PlayerError.invalidLives(lives)
    }
    _lives = lives
  }
  
  func set(levelsComplete: Int) {
    _levelsComplete = levelsComplete
  }
  
}
```

* The `PlayerUpgrader` class is responsible for any upgrades that happen to the player object. Upgrading the player's lives or levels happens through this class.

```swift
class PlayerUpgrader {
  private let player: Player
  
  init(player: Player) {
    self.player = player
  }
  
  func upgradeLives(by lives: Int) throws {
    let totalLives = player.lives + lives
    try player.set(lives: min(totalLives, Player.maximumLives))
  }
}
```

### The current tests

There are also some unit tests that have been written for the player upgrader using the built in `XCTest` framework. These tests currently assert that the `upgradeLives` method works as expected. It only upgrades lives in the positive direction and can't give the player more than the maximum allowed lives.

These tests are fine, but there are some obvious downfalls. The main one is that they are a little bit difficult to read, and it's not immediately obvious what's being tested.

Let's write some better tests using `Quick` and `Nimble`

### Installing the frameworks

Let's start by installing `Quick` and `Nimble`. All the information we need about these frameworks can be found at their github pages. If we navigate to `https://www.github.com/quick/quick` and click on the `Documentation` directory, we'll have access to examples, documentation, and installation instructions. I'm going to use cocoapods to install these, so I'll copy and past this code into my local podfile. 

```ruby
pod 'Quick'
pod 'Nimble'
```

Remember that we only need these frameworks within our test target.

```ruby
target 'BDDFrameworkTutorialTests' do
  inherit! :search_paths
  # Pods for testing
  pod 'Quick'
  pod 'Nimble'
end
```

Now run `pod install` to install these.

### Setting up the first test

Great, now that these are installed, let's start testing with them.

We're going to be re writing the `PlayerUpgraderTests` using `Quick` and `Nimble`.

Let's start by creating a new test class that will subclass `QuickSpec` which inherits from `XCTestCase`. We'll call this class `PlayerUpgraderSpec`. It's best practice to end any subclasses of `QuickSpec` with the word `Spec`.

Now that we have this class, we'll need to import 3 things; the project we're testing `@testable import BDDFrameworkTutorial`, Quick `import Quick`, and Nimble `import Nimble`.

```swift
@testable import BDDFrameworkTutorial
import Quick
import Nimble
```

Every `QuickSpec` subclass needs to override the `spec()` method. This is the method that gets executed when you run your tests. Inside this method is where all the tests for this class will go.

```swift
override func spec() {
}
```

##### Describe

Now that we've gotten the boilerplate code setup, let's write the first test. We're going to test that calling the `upgradeLives` method with the value `0`, will add `0` lives to the player.

Every test follows that same basic pattern, first you use `Quick`'s `describe` function to describe what your testing. This function, accepts a string and a closure.

The string should indicate what we’re testing, in this case it's the `upgradeLives` method. Most of the time, a describe function will be describing a function or method; it's good practice to show this in your tests by adding a dot before the method name. 

```swift
describe(".upgradeLives()"
```

The next parameter is a closure that accepts no parameters and has no return value.

```swift
describe(".upgradeLives()") {
  
}
```

Now all the code that tests the `.upgradeLives()` method, should go inside of this closure. This describe function is allowing us to group together all the tests for this method.

##### Context

Next, we can use a `context` function to group together tests related to a shared situation, condition, or state.

We are not just testing any call to the `upgradeLives` method, the first test is only interested in when it's called with `0` lives. This test also assumes that the current player has 0 lives. So we can use the `context` function to make these things explicit in plain english. 

```swift
context("when the player has no lives") {
  context("with an upgrade amount of 0") {
  }
}
```

When writing the message for context, it's common to start the description with "when" or "with".

Now all the test inside the second context closure will be testing the `upgradeLives` method when it's called with `0` and the player has `0` lives. All we're doing right now is creating some organized structure for writing our tests.

Notice that `context` and `describe` look very similar, that's because they're the same function. `context` is just a typealias of `describe`. But we use `describe` to indicate the thing we’re testing, and `context` to indicate conditions and state. You don't _need_ to add a context function, use them only when it helps organize the tests.

It's also important to note that describe and context functions can be nested as much as you like. As long as your making your tests more readable and organized, there's no limit to the number of nested closures here.

##### It

Lastly, inside the `describe` or `context`, we’ll add an `it` function. the `it` function also accepts a string and closure, but inside the it's closure, we make our assertions.

The string parameter for the `it` function should provide a human-readable description of the outcome of the test.

For this test, the `upgradeLives` method `"should increment the player's lives by 0"`

```swift
describe(".upgradeLives()") {
  context("when the player has no lives") {
    context("with an upgrade amount of 0") {
      it("should increment the player's lives by 0") {
      }
    }
  }
}
``` 

When writing an it description, it's common to start the description with the word "should". 

##### expect

It is inside the `it` function, that we make our assertions. This is where the actual testing happens.

To test this method, we need to create a new player `let player = Player()`, and a new upgrader with that player `let upgrader = PlayerUpgrader(player: player)`, then we need to try upgrading the lives by 0 `try? upgrader.upgradeLives(by: 0)`.


```swift
let player = Player()
let upgrader = PlayerUpgrader(player: player)
try? upgrader.upgradeLives(by: 0)
```

Now we just need to assert that the player still has 0 lives. We could use our old friend `XCTAssert` here, but instead, we're going to write our tests in a much more readable way using `Nimble`. `Nimble` allows us to express expectations using a natural, easily understood language. 

First, think about what you're expecting to happen. We expect that `player.lives` will be equal to `0`.

Using nimble, we can write it like this as `expect(player.lives).to(equal(0))`

Now we have a test. If we run the test, we can see that it passes.

#### Summary

Take a moment to look at what we've written so far. Read every `describe`, `context`, `it`, and `expect`. It all reads in plain english. Someone who is not a developer could understand what is being tested here. 

These all print out to the console as well, so if you're running the tests from a command line, you can read what's passing and failing. 

#### More tests

Let's add more tests.

The next thing we're going to test is that the upgrader adds a certain amount of lives to the player when we pass it a number that doesn't exceed the maximum number of lives.

So when the player has 0 lives, and `context("with an upgrade amount that is less than the maximum lives") {` then `it("should increment the player's lives by upgrade amount") {`

```swift
describe(".upgradeLives()") {
    context("when the player has no lives") {
      context("with an upgrade amount of 0") {
        it("should increment the player's lives by 0") {
          let player = Player()
          let upgrader = PlayerUpgrader(player: player)
          try? upgrader.upgradeLives(by: 0)
          expect(player.lives).to(equal(0))
        }
      }
      context("with an upgrade amount that is less than the maximum lives") {
        it("should increment the player's lives by upgrade amount") {
        }
      }
    }
  }
}
```

Again, I need a new `player` and `playerUpgrader` object, but I don't want to duplicate code here, what I need to do is move this code to a setup function that runs before each test.

Using `Quick` we can add a `beforeEach` function at the top of the spec function to create a new player and upgrader

```swift
var player: Player!
var upgrader: PlayerUpgrader!
beforeEach {
  player = Player()
  upgrader = PlayerUpgrader(player: player)
}
```

This will get executed before each test inside the spec method.

Now I can remove the player and upgrader setup code from my test

```swift
let player = Player()
let upgrader = PlayerUpgrader(player: player)
```

And continue with the next test.

We will be calling the `upgradeLives` method will a value larger than 0 but less than the maximum lives, `1` works. `try? upgrader.upgradeLives(by: 1)` and now we `expect(player.lives).to(equal(1))`

Run the tests again and they should pass.


The next thing we're going to test is that if the player already has the maximum number of lives, then we can't upgrade their lives any more.

So instead of when the player has no lives, `context("when the player's lives are full") {` the upgrade method `it("should not change the value of the player's lives") {`

```swift
context("when the player's lives are full") {
  it("should not change the value of the player's lives") {
  }
}
```

So the first thing we have to do here is modify the user so that its lives are set to the maximum number of lives. And we want this to happen for every test inside the `context("when the player's lives are full") {` closure. 

We've used the `beforeEach` function to run code before every single test, but we can also add a `beforeEach` function to any `describe` or `context` closure too. That will run code before every test inside that specific closure. 

If we add a `beforeEach` function to this closure 

```swift
beforeEach {

}
```

and set the player's lives to the maximum lives

```swift
beforeEach {
  try? upgrader.upgradeLives(by: Player.maximumLives)
}
```

then that code will be executed after the `beforeEach` in the outer score, but before any `it` functions inside this `context`

By the time the code inside this `it` function runs, the player will have the maximum number of lives. So we now just need to try upgrading the lives `try? upgrader.upgradeLives(by: 1)` and we expect that the player's lives will not change `expect(player.lives).to(equal(Player.maximumLives))`

```swift
it("should not change the value of the player's lives") {
  try? upgrader.upgradeLives(by: 1)
  expect(player.lives).to(equal(Player.maximumLives))
}
```

#### Custom Functions

You may have noticed that there is some code duplication here. Every test is calling the `upgradeLives` method and then expecting `player.lives` to equal something. Most of the code is the same, it's just the values that are changing. So how can we remove this duplication?

An important thing to remember when writing tests, weather you're using a BDD framework or not, is that you're still just writing normal swift code. So how do you solve code duplcation in a normal swift app? Move the duplicate code to a function.

Let's create a new function inside the `upgradeLives` description. We'll call it ` func expectUser(toHaveLives expectedLives: Int, afterUpgradingLives upgradeLives: Int)`. Then we can put the duplicate code in here

```swift
func expectUser(toHaveLives expectedLives: Int, afterUpgradingLives upgradeLives: Int) {
  try? upgrader.upgradeLives(by: upgradeLives)
  expect(player.lives).to(equal(expectedLives))
}
```

and call this function from each of our tests.


```swift
describe(".upgradeLives()") {
      
  func expectUser(toHaveLives expectedLives: Int, afterUpgradingLives upgradeLives: Int) {
    try? upgrader.upgradeLives(by: upgradeLives)
    expect(player.lives).to(equal(expectedLives))
  }
  
  context("when the player has no lives") {
    context("with an upgrade amount of 0") {
      it("should increment the player's lives by 0") {
        expectUser(toHaveLives: 0, afterUpgradingLives: 0)
      }
    }
    
    context("with an upgrade amount that is less than the maximum lives") {
      it("should increment the player's lives by upgrade amount") {
        expectUser(toHaveLives: 1, afterUpgradingLives: 1)
      }
    }
  }
  context("when the player's lives are full") {
    
    beforeEach {
      try? upgrader.upgradeLives(by: Player.maximumLives)
    }
    
    it("should not change the value of the player's lives") {
      expectUser(toHaveLives: Player.maximumLives, afterUpgradingLives:1)
    }
  }
}
```

## Conclusion

Alright, that’s everything I’d like to cover in this video. 

At this point you should be able to start testing your app using `Quick` and `Nimble`.

I **expect** you'll want to try it out right away. **it should** be fun!
