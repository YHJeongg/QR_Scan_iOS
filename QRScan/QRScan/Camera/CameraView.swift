//
//  CameraView.swift
//  QRScan
//
//  Created by Jeong Yun Hyeon on 2023/05/31.
//

import SwiftUI
import AVFoundation
import MLKitBarcodeScanning

struct CameraView: View {
    @ObservedObject var viewModel = CameraViewModel()
    @State private var openPhoto = false
    @State private var selectImage = UIImage() // 갤러리 사진 선택 (미사용)

    var body: some View {
        ZStack {
            viewModel.cameraPreview.ignoresSafeArea()
                .onAppear {
                    viewModel.configure()
                }
                // 사진 촬영시 화면 깜빡임
                .opacity(viewModel.shutterEffect ? 0 : 1)
            
                // QR code Scan시 Alert로 정보 표시
                .alert(isPresented: $viewModel.showAlert) {
                    if let scannedURL = viewModel.scannedURL {
                        return Alert(title: Text("QR Code"), message: Text(scannedURL.absoluteString), dismissButton: .default(Text("OK")))
                    } else if let scannedText = viewModel.scannedText {
                        return Alert(title: Text("QR Code"), message: Text(scannedText), dismissButton: .default(Text("OK")))
                    } else {
                        return Alert(title: Text("QR Code"), message: nil, dismissButton: .default(Text("OK")))
                    }
                }
            VStack {
                Spacer()
                HStack{
                    // 찍은 사진 미리보기
                    Button(action: {
                        self.openPhoto = true
                    }) {
                        if let previewImage = viewModel.recentImage {
                            Image(uiImage: previewImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 75, height: 75)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .aspectRatio(1, contentMode: .fit)
                        } else {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 3)
                                .foregroundColor(.white)
                                .frame(width: 75, height: 75)
                        }
                    }
                    .padding()
                    .sheet(isPresented: $openPhoto) {
                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$selectImage)
                    }
                    
                    Spacer()
                    
                    // 사진찍기 버튼
                    Button(action: {viewModel.capturePhoto()}) {
                        Circle()
                            .stroke(lineWidth: 5)
                            .frame(width: 75, height: 75)
                            .padding()
                    }
                    
                    Spacer()
                    
                    // 전후면 카메라 교체
                    Button(action: {viewModel.changeCamera()}) {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                    }
                    .frame(width: 75, height: 75)
                    .padding()
                }
            
            }
            .foregroundColor(.white)
        }
    }
}


struct CameraPreviewView: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
             AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    let session: AVCaptureSession
   
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        
        // 카메라 세션 지정(필수)
        view.videoPreviewLayer.session = session
        // 기본 백그라운드 색을 지정
        view.backgroundColor = .black
        // 카메라 프리뷰 ratio 조절(fit, fill)
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        // 프리뷰 모서리에 corner radius를 결정
        view.videoPreviewLayer.cornerRadius = 0
        // 비디오 기본 방향 지정. .portrait이 세로모드.
        view.videoPreviewLayer.connection?.videoOrientation = .portrait

        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
