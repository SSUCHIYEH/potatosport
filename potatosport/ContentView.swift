//
//  ContentView.swift
//  potatosport
//
//  Created by ruby0926 on 2022/6/10.
//


//import RealityKit
//import ARKit
import SwiftUI
import AVFoundation

struct CameraView:View{
   @StateObject var camera = CameraModel()
    
    let predictor = Predictor()
    
    var body :some View{
        ZStack{
            //going to be camera preview
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all,edges: .all)
        }
        .onAppear(perform: {
            camera.Check()
            
        })
    }
}

class CameraModel:ObservableObject{
    @Published var session = AVCaptureSession()
    @Published var alert = false
    
    //since were going to read pic date...
    @Published var output = AVCapturePhotoOutput()
    
    //preview...
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    func Check(){
        //first checking camera premission
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            
            setUp()
            return
            //Setting Up Session
        case .notDetermined:
            //retustion for permission...
            AVCaptureDevice.requestAccess(for: .video){(status) in
                if status{
                    self.setUp()
                }
            }
        case.denied:
            self.alert.toggle()
            return
        default:
            return
        }
        
    }
    func setUp() {
        //setting up camera...
        do{
            //settinh configs...
            self.session.beginConfiguration()
            
            //change for your own
            let device =
            AVCaptureDevice.default(.builtInWideAngleCamera, for:.video,position:.front)
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            //checking and adding to session...
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            //same for output...
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            self.session.commitConfiguration()
            
            
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
}
//setting view for preview...
struct CameraPreview:UIViewRepresentable{
    
    @ObservedObject var camera : CameraModel
    
    
    func makeUIView(context: Context) ->  UIView {
        
        let view = UIView(frame:UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        //your own properties...
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        //starting session
        camera.session.startRunning()
        
        return view
        
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
}




struct ContentView: View {
    var body: some View {
       // Text("Hello, world!")
         //   .padding()
        CameraView()
      
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
