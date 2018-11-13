//
//  HighScore.swift
//  BubblePop
//
//  Created by ChengZhu on 2018/5/1.
//  Copyright © 2018年 UTS. All rights reserved.
//

import UIKit

class HighScore: UIViewController {
    var gameRecord : [String : Int] = [:]
    // this dictionary to store the player data
    var sortedHighScores : [(key:String, value:Int)] = []
    //  this array to store the sorted player data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gameRecord = UserDefaults.standard.dictionary(forKey: "HighScores") as! [String : Int]
        sortedHighScores = gameRecord.sorted { $0.value > $1.value }
        if sortedHighScores.count >= 1 {
            firstname.text = sortedHighScores[0].key
            firstscore.text = String(sortedHighScores[0].value)
        }
        if sortedHighScores.count >= 2 {
            secondname.text = sortedHighScores[1].key
            secondscore.text = String(sortedHighScores[1].value)
        }
        if sortedHighScores.count >= 3 {
            thirdname.text = sortedHighScores[2].key
            thirdscore.text = String(sortedHighScores[2].value)
        }
}
    
    @IBOutlet weak var firstname: UILabel!
    @IBOutlet weak var secondname: UILabel!
    @IBOutlet weak var thirdname: UILabel!
    @IBOutlet weak var firstscore: UILabel!
    @IBOutlet weak var secondscore: UILabel!
    @IBOutlet weak var thirdscore: UILabel!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
