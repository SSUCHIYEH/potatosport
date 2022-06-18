//
//  VideoCapture.swift
//  potatosport
//
//  Created by 蔡瑀 on 2022/6/18.
//

import Foundation
import AVFoundation

class VideoCapture: NSObject {
    
    let captureSession = AVCaptureSession()
    let videoOuput = AVCaptureVideoDataOutput()  //獲取相機資訊
    
    let predictor = Predictor()//1. 識別並存取每一幀中人體姿勢相關數據 2. 根據data去猜測動作
    
    override init(){
        super.init()
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for:.video,position:.front),
              let input = try? AVCaptureDeviceInput(device: captureDevice)else{return}
        
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high  //輸出的質量調高
        captureSession.addInput(input)
        
        captureSession.addOutput(videoOuput)
        videoOuput.alwaysDiscardsLateVideoFrames = true  //丟棄延遲的frame
        
    }
    func startCaptureSession(){
        captureSession.startRunning()
        videoOuput.setSampleBufferDelegate(self, queue: DispatchQueue(label:"videoDispatchQueue"))
    }
}

extension VideoCapture:AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //let videoData = sampleBuffer
        //print(videoData)
        predictor.estimation(sampleBuffer:sampleBuffer)
    }
}

