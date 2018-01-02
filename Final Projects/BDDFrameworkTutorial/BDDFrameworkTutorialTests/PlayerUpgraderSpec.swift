///// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest
import Quick
import Nimble
@testable import BDDFrameworkTutorial

class PlayerUpgraderSpec: QuickSpec {
  
  override func spec() {
    
    var player: Player!
    var upgrader: PlayerUpgrader!
    beforeEach {
      player = Player()
      upgrader = PlayerUpgrader(player: player)
    }
    
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
        
        context("with an upgrade amount that is negative") {
          it("should throw an error") {
            expect{try upgrader.upgradeLives(by: -1)}.to(throwError())
          }
        }
        
        context("with an upgrade amount that is more than the maximum lives") {
          it("should set player's lives to the maximum lives") {
            expectUser(toHaveLives: Player.maximumLives, afterUpgradingLives: Player.maximumLives+1)
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
    
    describe(".upgradeLevel()") {
      
      it("should increment the player's level by 1") {
        let levelsComplete = player.levelsComplete
        upgrader.upgradeLevel()
        expect(player.levelsComplete).to(equal(levelsComplete+1))
      }
    }
  }
}

