//
//  ViewController.swift
//  SeeFood
//
//  Created by Slava on 28.04.2021.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        // Do any additional setup after loading the view.
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        here we used image that the user picked
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageView.image = userPickedImage
            
            imagePicker.dismiss(animated: true, completion: nil)
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }
//            and convert that image into CIImage
        
            detect(image: ciImage)
//            that pass that image into detect image method
        }
    }
        
        func detect(image: CIImage) {
            
            
            guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
                fatalError("Loading CoreML Model Failed")
            }
//            firstly we load up uor model, using the importet InceptionV3 model
            
            let requset = VNCoreMLRequest(model: model) { (request, error) in
//                and once the request is complete, it triggers a request or an error,
//                and we print out that classification results
                guard let results = request.results as? [VNClassificationObservation] else {
                    fatalError("Cannot make requset to have VNCore results")
                }
//                then we create a request that ask the model to classify whetever date we passed
           print(results)
                if let firstResult = results.first {
                    if firstResult.identifier.contains("hotdog"){
                        self.navigationItem.title = "Hot Dog"
                    } else {
                        self.navigationItem.title = "Not Hot Dog!"
                    }
                }
            }
            
            let handler = VNImageRequestHandler(ciImage: image)
//            and the data what we passed used over here, using a handler
            do {
                try handler.perform([requset])
//                then we using this handler to perform a request of classifying the image
            }
            catch {
                print(error)
            }
        }
        
       
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

