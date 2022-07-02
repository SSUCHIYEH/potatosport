//
//  RunActionClassify.swift
//  potatosport
//
//  Created by ruby0926 on 2022/6/17.
//

import UIKit
import AVFoundation
import SwiftUI

struct RunActionView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> RunActionViewController {
        RunActionViewController()
    }

    func updateUIViewController(_ uiViewController: RunActionViewController, context: Context) {
    }
    typealias UIViewControllerType = RunActionViewController
}

class RunActionViewController: UIViewController{
    
    let videoCapture = VideoCapture()
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var pointsLayer = CAShapeLayer()
    
    var isRunDetected = false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        SetupVedioPreview()
        videoCapture.predictor.delegate = self
    }
    
    private func SetupVedioPreview(){
        videoCapture.startCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: videoCapture.captureSession)
        
        
        guard let previewLayer = previewLayer else {return}
        
        
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .landscapeRight
        
        view.layer.addSublayer(pointsLayer)
        pointsLayer.frame = view.frame
        pointsLayer.strokeColor = UIColor.green.cgColor
    }
}
   


extension RunActionViewController: PredictorDelegate {

    func predictor(_ predictor: RunPredictor, didLabelAction action: String, with confidence: Double) {
//        print(action)
//        if action == "run" {
//            isRunDetected = true
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                self.isRunDetected = false
//            }
//
//            DispatchQueue.main.async {
//                AudioServicesPlayAlertSound(SystemSoundID(1322))
//            }
//
//        }
        if action == "run" {
            running = true
            if startgame{
              pos -= 0.1
            }
            print("run!!!!!!!!!!!!!")
            
        }else{
            print("none")
            scanbody = true
        }
    }

    func predictor(_ predictor: RunPredictor, didFindNewRecognizedPoints points: [CGPoint]) {
        guard let previewLayer = previewLayer else {return}

        let convertedPoints = points.map {
            previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
        }

        let combinedPath = CGMutablePath()

        for point in convertedPoints {
            let dotPath = UIBezierPath(ovalIn: CGRect(x: point.x, y: point.y, width: 10, height: 10))
            combinedPath.addPath(dotPath.cgPath)
        }

        pointsLayer.path = combinedPath

        DispatchQueue.main.async {
            self.pointsLayer.didChangeValue(for: \.path)
        }
    }
}

