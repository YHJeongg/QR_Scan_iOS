//
//  QRCodeReader.swift
//  QRScan
//
//  Created by Jeong Yun Hyeon on 2023/06/01.
//

import MLKit
import AVFoundation

protocol QRCodeReaderDelegate: AnyObject {
    func qrCodeReader(_ qrCodeReader: QRCodeReader, didScan url: URL)
    func qrCodeReader(_ qrCodeReader: QRCodeReader, didScan text: String)
}

class QRCodeReader: NSObject {

    weak var delegate: QRCodeReaderDelegate?

    private let barcodeScanner: BarcodeScanner = {
        let barcodeOptions = BarcodeScannerOptions(formats: .qrCode)
        let barcodeScanner = BarcodeScanner.barcodeScanner(options: barcodeOptions)
        return barcodeScanner
    }()

    func scan(sampleBuffer: CMSampleBuffer) {
        let image = VisionImage(buffer: sampleBuffer)
        
        image.orientation = imageOrientation(
            deviceOrientation: UIDevice.current.orientation,
            cameraPosition: .back)

        barcodeScanner.process(image) { [weak self] barcodes, error in
            guard let self = self,
                  error == nil,
                  let barcodes = barcodes,
                  !barcodes.isEmpty else { return }

            var scannedUrl: URL?
            var scannedText: String?
                        
            for barcode in barcodes {
                if let urlString = barcode.url?.url {
                    scannedUrl = URL(string: urlString)
                    break
                } else if let text = barcode.rawValue {
                    scannedText = text
                    break
                }
            }
            
            if let url = scannedUrl {
                self.delegate?.qrCodeReader(self, didScan: url)
            } else if let text = scannedText {
                self.delegate?.qrCodeReader(self, didScan: text)
            }
        }
    }

    private func imageOrientation(deviceOrientation: UIDeviceOrientation,
                                  cameraPosition: AVCaptureDevice.Position) -> UIImage.Orientation {
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftMirrored : .right
        case .landscapeLeft:
            return cameraPosition == .front ? .downMirrored : .up
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightMirrored : .left
        case .landscapeRight:
            return cameraPosition == .front ? .upMirrored : .down
        case .faceDown, .faceUp, .unknown:
            return .up
        @unknown default:
            fatalError()
        }
    }
}
