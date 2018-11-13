//
//  ViewController.swift
//  BubblePop
//
//  Created by ChengZhu on 2018/5/1.
//  Copyright © 2018年 UTS. All rights reserved.
//

import UIKit
import GameKit

class GameScene: UIViewController {
    
    var setTime: Int = 0
    var setNum: Int = 0
    var playerName : String = ""
    var bubbleNumMax: UInt32 = 15
    var bubbleNumMin: UInt32 = 1
    var timer : Timer!
    var score : Int = 0
    var lastpoints = 0
    var combo = 0
    var thisGameRecord : [String : Int] = [:]
    var gameRecord : [String : Int] = [:]
    var sortedHighScores : [(key:String, value:Int)] = []
    
    let randomSource: GKRandomSource = GKARC4RandomSource()
    // for random postion of bubbles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let isNil = UserDefaults.standard.dictionary(forKey: "HighScores")
        if isNil == nil {
            bestLabel.text = "0"
        }
        else {
            let gameRecord = UserDefaults.standard.dictionary(forKey: "HighScores") as! [String : Int]
            sortedHighScores = gameRecord.sorted { $0.value > $1.value }
            // sort the player data
            bestLabel.text = String(sortedHighScores[0].value)
        }
        // check if the player data is nil ,if not, present the best score
        
        timeLeft.text = String(setTime)
        // present the set time
        timer = Timer.scheduledTimer(timeInterval: 1 ,target:self, selector: #selector(self.timeCount), userInfo: nil, repeats: true)
        // set the timer, call the timeCount function every second
        
        bubbleNumMax = UInt32(setNum+1)
        let newBubbleNum = arc4random_uniform(bubbleNumMax - bubbleNumMin) + bubbleNumMin
        for _ in 1...newBubbleNum {
            bubbleCreate()
        } // create a random number of bubbles for the first second and the number should be less than the set number
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var bestLabel: UILabel!
    @IBOutlet weak var comboNum: UILabel!
    
    @objc func timeCount() {
        setTime -= 1
        timeLeft.text = String(setTime) // present the rest time
        
        for view in self.view.subviews {
            if view is BubbleView {
                view.removeFromSuperview()
            }
        } // refresh the view every second
        
        if setTime == 0 {
            timer.invalidate()
            // stop the timer when the time runs out
            
            thisGameRecord = [ playerName : score]
            
            let isNil = UserDefaults.standard.dictionary(forKey: "HighScores")
            if isNil == nil {
                UserDefaults.standard.set(thisGameRecord, forKey: "HighScores")
            } // if thers is no player data yet, create the save the new record
            else {
                gameRecord = UserDefaults.standard.dictionary(forKey: "HighScores") as! [String : Int]
                
                if gameRecord[playerName] != nil { // check if the player already exists
                    if gameRecord[playerName]! < score {
                        gameRecord[playerName] = score
                    }
                } // if it's a exist player , save the higher score
                else {
                    gameRecord[playerName] = score
                } // if it's a new player, save the data
                
                UserDefaults.standard.set(gameRecord, forKey: "HighScores")
                // update the player data
            }
            
            let lastView = self.storyboard?.instantiateViewController(withIdentifier: "HighScore") as! HighScore
            self.present(lastView, animated: true, completion: nil)
            // game over and change to the last view when time runs out
        }
        
        let newBubbleNum = arc4random_uniform(bubbleNumMax - bubbleNumMin) + bubbleNumMin
        for _ in 1...newBubbleNum {
                bubbleCreate()
        } // create the bubbles for each second
    }
    
    func bubbleCreate(){
        var positionArray : [Int] = bubblePositionRandom()
        // get the random postion
        
        let positionX = positionArray[0]
        let positionY = positionArray[1]
        let bubbleView = BubbleView(frame: CGRect(x: Double(positionX), y: Double(positionY), width: 90, height: 90))
        // create the bubble in random position
        
        let colorName = randomBubbleType()
        if colorName == "red"{ bubbleView.points = 1 }
        else if colorName == "pink"{ bubbleView.points = 2 }
        else if colorName == "green"{ bubbleView.points = 5 }
        else if colorName == "blue"{ bubbleView.points = 8 }
        else if colorName == "black"{ bubbleView.points = 10 }
        // set the points of the bubble according to the color
        
        let bubbleImage = UIImage.init(imageLiteralResourceName: colorName)
        bubbleView.setImage(bubbleImage, for: UIControlState.normal)
        // set the image of the bubble
        
        var validLocation = true
        for subview in self.view.subviews {
            if let existingBubble = subview as? BubbleView {
                if existingBubble.frame.intersects(bubbleView.frame) {
                    validLocation = false
                    break
                }
            }
        }
        if validLocation {
            bubbleView.addTarget(self, action: #selector(bubbleTapped(_:)), for: .touchUpInside)
            self.view.addSubview(bubbleView)
        }// make the bubbles not overlap each other
        
    }
    
    
    @IBAction func bubbleTapped(_ sender: BubbleView) {
        if sender.points == lastpoints {
            // check if it's the combo
            self.score += Int(Double(sender.points) * 1.5)
            // calculate the combo points
            sender.removeFromSuperview()
            // remove the tapped bubblt
            scoreLabel.text = String(score)
            // present the new score
            lastpoints = sender.points
            // store the combo color by points
            combo += 1
            // count the combo
        }
        else{
            self.score += sender.points
            sender.removeFromSuperview()
            scoreLabel.text = String(score)
            lastpoints = sender.points
            combo = 0
            // clear the combo if a bubble of different color is tapped
        }
        comboNum.text = String(combo)
        // present the combo in the label
    }
    
    func randomBubbleType() -> String {
        var bag: [String] = []
        for _ in 1...40 {
            bag.append("red")
        }
        for _ in 1...30 {
            bag.append("pink")
        }
        for _ in 1...15 {
            bag.append("green")
        }
        for _ in 1...10 {
            bag.append("blue")
        }
        for _ in 1...5 {
            bag.append("black")
        }
        let choice: Int = randomSource.nextInt(upperBound: bag.count)
        return bag[choice]
    }
    // generate the color of the bubble randomly
    
    func bubblePositionRandom() -> [Int] {
        let randomX = CGFloat(randomSource.nextUniform()) * (self.view.frame.width-100)
        var randomY = CGFloat(randomSource.nextUniform()) * (self.view.frame.height-100)
        if randomY < 120{
            randomY += 120
        }
        return [Int(randomX), Int(randomY)]
    }
    // generate the random postion of the bubble and can't block the label on the top
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

