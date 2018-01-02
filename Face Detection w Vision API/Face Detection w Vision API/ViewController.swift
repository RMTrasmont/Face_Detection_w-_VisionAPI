//
//  ViewController.swift
//  Face Detection w Vision API
//
//  Created by Rafael M. Trasmontero on 1/1/18.
//  Copyright © 2018 LetsBuildTuts. All rights reserved.
//

import UIKit
import Vision
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let sampleImage = UIImage(named: "IMG2") else {return}
        let imageView = UIImageView(image: sampleImage)
        imageView.contentMode = .scaleAspectFit
        let scaledHeight = view.frame.width / sampleImage.size.width * sampleImage.size.height
        imageView.frame = CGRect(x:0, y: 0, width: view.frame.width, height:scaledHeight)
        imageView.backgroundColor = UIColor.brown
        
        view.addSubview(imageView)
        
        //VISION API*******************************************************
        let faceRequest = VNDetectFaceRectanglesRequest { (request, err) in
            
            if let error = err {
                print("ERROR:",error)
                return
            }
    
            print("REQUEST:",request)
            
            request.results?.forEach({ (result) in
                
                //Get back on main thread
                DispatchQueue.main.async {
                    print("RESULT:",result)
                    
                    guard let faceObservation = result as? VNFaceObservation else {return}
                    //*Prints an Array, Multiple faces in some images equal multiple face detections with their dimension
                    print("FACEOBSERVATION BOUNDINGBOX:",faceObservation.boundingBox)  //<-- [x,y,width,height]
                    
                    //Use the printed "FACEOBSERVATION BOUNDINGBOX:" Values to draw around recognized faces
                    let box_X = self.view.frame.width * faceObservation.boundingBox.origin.x
                    let box_Width = self.view.frame.width * faceObservation.boundingBox.width
                    let box_Height = scaledHeight * faceObservation.boundingBox.height
                    let box_Y = scaledHeight * (1 - faceObservation.boundingBox.origin.y) - box_Height
                    
                    let yellowView = UIView()
                    yellowView.backgroundColor = UIColor.yellow
                    yellowView.alpha = 0.4
                    yellowView.frame = CGRect(x: box_X, y: box_Y, width: box_Width, height: box_Height)
                    self.view.addSubview(yellowView)
                    
                }
                
            })
        
        }
        
        guard let cgSampleImage = sampleImage.cgImage else {return}
        
        //Run request on background
        DispatchQueue.global(qos: .background).async {
            let requestHandler = VNImageRequestHandler(cgImage: cgSampleImage, options: [:] )
            do{
                try requestHandler.perform([faceRequest])
            } catch let reqErr {
                print("REQUEST ERROR:",reqErr)
            }
        }
        //VISION API*******************************************************
    
    }
    



}

