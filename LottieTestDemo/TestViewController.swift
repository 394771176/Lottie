//
//  TestViewController.swift
//  LottieTestDemo
//
//  Created by cheng on 2019/9/7.
//  Copyright © 2019 cheng. All rights reserved.
//

import UIKit
import Lottie

class TestViewController: ViewController {
    var animationView : AnimationView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        
        do {
            let btn = UIButton.init();
            btn.frame = CGRect.init(x: 100, y: 100, width: 100, height: 50);
            btn.backgroundColor = UIColor.green
            btn.addTarget(self, action: #selector(btnaction), for: UIControl.Event.touchUpInside)
            self.view.addSubview(btn);
        }
        
        do {
            let btn = UIButton.init();
            btn.frame = CGRect.init(x: 100, y: 200, width: 100, height: 50);
            btn.backgroundColor = UIColor.blue
            btn.addTarget(self, action: #selector(self.btnaction1), for: UIControl.Event.touchUpInside)
            self.view.addSubview(btn);
        }
        
    }
    
    @objc func btnaction()  {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func btnaction1()  {
        if (animationView == nil) {
            animationView = AnimationView.init(frame: CGRect.init(x: 0, y: 300, width: self.view.frame.width, height: 400))
            animationView.frame = CGRect.init(x: 0, y: 300, width: 300, height: 300);
            let str = Bundle.main.path(forResource: "animation/11icons", ofType: "json")
            let ani = Animation.filepath(str!)
            animationView.animation = ani
            animationView.loopMode = LottieLoopMode.loop
            animationView.backgroundColor = UIColor.black
            self.view.addSubview(animationView)
            
            animationView.play(fromProgress: 0, toProgress: 1, loopMode: LottieLoopMode.loop, completion: nil)
            
        }
    }
}
