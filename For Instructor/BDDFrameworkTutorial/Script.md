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

Hey what’s up everybody, this is Brian and in this video, I'm going to show you how to test your iOS apps using a BDD testing framework.

_BDD_ or _Behavior Driven Development_ is a process that emerged from test-driven development in 2006. The topic of BDD covers the entire life cycle of the app development process, from planning the project, to writing the code.

BDD encourages you to specify the behavior of your app in terms of user stories which are broken down into scenarios that can be built and tested. 

BDD is broken down into three steps: arrange, act, and assert. First **arrange** any data that you need to test your code. Next, act or run the code that you're testing. And finally, assert. That is, make sure the code did what it was supposed to.

We'll take a look at how to structure tests for better code reuse and readability using the `Quick` and `Nimble` BDD frameworks for swift. 

Before I start, I want to give a big thanks to Sam Meech who is the author of this screencast. Thanks Sam!

Let's dive in.

## Demo

I'll get started by  installing the `Quick` and `Nimble` frameworks. 

_Quick_ is the BDD testing framework. It outlines the structure of my tests. Nimble is the assertion library. It gives me readable assertions through a domain specific language.

First I open my terminal and navigate to my project. Next I navigate to my project and type `pod init`. 

```
pod init
```
In the BDDFrameworkTutorialTests target, I add both the Quick and the Nimble framework.

```ruby
pod 'Quick'
pod 'Nimble'
```

When that is done, I save the podfile ans switch back to my terminal and install the pod.

```
pod install
```

With the dependencies installed, I open the project to take a look around. 

The first thing I do is update the project to the reccommended settings and then I build my project for running and for testing.

Okay, now for the code.  I have the start of a new iOS game. Right now It just has two classes, a `Player` and a `PlayerUpgrader`.

The `Player` class holds the current state of the player's lives and levels completed. It also exposes methods for reading and writing to these properties.

The `PlayerUpgrader` class is responsible for any upgrades that happen to the player object. Upgrading the player's lives or levels happens through this class.

There are also some unit tests that have been written for the player upgrader using the built in `XCTest` framework. These tests currently assert that the `upgradeLives` method works as expected. It only upgrades lives in the positive direction and can't give the player more than the maximum allowed lives.

These tests are fine, but there are some obvious downfalls. The main one is that they are a little bit difficult to read, and it's not immediately obvious what's being tested.

To get started, I'll create a new test class. This class inherits`QuickSpec` which also inherits from `XCTestCase`. I'll call this class `PlayerUpgraderSpec`. It's best practice to end any subclasses of `QuickSpec` with the word `Spec`.

```
class PlayerUpgraderSpec: QuickSpec {

}

```

With that in place, I need to import 3 things; the project I'm testing, Quick, and Nimble.

```swift
@testable import BDDFrameworkTutorial
import Quick
import Nimble
```

Every `QuickSpec` subclass needs to override the `spec()` method. This is the method that gets executed when you run your tests.

```swift
override func spec() {
}
```

Every test follows that same basic pattern, first you use `Quick`'s `describe` function to describe what your testing. This function, accepts a string and a closure.


```swift
describe(".upgradeLives()"
```

The string should indicate what I'm testing, in this case it's the `upgradeLives` method. Most of the time, a describe function will be describing a function or method; it's good practice to show this in your tests by adding a dot before the method name. 


```swift
describe(".upgradeLives()") {
  
}
```

The next parameter is a closure that accepts no parameters and has no return value.

Now all the code that tests the `.upgradeLives()` method, should go inside of this closure. 

Next, I use a `context` function to group together tests related to a shared situation, condition, or state.

I am not just testing any call to the `upgradeLives` method. The first test is only interested in when it's called with `0` lives. This test also assumes that the current player has 0 lives. So I can use the `context` function to make these things explicit in plain english. 

```swift
context("when the player has no lives") {
  context("with an upgrade amount of 0") {
  }
}
```

When writing the message for context, it's common to start the description with "when" or "with".

Now all the test inside the second context closure will be testing the `upgradeLives` method when it's called with `0` and the player has `0` lives. All I'm doing right now is creating some organized structure for writing my tests.

Notice that `context` and `describe` look very similar, that's because they're the same function. `context` is just a typealias of `describe`. But I use `describe` to indicate the thing I'm testing, and `context` to indicate conditions and state. You don't _need_ to add a context function, use them only when it helps organize the tests.

Lastly, inside the `describe` or `context`, I'll add an `it` function. the `it` function also accepts a string and closure, but inside the it's closure, I make my assertions.

The string parameter for the `it` function should provide a human-readable description of the outcome of the test.

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

To test this method, I need to create a new player and a new upgrader with that player. Then I need to try upgrading the lives by 0.

```swift
let player = Player()
let upgrader = PlayerUpgrader(player: player)
try? upgrader.upgradeLives(by: 0)
```

Now I just need to assert that the player still has 0 lives. I could use my old friend `XCTAssert` here, but instead, I'm going to write my tests in a much more readable way using `Nimble`. `Nimble` allows me to express expectations using a natural, easily understood language. 

Using nimble, I can write it like this as 

```
expect(player.lives).to(equal(0))
```

Following red green refactor, I first make the test fail.

```
expect(player.lives).to(equal(1))
```

When I run my test, I get a message letting me know the expected result is 1 but got 0.

Now I correct the issue and the run the test again.

```
expect(player.lives).to(equal(0))
```

This time I get green and my test is running.

## Camera

As you can see, writing BDD tests are somewhat different from our typical unit tests. 

You can see there are words like `describe`, `context`, `it`, and `expect`. It all reads in plain english. Someone who is not a developer could understand what is being tested here. 

These all print out to the console as well, so if you're running the tests from a command line, you can read what's passing and failing. 

## Demo

The next thing I'm going to do in PlayerUpgraderSpec.swift is test that the upgrader adds a certain amount of lives to the player when I pass it a number that doesn't exceed the maximum number of lives.

So when the player has 0 lives, and  with an upgrade amount that is less than the maximum lives then it should increment the player's lives by upgrade amount

```swift
describe(".upgradeLives()") {
    context("when the player has no lives") {
      context("with an upgrade amount of 0") {
       ... 
      }
      // add here
      context("with an upgrade amount that is less than the maximum lives") {
        it("should increment the player's lives by upgrade amount") {
        }
      }
    }
  }
}
```

Again, I need a new `player` and `playerUpgrader` object, but I don't want to duplicate code here, what I need to do is move this code to a setup function that runs before each test.

Using `Quick` I can add a `beforeEach` function at the top of the spec function to create a new player and upgrader

```swift
override func spec() {
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
remove
let player = Player()
let upgrader = PlayerUpgrader(player: player)
```

And continue with the next test.

I will be calling the `upgradeLives` method and to get the test to fail, I set the equal amount to be a 100 

```
try? upgrader.upgradeLives(by: 1)
expect(player.lives).to(equal(100))`
```
When I run the test, it fails as expected. 

```
expect(player.lives).to(equal(100))`
```

Now, I provide the expected result and it passes.

The next thing I'm going to test is that if the player already has the maximum number of lives, then I can't upgrade their lives any more.

```swift
context("when the player has no lives") {
  ...
}
context("when the player's lives are full") {
  it("should not change the value of the player's lives") {
  }
}
```

So the first thing I have to do here is modify the user so that its lives are set to the maximum number of lives. And I want this to happen for every test inside the `when the player's lives are full` closure. 

I've used the `beforeEach` function to run code before every single test, but I can also add a `beforeEach` function to any `describe` or `context` closure too. That will run code before every test inside that specific closure. 

```swift
beforeEach {

}
```

Using beforeEach, I set the player's lives to the maximum lives

```swift
beforeEach {
  try? upgrader.upgradeLives(by: Player.maximumLives)
}
```

That code will be executed after the `beforeEach` in the outer score, but before any `it` functions inside this `context`

By the time the code inside this `it` function runs, the player will have the maximum number of lives. So I now just need to try upgrading the lives and I expect that the player's lives will not change.

```swift
it("should not change the value of the player's lives") {
  try? upgrader.upgradeLives(by: 1)
  expect(player.lives).to(equal(Player.maximumLives-1))
}
```

First I test the red state, and as expected, it fails. I correct the issue and as expected, the test goes green.

```
expect(player.lives).to(equal(Player.maximumLives))
```

## Camera

You may have noticed that there is some code duplication here. Every test is calling the `upgradeLives` method and then expecting `player.lives` to equal something. Most of the code is the same, it's just the values that are changing. So how can we remove this duplication?

An important thing to remember when writing tests, weather you're using a BDD framework or not, is that you're still just writing normal swift code. So how do you solve code duplcation in a normal swift app? Move the duplicate code to a function.

## Demo


Back in PlayerUpgraderSpec.swift, I'm going to create a new function inside the `upgradeLives` description. I'll call it expectUser toHaveLives and I can put the duplicate code in here

```swift
describe(".upgradeLives()") {
  func expectUser(toHaveLives expectedLives: Int,   afterUpgradingLives upgradeLives: Int) {
  try? upgrader.upgradeLives(by: upgradeLives)
  expect(player.lives).to(equal(expectedLives))
}
```

and call this function from each of my tests.


```swift

    
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

And now, I have my tests running like before only without the code duplication. Good stuff all around.

## Conclusion

Alright, that’s everything I’d like to cover in this video. 

At this point you should be able to start testing your app using `Quick` and `Nimble`.

I **expect** you'll want to try it out right away. **it should** be fun!
