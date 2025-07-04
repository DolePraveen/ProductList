import SwiftUI

struct PhotoCaptureViewLiveCamera: View {
    @StateObject private var viewModel = CameraViewModel()

        var body: some View {
            ZStack(alignment: .bottom) {
                PhotoCaptureView(viewModel: viewModel)
                    .edgesIgnoringSafeArea(.all)

                Button(action: {
                    viewModel.takePhoto()
                }) {
                    Text("📸 Take Photo")
                        .font(.headline)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .padding(.bottom, 40)
            }
        }
    }
