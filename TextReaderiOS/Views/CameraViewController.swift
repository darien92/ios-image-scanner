//
//  CameraViewController.swift
//  TextReaderiOS
//
//  Created by Darién on 5/7/20.
//  Copyright © 2020 Darien. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    @IBOutlet weak var takePictureBtn: UIButton!
    @IBOutlet weak var topBlur: UIVisualEffectView!
    @IBOutlet weak var leftBlur: UIVisualEffectView!
    @IBOutlet weak var rightBlur: UIVisualEffectView!
    @IBOutlet weak var bottomBlur: UIVisualEffectView!
    @IBOutlet weak var scanArea: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var captureSession = AVCaptureSession()
    var currentDevice:AVCaptureDevice?
    var photoOutput:AVCapturePhotoOutput?
    var imageTaken:UIImage?
    var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    var captureDeviceInput:AVCaptureDeviceInput?
    var photoSettings:AVCapturePhotoSettings?
    var textScanned:String?
    var textReaderHandler:TextReaderHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVars()
        initViews()
        initCamera()
    }
    
    private func initVars(){
        textReaderHandler = TextReaderHandler()
        textReaderHandler.delegate = self
    }
    
    private func initViews(){
        takePictureBtn.roundView()
    }
    
    private func showLoading(){
        takePictureBtn.isHidden = true
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    private func hideLoading(){
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        takePictureBtn.isHidden = false
    }

    private func initCamera(){
        //initializing device
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) else {
            return
        }
        currentDevice = device
        
        //configure the session
        photoOutput = AVCapturePhotoOutput()
        
        do{
            captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            captureSession.addInput(captureDeviceInput!)
            captureSession.addOutput(photoOutput!)
            cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            view.layer.addSublayer(cameraPreviewLayer!)
            cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            cameraPreviewLayer?.frame = view.layer.frame
            captureSession.startRunning()
            view.bringSubviewToFront(topBlur)
            view.bringSubviewToFront(leftBlur)
            view.bringSubviewToFront(rightBlur)
            view.bringSubviewToFront(bottomBlur)
            view.bringSubviewToFront(scanArea)
            view.bringSubviewToFront(takePictureBtn)
            view.bringSubviewToFront(loadingIndicator)
            loadingIndicator.isHidden = true
        }
        catch let error{
            print(error)
        }
    }
    @IBAction func takePicturePressed(_ sender: Any) {
        let photoSettings = AVCapturePhotoSettings()
        showLoading()
        photoOutput!.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @IBAction func btnFolderPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowSavedTextsSegue", sender: self)
    }
}

extension CameraViewController:AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let currError = error{
            print(currError)
            return
        }
        if let imageData = photo.fileDataRepresentation(){
            let currentImage = UIImage(data: imageData)
            imageTaken = currentImage!.cropImage(to: scanArea.frame, container: self.view)
            textReaderHandler.recognizeText(from: imageTaken!)
        }
    }
}

extension CameraViewController:TextHandlerDelegate{
    func textFetched(_ textReaderHandler: TextReaderHandler, textReceived: String) {
        self.textScanned = textReceived
        self.performSegue(withIdentifier: "ShowReadTextSegue", sender: self)
        hideLoading()
    }
    
    func errorFetching(_ textReaderHandler: TextReaderHandler, error: Error) {
        self.textReaderHandler.showAlert(body: "Error reading the text", containerViewController: self)
        hideLoading()
    }
    
    func textNotFound(_ textReaderHandler: TextReaderHandler) {
        self.textReaderHandler.showAlert(body: "Text not found", containerViewController: self)
        hideLoading()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ReadTextViewController{
            let destinationVC = segue.destination as? ReadTextViewController
            destinationVC?.text = textScanned
        }
    }
}

