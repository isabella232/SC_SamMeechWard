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
@testable import BDDFrameworkTutorial


class PlayerUpgraderTests: XCTestCase {
  
  var upgrader: PlayerUpgrader!
  var player: Player!
  
  override func setUp() {
    super.setUp()
    player = try! Player(lives: 0, levelsComplete: 0)
    upgrader = PlayerUpgrader(player: player)
  }
  
  // MARK: Player Lives
  
  func test_addMoreLivesWith0Lives_Adds0NewLivesToPlayer() {
    try? upgrader.upgradeLives(by: 0)
    XCTAssertEqual(player.lives, 0);
  }
  
  func test_addMoreLivesWithXLives_AddsXNumberOfLivesToPlayer_WhenPlayerStartsWithNoLives() {
    try? upgrader.upgradeLives(by: 1)
    XCTAssertEqual(player.lives, 1);
  }
  
  func test_addMoreLivesWithNegativeLives_ThrowsAnError() {
    XCTAssertThrowsError(try upgrader.upgradeLives(by: -1))
  }
  
  func test_addMoreLivesWithMoreThanMaximumNumberLives_SetsPlayersLivesToMaximumNumberOfLives_WhenPlayerStartsWithNoLives() {
    try? upgrader.upgradeLives(by: Player.maximumLives+1)
    XCTAssertEqual(player.lives, Player.maximumLives);
  }
  
  func test_addMoreLives_SetsPlayersLivesToMaximumNumberOfLives_WhenPlayerStartsWithMaximumLives() {
    try? player.set(lives: Player.maximumLives)
    try? upgrader.upgradeLives(by: 1)
    XCTAssertEqual(player.lives, Player.maximumLives);
  }
  
  // MARK: Player Levels Complete
  
  func test_upgradeLevel_Adds1ToThePlayersLevelsComplete() {
    try? player.set(levelsComplete: 0)
    upgrader.upgradeLevel()
    XCTAssertEqual(player.levelsComplete, 1);
  }
  
}
