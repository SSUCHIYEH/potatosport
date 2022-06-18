//
//  ContentView.swift
//  potatosport
//
//  Created by ruby0926 on 2022/6/10.
//

import SwiftUI
import UIKit
import AVFoundation
import AudioToolbox

let videoCapture = VideoCapture()
var previewLayer : AVCaptureVideoPreviewLayer?

var pointsLayer = CAShapeLayer()
var isRunDetected = false


struct CameraPreview:UIViewRepresentable{
  
    func makeUIView(context: Context) ->  UIView {
        
        
        let view = UIView(frame:UIScreen.main.bounds)
        
        videoCapture.startCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: videoCapture.captureSession)
        
        //初始化
        guard let previewLayer = previewLayer else { return view }
        
        view.layer.addSublayer(previewLayer)
        previewLayer.frame=view.frame
        
     //   videoCapture.predictor.delegate = slef
        return view
        
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
}

struct ContentView: View {
    
   
    
    var body: some View {
//        Text("Hello, world!")
//            .padding()
        CameraPreview()
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


class Predictors : PredictorDelegate{
    func predictor(_ predictor: Predictor, didLabelAction action: String, with confidence: Double) {
        //自行設定預測後要幹嘛
//        if action == "run" && confidence > 0.95 && isRunDetected == false{
//            print("You Run!!!")
//            isRunDetected = true
//
//            DispatchQueue.main.asyncAfter(deadline: .now()+1){
//                self.isRunDetected = false
//
//            }
//            DispatchQueue.main.async{
//                AudioServicesPlayAlertSound(SystemSoundID(1322))
//            }
//        }
        if action == "run"{
            print("You Run!!!")
        }else{
            print("nothing")
        }
    }
    
    func predictor(_ predictor: Predictor, didFindNewRecognizedPoints points: [CGPoint]) {
        
        guard let previewLayer = previewLayer else {return}
        
        let convertedPoints = points.map{
            previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
        }
        let combinedPath = CGMutablePath()
        
        for point in convertedPoints{
            let dotPath = UIBezierPath(ovalIn: CGRect(x:point.x,y:point.y,width:10,height:10))
            combinedPath.addPath(dotPath.cgPath)
        }
        
        pointsLayer.path = combinedPath
        DispatchQueue.main.async{
           // self.pointsLayer.didChangeValue(for: \.path)
        }
    }
    
    
}
