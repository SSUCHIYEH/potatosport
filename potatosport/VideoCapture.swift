//
//  VideoCapture.swift
//  potatosport
//
//  Created by ruby0926 on 2022/6/17.
//

import Foundation
import AVFoundation
import SwiftUI


class VideoCapture: NSObject{
    let captureSession = AVCaptureSession()
    
    let output = AVCaptureVideoDataOutput()
    
    let predictor = RunPredictor()
    
    override init() {
        super.init()
//        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video,position: .front),
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video,position: .back),
            let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        captureSession.addInput(input)
        
        captureSession.addOutput(output)
        output.alwaysDiscardsLateVideoFrames = true
    }
    

    func startCaptureSession(){
        print("startCaptureSession")
        captureSession.startRunning()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoDispatchQueue")
        )
    }
    
//    func setUp(){
//        do{
//            self.captureSession.beginConfiguration()
//            guard let device = AVCaptureDevice.default(.builtInDualCamera,for: .video,position: .front) else {return}
//            let input = try AVCaptureDeviceInput(device: device)
//            print("input",input)
//            if self.captureSession.canAddInput(input){
//                self.captureSession.addInput(input)
//            }
//            captureSession.addOutput(output)
//            output.alwaysDiscardsLateVideoFrames = true
//
//            self.captureSession.commitConfiguration()
//        }catch{
//            print(error.localizedDescription)
//        }
//    }
    
    
    
}

extension VideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        let videoData = sampleBuffer
//        print(videoData)
        predictor.estimation(sampleBuffer: sampleBuffer)
    }
    
//    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//
//        let videoData = sampleBuffer
//        print(videoData)
//        print("portoco call estimation")
//        predictor.estimation(sampleBuffer: sampleBuffer)
//    }
}
