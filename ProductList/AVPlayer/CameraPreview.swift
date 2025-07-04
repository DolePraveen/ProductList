import SwiftUI

struct CameraPreview: UIViewRepresentable {
    let recorder: CameraRecorder

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        recorder.startSession(in: view)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct ContentView: View {
    @StateObject private var recorder = CameraRecorder()

    var body: some View {
        VStack {
            CameraPreview(recorder: recorder)
                .frame(height: 400)

            HStack {
                Button("Start Recording") {
                    recorder.startRecording()
                }
                .padding()
                
                Button("Stop Recording") {
                    recorder.stopRecording()
                }
                .padding()
            }
        }
    }
}
