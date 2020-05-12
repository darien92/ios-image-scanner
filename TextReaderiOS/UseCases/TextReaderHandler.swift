//
//  TextReaderHandler.swift
//  TextReaderiOS
//
//  Created by Darién on 5/8/20.
//  Copyright © 2020 Darien. All rights reserved.
//

import UIKit
import FirebaseMLVision

class TextReaderHandler{
    private var textRecognizer:VisionTextRecognizer!
    var delegate: TextHandlerDelegate?
    
    init() {
        let vision = Vision.vision()
        textRecognizer = vision.onDeviceTextRecognizer()
    }
    
    func recognizeText(from image: UIImage){
        let visionImage = VisionImage(image: image)
        textRecognizer.process(visionImage) { (visionText, error) in
            self.processResult(from: visionText, error: error)
        }
    }
    
    private func processResult(from text: VisionText?, error:Error?){
        if let currError = error{
            delegate?.errorFetching(self, error: currError)
            return
        }else{
            if let imageText = text{
                let receivedText = imageText.text
                delegate?.textFetched(self, textReceived: receivedText)
            }else{
                delegate?.textNotFound(self)
            }
        }
    }
    
    func showAlert(body:String, containerViewController: UIViewController) {
        let alert = UIAlertController(title: "Alert", message: body, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        containerViewController.present(alert, animated: true, completion: nil)
    }
}


protocol TextHandlerDelegate {
    func textFetched(_ textReaderHandler: TextReaderHandler, textReceived:String)
    func errorFetching(_ textReaderHandler: TextReaderHandler, error:Error)
    func textNotFound(_ textReaderHandler: TextReaderHandler)
}
