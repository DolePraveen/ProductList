import AVFoundation
import UIKit

class CameraRecorder: NSObject, ObservableObject {
    private let session = AVCaptureSession()
    private var videoOutput: AVCaptureMovieFileOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    var preview: UIView?

    override init() {
        super.init()
        setupSession()
    }

    private func setupSession() {
        session.beginConfiguration()

        // Camera input
        guard let camera = AVCaptureDevice.default(for: .video),
              let cameraInput = try? AVCaptureDeviceInput(device: camera),
              session.canAddInput(cameraInput) else {
            print("Error setting up camera input")
            return
        }
        session.addInput(cameraInput)

        // Microphone input
        if let mic = AVCaptureDevice.default(for: .audio),
           let micInput = try? AVCaptureDeviceInput(device: mic),
           session.canAddInput(micInput) {
            session.addInput(micInput)
        }

        // Movie output
        let output = AVCaptureMovieFileOutput()
        if session.canAddOutput(output) {
            session.addOutput(output)
            self.videoOutput = output
        }

        session.commitConfiguration()
    }

    func startSession(in view: UIView) {
        preview = view
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.frame = view.bounds
        previewLayer?.videoGravity = .resizeAspectFill
        if let layer = previewLayer {
            view.layer.insertSublayer(layer, at: 0)
        }

        if !session.isRunning {
            session.startRunning()
        }
    }

    func stopSession() {
        if session.isRunning {
            session.stopRunning()
        }
    }

    func startRecording() {
        guard let output = videoOutput else { return }
        
        let fileName = "recording_\(UUID().uuidString).mov"
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documents.appendingPathComponent(fileName)
        
        output.startRecording(to: fileURL, recordingDelegate: self)
    }

    func stopRecording() {
        videoOutput?.stopRecording()
    }
}

extension CameraRecorder: AVCaptureFileOutputRecordingDelegate {
//    func fileOutput(_ output: AVCaptureFileOutput,
//                    didFinishRecordingTo outputFileURL: URL,
//                    from connections: [AVCaptureConnection],
//                    error: Error?) {
//        print("Video saved to: \(outputFileURL)")
//    }
//    
//    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
//        DispatchQueue.main.async {
//            let activityVC = UIActivityViewController(activityItems: [outputFileURL], applicationActivities: nil)
//            if let topVC = UIApplication.shared.windows.first?.rootViewController {
//                topVC.present(activityVC, animated: true)
//            }
//        }
//        print("Video saved to: \(outputFileURL)")
//
//    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection], error: Error?) {
        print("Attempting to share video: \(outputFileURL)")
        
        guard error == nil else {
            print("Recording failed: \(error!)")
            return
        }

        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: outputFileURL.path) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // small delay helps
                let activityVC = UIActivityViewController(activityItems: [outputFileURL], applicationActivities: nil)
                
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootVC = scene.windows.first?.rootViewController {
                    rootVC.present(activityVC, animated: true)
                } else {
                    print("Unable to get root view controller.")
                }
            }
        } else {
            print("File does not exist at: \(outputFileURL)")
        }
    }

    
}
