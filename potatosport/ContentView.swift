//
//  ContentView.swift
//  potatosport
//
//  Created by ruby0926 on 2022/6/10.
//


//import PlaygroundSupport
import RealityKit
import SwiftUI
import ARKit

// 5. Create BodySkeleton entity to visualize and update joint pose
class BodySkeleton :Entity{
    var joints:[String:Entity]=[:]//jointNames mapped to jointEntities
    
    required init(for bodyAnchor : ARBodyAnchor) {
        super.init()
        //6. Create entity for each joint in skeleton
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames{
            //Default values for joint appearance
            var jointRadius:Float=0.03
            var jointColor:UIColor = .green
            
            //12. Set color and size based on specific jointName
            //NOTE: Green joints are actively tracked by ARkit.Yellow joints are not tracked. They just follow the motion of the closest green parent.
            
            
            //Create an entity for the joint,add joints dictionary,and add it to the parent entity(i.e. bodySkeleton)
            let jointEntity = makeJoint(radius:jointRadius,color:jointColor)
            joints[jointName]=jointEntity
            self.addChild(jointEntity)
        }
        
        
        self.update(with: bodyAnchor)
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    
    
    // 7. Create helper method to create a sphere-shaped entity with specified radius and color for a joint
    
    func makeJoint(radius:Float,color:UIColor)->Entity{
        let mesh = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color:color,roughness: 0.8,isMetallic: false)
        let modelEntity = ModelEntity(mesh:mesh,materials: [material])
        
        return modelEntity
    }
    // 8. Create method to update the position and orientation of each jointEntity
    func update(with bodyAnchor:ARBodyAnchor){
        let rootPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames{
            if let jointEntity = joints[jointName],let jointTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: jointName)){
                let jointOffset = simd_make_float3(jointTransform.columns.3)
                jointEntity.position = rootPosition + jointOffset
                jointEntity.orientation = Transform(matrix: jointTransform).rotation
            }
        }
    }


}

// 9. Create global variables for BodySkeleton
var bodySkeleton:BodySkeleton?
var bodySkeletonAnchor = AnchorEntity()



// 3. create ARViewContainer
struct ARViewContainer:UIViewRepresentable{
    typealias UIViewType = ARView
    func makeUIView(context: Context) -> ARView {
        let arView=ARView(frame: .zero,cameraMode: .ar,automaticallyConfigureSession: true)
        
        // 10.add bodySkeletonAnchor to sence
        arView.scene.addAnchor(bodySkeletonAnchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
    }
    
    
    //func makeUIView(context: UIViewRepresentableContext<ARViewContainer>) -> some UIView {
      //  let arView=ARView(frame: .zero,cameraMode: .ar,automaticallyConfigureSession: true)
        
        // 10.add bodySkeletonAnchor to sence
       // arView.scene.addAnchor(bodySkeletonAnchor)
        
      //  return arView
   // }
   // func updateUIView(_ uiView: ARView, context: UIViewRepresentableContext<ARViewContainer>) {
        
   // }
}

//4. Extend ARView to implement body tracking functionality
extension ARView:ARSessionDelegate{
    //4a. Configure ARView for body tracking
    func setupForBodyTracking(){
        let config = ARBodyTrackingConfiguration()
        self.session.run(config)
        
        self.session.delegate = self
    }
    
    //4b. Implement ARSession didUpdate anchors delegate method
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let bodyAnchor = anchor as? ARBodyAnchor{
             //  print("Updated bodyAnchor.")
                
                
              //  let skeleton = bodyAnchor.skeleton
                
              //  let rootJointTransform = skeleton.modelTransform(for: .root)!
              //  let rootJointPosition = simd_make_float3(rootJointTransform.columns.3)
              //  print("root:\(rootJointPosition)")
                
              //  let leftHandTransform = skeleton.modelTransform(for: .leftHand)!
              //  let leftHandOffset = simd_make_float3(leftHandTransform.columns.3)
              //  let leftHandPostion = rootJointPosition + leftHandOffset
              //  print("leftHand:\(leftHandPostion)")
                
                
                
        //11. Create or Update bodySkeleton
                if let skeleton = bodySkeleton{
                    // BodySkeleton already exists,update pose of all joints
                    skeleton.update(with: bodyAnchor)
                }else{
                    //seeinh body for tje first time,create bodySkeleton
                    let skeleton = BodySkeleton(for: bodyAnchor)
                    bodySkeleton = skeleton
                    bodySkeletonAnchor.addChild(skeleton)
                }
            }
        }
    }
    
   
}


struct ContentView: View {
    var body: some View {
       // Text("Hello, world!")
       //     .padding()
        return ARViewContainer();
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
