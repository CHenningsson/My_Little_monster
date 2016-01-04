//
//  ViewController.swift
//  mylittlemonster
//
//  Created by Carl Henningsson on 1/3/16.
//  Copyright © 2016 Carl Henningsson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var penelty1Img: UIImageView!
    @IBOutlet weak var penelty2Img: UIImageView!
    @IBOutlet weak var penelty3Img: UIImageView!
    @IBOutlet weak var resetImg: UIButton!
    @IBOutlet weak var livesPanel: UIImageView!
    @IBOutlet weak var welconImg: UIStackView!
    @IBOutlet weak var textImg: UIStackView!
    @IBOutlet weak var playArrow: UIStackView!
    @IBOutlet weak var playBtn: UIButton!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENELTIES = 3
    
    var penelties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    //sound effects
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImg.dropOnTarget = monsterImg
        heartImg.dropOnTarget = monsterImg
        
        penelty1Img.alpha = DIM_ALPHA
        penelty2Img.alpha = DIM_ALPHA
        penelty3Img.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        //audioplayer
        do {
//            alterativ
//            let resourcePath = NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!
//            let url = NSURL(fileURLWithPath: resourcePath)
//            try musicPlayer = AVAudioPlayer(contentsOfURL: url)
            
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }

    @IBAction func playBtn(sender: AnyObject) {
        textImg.hidden = true
        playArrow.hidden = true
        welconImg.hidden = true
        playBtn.hidden = true
        
        startTimer()
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        heartImg.alpha = DIM_ALPHA
        
        foodImg.userInteractionEnabled = false
        heartImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxBite.play()
        } else {
            sfxHeart.play()
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }

    func changeGameState() {
        
        if !monsterHappy {
            
        penelties++
            
        sfxSkull.play()
        
        if penelties == 1 {
            penelty1Img.alpha = OPAQUE
            penelty2Img.alpha = DIM_ALPHA
        } else if penelties == 2{
            penelty2Img.alpha = OPAQUE
            penelty3Img.alpha = DIM_ALPHA
        } else if penelties >= 3{
            penelty3Img.alpha = OPAQUE
        } else {
            penelty1Img.alpha = DIM_ALPHA
            penelty2Img.alpha = DIM_ALPHA
            penelty3Img.alpha = DIM_ALPHA
        }
        
        if penelties >= MAX_PENELTIES {
            gameOver()
        }
    }
        let rand = arc4random_uniform(2) //0 or 1
        
        if rand == 0 {
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
        } else {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
        }
        
        currentItem = rand
        monsterHappy = false
}
    
    func hidden() {
        penelty1Img.hidden = true
        penelty2Img.hidden = true
        penelty3Img.hidden = true
        livesPanel.hidden = true
        foodImg.hidden = true
        heartImg.hidden = true
    }
    
    func show() {
        penelty1Img.hidden = false
        penelty2Img.hidden = false
        penelty3Img.hidden = false
        livesPanel.hidden = false
        foodImg.hidden = false
        heartImg.hidden = false
        
        foodImg.userInteractionEnabled = true
        heartImg.userInteractionEnabled = true
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathIdleAnimation()
        sfxDeath.play()
        hidden()
        resetImg.hidden = false
    }

    @IBAction func resetImgAction(sender: AnyObject) {
        viewDidLoad()
        monsterImg.playIdleAnimation()
        show()
        startTimer()
        penelties = 0
        resetImg.hidden = true
    }
    
}















