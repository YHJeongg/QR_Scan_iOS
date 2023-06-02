//
//  CameraViewModel.swift
//  QRScan
//
//  Created by Jeong Yun Hyeon on 2023/05/31.
//

import SwiftUI
import AVFoundation
import Combine
import MLKit

class CameraViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private var qrCodeReader: QRCodeReader?
    private let model: Camera
    private let session: AVCaptureSession
    private var subscriptions = Set<AnyCancellable>()
    private var isCameraBusy = false
    
    let cameraPreview: AnyView
    let hapticImpact = UIImpactFeedbackGenerator()

    @Published var recentImage: UIImage?
    @Published var shutterEffect = false
    @Published var scannedURL: URL?
    @Published var showAlert = false
    @Published var scannedText: String?
    
    // 초기 세팅
    func configure() {
        model.requestAndCheckPermissions()
    }
    
    // 사진 촬영
    func capturePhoto() {
        if isCameraBusy == false {
            hapticImpact.impactOccurred()
            withAnimation(.easeInOut(duration: 0.1)) {
                shutterEffect = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.shutterEffect = false
                }
            }
            
            model.capturePhoto()
        }
    }
    
    // 전후면 카메라 스위칭
    func changeCamera() {
        model.changeCamera()
        print("[CameraViewModel]: Camera changed!")
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if qrCodeReader == nil {
            qrCodeReader = QRCodeReader()
            qrCodeReader?.delegate = self
        }
        
        qrCodeReader?.scan(sampleBuffer: sampleBuffer)
    }
    
    override init() {
        model = Camera()
        session = model.session
        cameraPreview = AnyView(CameraPreviewView(session: session))
        
        super.init()
        
        session.beginConfiguration()
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              session.canAddInput(videoDeviceInput) else {
            fatalError("Could not configure video input")
        }
        
        session.addInput(videoDeviceInput)
        
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .userInteractive))
        
        guard session.canAddOutput(videoDataOutput) else {
            fatalError("Could not configure video data output")
        }
        
        session.addOutput(videoDataOutput)
        session.commitConfiguration()
        
        model.$recentImage.sink { [weak self] (photo) in
            guard let pic = photo else { return }
            self?.recentImage = pic
        }
        .store(in: &self.subscriptions)
    }
}

extension CameraViewModel: QRCodeReaderDelegate {
    // URL 형식의 QR 코드 처리
    func qrCodeReader(_ qrCodeReader: QRCodeReader, didScan url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            // 스캔된 URL이 웹 페이지 URL인 경우 Safari를 사용하여 웹 페이지로 이동
            UIApplication.shared.open(url)
            scannedText = url.absoluteString
        } else {
            // 스캔된 URL이 웹 페이지 URL이 아닌 경우 정보를 화면에 표시
            scannedURL = nil
            scannedText = url.absoluteString
        }
        showAlert = true
    }
    
    // 텍스트 형식의 QR 코드 처리
    func qrCodeReader(_ qrCodeReader: QRCodeReader, didScan text: String) {
        scannedURL = nil
        scannedText = text
        showAlert = true
    }
}
