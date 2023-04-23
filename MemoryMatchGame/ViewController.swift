//
//  ViewController.swift
//  MemoryMatchGame
//
//  Created by Uriya Sabah on 4/20/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblMovesMade: UILabel!
    
    @IBOutlet weak var lblMovesLeft: UILabel!
    
    @IBOutlet weak var lblPopUpText: UILabel!
    
    var brain = Brain()
    var lastFlipped = -1
    var subview: UIView?
    var retryButton: UIButton?
    var goBackButton: UIButton?
    let subViewTag = 36
    let retryButtonTag = 40
    let goBackButtonTag = 41
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblMovesMade.text = String(brain.movesMade)
        lblMovesLeft.text = String(brain.movesLeft)
        subview = view.viewWithTag(subViewTag)
        subview?.alpha = 0.0
        retryButton = view.viewWithTag(retryButtonTag) as? UIButton
        goBackButton = view.viewWithTag(goBackButtonTag) as? UIButton
        retryButton?.isHidden = true
        goBackButton?.isHidden = true
    }

    
    @IBAction func btnClick(_ sender: UIButton) {
        var newLabel: String
        var timeDelay: Bool
        
        let label = sender.titleLabel?.text ?? ""
        let tag = sender.tag
        (newLabel, timeDelay) = brain.updateState(btnLabel: label, btnTag: tag)
        
        sender.setTitle(newLabel, for: UIControl.State.normal)
        sender.titleLabel?.text = newLabel
        sender.setBackgroundImage(UIImage(), for: UIControl.State.normal)
        lblMovesLeft.text = String(brain.movesLeft)
        lblMovesMade.text = String(brain.movesMade)
        
        //check for win
        if brain.boardWin(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                //incorrect popup
                self.subview?.backgroundColor = UIColor(named: "gold")
                self.lblPopUpText.text = self.getWinText()
                self.lblPopUpText.font = UIFont.systemFont(ofSize: 30)
                self.lblPopUpText.textColor = UIColor(named: "green")
                self.retryButton?.isHidden = false
                self.goBackButton?.isHidden = false
                self.subview?.alpha = 1
            }
        }
        
        //check if the user lost
        else if brain.boardLose(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                self.lblPopUpText.text = self.getLoseText()
                self.lblPopUpText.font = UIFont.systemFont(ofSize: 30)
                self.retryButton?.isHidden = false
                self.goBackButton?.isHidden = false
                self.subview?.alpha = 1
            }
        }
        
        //check if time delay is necessary (bad move)
        else if timeDelay{
            //delay
            guard let otherButton = view.viewWithTag(lastFlipped) as? UIButton else{
                print("There are multiple views with tag \(lastFlipped)")
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                //incorrect popup
                self.subview?.alpha = 0.7
            }
            //run code after 0.75 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                //incorrect popup
                //set current card back to hidden
                sender.setTitle("", for: UIControl.State.normal)
                sender.titleLabel?.text = ""
                sender.setBackgroundImage(UIImage(named: "okc_thunder_logo.jpeg") as UIImage?, for: UIControl.State.normal)
                
                //set other card back to hidden
                otherButton.setTitle("", for: UIControl.State.normal)
                otherButton.titleLabel?.text = ""
                otherButton.setBackgroundImage(UIImage(named: "okc_thunder_logo.jpeg") as UIImage?, for: UIControl.State.normal)
                self.subview?.alpha = 0.0 //show board again
            }
        }
        lastFlipped = tag //update last flipped card
    }
    
    func getWinText() -> String{
        return "You Win!\nScore: \(brain.currentScore)\nHigh Score: \(brain.highScore)"
    }
    
    func getLoseText() -> String{
        return "You Lose!\nScore: \(brain.currentScore)\nHigh Score: \(brain.highScore)"
    }
    
    @IBAction func btnClickRestart(_ sender: UIButton) {
        brain.reset()
        //reset backgrounds and labels
        for tag in 0..<20{
            let button = view.viewWithTag(tag) as? UIButton
            button?.setTitle("", for: UIControl.State.normal)
            button?.titleLabel?.text = ""
            button?.setBackgroundImage(UIImage(named: "okc_thunder_logo.jpeg") as UIImage?, for: UIControl.State.normal)
        }
        //hide buttons
        retryButton?.isHidden = true
        goBackButton?.isHidden = true
        //hide subview
        subview?.alpha = 0
    }
    
}

