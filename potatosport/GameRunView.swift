//
//  GameRunView.swift
//  potatosport
//
//  Created by 蔡瑀 on 2022/6/22.
//

import SwiftUI
import SceneKit

struct GameRunView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> GameRunViewController {
        GameRunViewController()
    }

    func updateUIViewController(_ uiViewController: GameRunViewController, context: Context) {
    }
    typealias UIViewControllerType = GameRunViewController
}

class GameRunViewController: UIViewController{
    override func viewDidLoad() {
        setupScene()
    }
    func setupScene(){
        
    }
    override var shouldAutorotate: Bool{
        return false
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
