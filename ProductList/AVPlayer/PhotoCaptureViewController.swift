import AVFoundation
import UIKit

class PhotoCaptureViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    var captureSession: AVCaptureSession!
    var photoOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    func capturePhotoNow() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo

        guard let camera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: camera),
              captureSession.canAddInput(input) else {
            return
        }

        captureSession.addInput(input)

        photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.addOutput(photoOutput)

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(previewLayer, at: 0)
        print("DP_NewMarge")
        captureSession.startRunning()
    }


    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            print("Photo capture failed.")
            return
        }

        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        print("Photo captured and saved.")
    }
}


import SwiftUI

class CameraViewModel: ObservableObject {
    var controller: PhotoCaptureViewController?

    func takePhoto() {
        controller?.capturePhotoNow()
    }
}

import SwiftUI

struct PhotoCaptureView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: CameraViewModel

    func makeUIViewController(context: Context) -> PhotoCaptureViewController {
        let controller = PhotoCaptureViewController()
        viewModel.controller = controller // give SwiftUI access to UIKit controller
        return controller
    }

    func updateUIViewController(_ uiViewController: PhotoCaptureViewController, context: Context) {}
}
