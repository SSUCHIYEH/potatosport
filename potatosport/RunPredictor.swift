//
//  RunPredictor.swift
//  potatosport
//
//  Created by ruby0926 on 2022/6/17.
//

import Foundation
import Vision
import UIKit

typealias RunningClassifier = runClassifier_2

protocol PredictorDelegate:AnyObject{
    func predictor(_ predictor: RunPredictor, didFindNewRecognizedPoints points:[CGPoint])
    func predictor(_ predictor: RunPredictor, didLabelAction action: String, with confidence: Double)
}
                                

class RunPredictor {
    weak var delegate: PredictorDelegate?
    
    let predictionWindowSize = 30
    var poseWindow:[VNHumanBodyPoseObservation] = []
    
    init() {
        print("predictor init")
        poseWindow.reserveCapacity(predictionWindowSize)
    }
    
    func bodyPoseHandler(request: VNRequest, error: Error?) {
        print("in bodyPoseHandler")
        guard let observations =
                request.results as? [VNHumanBodyPoseObservation] else {
            return
        }
        
        // Process each observation to find the recognized body pose points.
        observations.forEach { processObservation($0) }
        
        if let result = observations.first {
            storeObservation(result)
            labelActiontype()
        }
    }
    
    func estimation(sampleBuffer: CMSampleBuffer) {
//        guard let cgImage = UIImage(named: "bodypose")?.cgImage else { return }
        let requestHandler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up)
        let request = VNDetectHumanBodyPoseRequest(completionHandler: bodyPoseHandler)
        print(request)
        do {
            // Perform the body pose-detection request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the request: \(error).")
        }
        
        
    }
    
    
    func labelActiontype(){
        guard let throwingClassifier = try? runClassifier_2(configuration: MLModelConfiguration()),
              let poseMultiArray = prepareInputwithObservations(poseWindow),
              let predictions = try? throwingClassifier.prediction(poses: poseMultiArray) else {
            return
        }
        
        let label = predictions.label
        let confidence = predictions.labelProbabilities[label] ?? 0
        
        delegate?.predictor(self, didLabelAction: label, with: confidence)
        
    }
    
    func prepareInputwithObservations(_ observation: [VNHumanBodyPoseObservation]) -> MLMultiArray? {
        let numAvailableFramse = observation.count
        let observationNeeded = 30
        var multiArrayBuffer = [MLMultiArray]()
    
        for framIndex in 0 ..< min(numAvailableFramse, observationNeeded){
            let pose = observation[framIndex]
            do{
                let oneFrameMultiArray = try pose.keypointsMultiArray()
                multiArrayBuffer.append(oneFrameMultiArray)
            }catch{
                continue
            }
        }
        
        if numAvailableFramse < observationNeeded{
            for _ in 0 ..< (observationNeeded - numAvailableFramse) {
                do{
                    let oneFrameMultiArray = try MLMultiArray(shape: [1,3,18], dataType: .double)
                    try resetMultiArray(oneFrameMultiArray)
                    multiArrayBuffer.append(oneFrameMultiArray)
                }catch{
                    continue
                }
            }
        }
        
        return MLMultiArray(concatenating: [MLMultiArray](multiArrayBuffer), axis: 0, dataType: .float)
    
    }
    
    func resetMultiArray(_ predictionWindow: MLMultiArray,with value:Double = 0.0) throws {
        let pointer = try UnsafeMutableBufferPointer<Double>(predictionWindow)
        pointer.initialize(repeating: value)
    }
    
    
    func storeObservation(_ observation: VNHumanBodyPoseObservation){
        if poseWindow.count >= predictionWindowSize {
            poseWindow.removeFirst()
        }
        
        poseWindow.append(observation)
    }
    
    
    func processObservation(_ obsevation: VNHumanBodyPoseObservation) {
        print("in processObservation")
        do{
            let recognizePoint = try obsevation.recognizedPoints(forGroupKey: .all)
            var disPlayedPoints = recognizePoint.map{
                CGPoint(x: $0.value.x, y: 1 - $0.value.y)
            }
            delegate?.predictor(self, didFindNewRecognizedPoints: disPlayedPoints)
        } catch{
            print("error finding recognizedPoints")
        }
    }
}
