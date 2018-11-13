//
//
//  BubblePop
//
//  Created by ChengZhu on 2018/5/1.
//  Copyright © 2018年 UTS. All rights reserved.
//
//  The first scene which users input the player name and set the time and bubble numbers

import UIKit

class Setting: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet weak var playerNameText: UITextField!
    @IBOutlet weak var gameDurationLabel: UILabel!
    @IBOutlet weak var bubbleNumLabel: UILabel!
    
    @IBAction func setGameDuration(_ sender: UISlider) {
        gameDurationLabel.text = String(Int(sender.value))
    } // the game duration label shows the value of the game duration slider
    
    @IBAction func setBubbleNum(_ sender: UISlider) {
        bubbleNumLabel.text = String(Int(sender.value))
    } //  the bubble number label shows the value of the bubble number slider
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startGame" {
            if let gameScene = segue.destination as? GameScene {
                gameScene.playerName = playerNameText.text!
                gameScene.setTime = Int(gameDurationLabel.text!)!
                gameScene.setNum = Int(bubbleNumLabel.text!)!
            }
        }
    }  // send the settings and username to GameScene view 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //收回键盘
        self.view.endEditing(false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
