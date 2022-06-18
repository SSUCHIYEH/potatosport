//
//  RunActionClassify.swift
//  potatosport
//
//  Created by ruby0926 on 2022/6/17.
//

import UIKit
import AVFoundation

import SwiftUI

struct RunActionDetectedView: View{
//    @StateObject var camera = RunActionViewDetectedController()
    
    var body: some View {
//        VStack{
//            CameraPreview(camera: camera)
//                .ignoresSafeArea(.all, edges: .all)
//        }
        VStack{
            RunActionView()
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera : RunActionViewDetectedController
    
    func makeUIView(context: Context) -> UIView {
        camera.startCaptureSession()
        print("makeUIView")
        let view = UIView(frame: UIScreen.main.bounds)
        
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.captureSession)
        camera.preview.frame = view.frame
//        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}


class RunActionViewDetectedController: NSObject, ObservableObject{
    
    @Published var captureSession = AVCaptureSession()
    
    @Published var alert = false
    
    @Published var output = AVCaptureVideoDataOutput()
    
    @Published var preview : AVCaptureVideoPreviewLayer!
      
    
//    func check(){
//        print("相機授權？？")
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized:
//            print("相機授權")
//            self.setUp()
//            return
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video) { (status) in
//                if status {
//                    self.setUp()
//                }
//            }
//        case .denied:
//            self.alert.toggle()
//            return
//        default:
//            return
//        }
//    }
    
    
    override init() {
        super.init()
        print("object init")
        guard let device = AVCaptureDevice.default(for:.video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        captureSession.addInput(input)
        
        captureSession.addOutput(output)
        output.alwaysDiscardsLateVideoFrames = true
        
//        if self.captureSession.canAddInput(input){
//            self.captureSession.addInput(input)
//        }
//        if self.captureSession.canAddOutput(output){
//            self.captureSession.addOutput(output)
//        }
//        output.alwaysDiscardsLateVideoFrames = true
        
        
//        do{
//            self.captureSession.beginConfiguration()
//            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
//                print("被回絕了")
//                return
//
//            }
//            let input = try AVCaptureDeviceInput(device: device)
//            if self.captureSession.canAddInput(input){
//                self.captureSession.addInput(input)
//            }
//            if self.captureSession.canAddOutput(output){
//                self.captureSession.addOutput(output)
//            }
//            output.alwaysDiscardsLateVideoFrames = true
//        }catch{
//            print("deviceError")
//        }
    }
    
    func startCaptureSession(){
        print("startCaptureSession")
        captureSession.startRunning()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoDispatchQueue")
        )
    }
}


extension RunActionViewDetectedController:AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("進來")
        let videoData = sampleBuffer
        print(videoData)
    }
}

