//
//  Brain.swift
//  MemoryMatchGame
//
//  Created by Uriya Sabah on 4/20/23.
//

import Foundation

struct Node {
    var symbol: String
    var matched: Bool
}

class Brain{
    var movesMade: Int //represents the number of moves the user has made
    var movesLeft: Int //represents the number of moves remaining
    var lastFlipped: Int //represents the last flipped non-matched card
    var cardState: [[Node]] //represents the state of the card labels and whether they have been matched
    var currentScore: Int //represents the user's current score
    var highScore: Int //represents the tracked high score
    
    init() {
        lastFlipped = -1
        movesMade = 0
        movesLeft = 20
        let num_rows = 5
        let num_cols = 4
        let tmp_emojies = ["\u{1F600}","\u{1F600}", "\u{1F972}", "\u{1F972}", "\u{1F911}", "\u{1F911}", "\u{1F47B}", "\u{1F47B}", "\u{1F525}", "\u{1F525}", "\u{1F4A5}", "\u{1F4A5}", "\u{1F91F}", "\u{1F91F}", "\u{1F64F}", "\u{1F64F}", "\u{1F440}", "\u{1F440}", "\u{1F9E0}", "\u{1F9E0}"].shuffled()
        cardState = [[],[],[],[],[]]
        for index in 0..<num_rows*num_cols{
            let emoji = tmp_emojies[index]
            let row = index/4
            cardState[row].append(Node(symbol: emoji, matched: false))
            }
        currentScore = movesLeft*2
        highScore = 0
    }
    
    func reset(){
        lastFlipped = -1
        movesMade = 0
        movesLeft = 20
        let num_rows = 5
        let num_cols = 4
        let tmp_emojies = ["\u{1F600}","\u{1F600}", "\u{1F972}", "\u{1F972}", "\u{1F911}", "\u{1F911}", "\u{1F47B}", "\u{1F47B}", "\u{1F525}", "\u{1F525}", "\u{1F4A5}", "\u{1F4A5}", "\u{1F91F}", "\u{1F91F}", "\u{1F64F}", "\u{1F64F}", "\u{1F440}", "\u{1F440}", "\u{1F9E0}", "\u{1F9E0}"].shuffled()
        cardState = [[],[],[],[],[]]
        for index in 0..<num_rows*num_cols{
            let emoji = tmp_emojies[index]
            let row = index/4
            cardState[row].append(Node(symbol: emoji, matched: false))
        }
        currentScore = movesLeft*2
    }
    
    func numToRowCol(num: Int) -> (Int, Int){
        return (num/4, num%4)
    }
    
    func rowColToNum(row: Int, col: Int) -> Int{
        return row * 4 + col
    }
    
    func print_debug(){
        let num_rows = 5
        let num_cols = 4
        for row in 0..<num_rows{
            for col in 0..<num_cols{
                let index = rowColToNum(row: row, col: col)
                print("Node at postion \(index):")
                print("\tEmoji: \(cardState[row][index].symbol)")
                print("\tIs Matched: \(cardState[row][index].matched)")
            }
        }
    }
    
    func getNode(tag: Int) -> Node{
        let (row,col) = numToRowCol(num: tag)
        return cardState[row][col]
    }
    
    func getEmoji(tag: Int) -> String{
        let (row,col) = numToRowCol(num: tag)
        return cardState[row][col].symbol
    }
    
    func getMatch(tag: Int) -> Bool{
        let (row,col) = numToRowCol(num: tag)
        return cardState[row][col].matched
    }
    
    func alreadyMatched(tag:Int) -> Bool{
        let (row,col) = numToRowCol(num: tag)
        return cardState[row][col].matched
    }
    
    func isMatch(tag1: Int, tag2: Int) -> Bool{
        let match = getEmoji(tag: tag1) == getEmoji(tag: tag2)
        if match{
            setMatch(tag1: tag1, tag2: tag2)
        }
        return match
    }
    
    func setMatch(tag1: Int, tag2: Int){
        var node1 = getNode(tag: tag1)
        var node2 = getNode(tag: tag2)
        node1.matched = true
        node2.matched = true
    }
    
    func boardWin() -> Bool{
        let num_rows = 5
        let num_cols = 4
        for tag in 0..<num_rows*num_cols{
            if (!getMatch(tag: tag)){
                return false
            }
        }
        if currentScore > highScore{
            highScore = currentScore
        }
        return true
    }
    
    func boardLose() -> Bool{
        return movesLeft==0 && !boardWin()
    }
    
    //function to return the updated state of a card. Returns the updated label and a flag which represents whether the image should be displayed or not
    func updateState(btnLabel: String, btnTag: Int) -> (String, Bool){
        var timeDelay = false
        //check if the card is already matched
        if alreadyMatched(tag: btnTag) == true{ //cards already matched
            return (btnLabel, timeDelay) //do nothing
        }
        var label = btnLabel
        if label == ""{ //case where card is not showing
            label = getEmoji(tag: btnTag) //show card
            if lastFlipped >= 0{
                //check for match, match is handled in isMatch, otherwise handle non match
                if !isMatch(tag1: btnTag, tag2: lastFlipped) {
                    //tell UI to show card but for a few seconds delay
                    timeDelay = true
                    //MAYBE ADD LABEL/INCORRECT MESSAGE HERE??
                }
                movesMade += 1
                movesLeft -= 1
                lastFlipped = -1
                currentScore -= 2
                
            }
            else{ //otherwise remember which card was just flipped
                lastFlipped = btnTag
            }
        }
        
        return (label, timeDelay)
    }
    
}
