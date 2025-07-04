import SwiftUI

struct ProductDetailView: View {
    let product: Product
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: product.image)) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                Text(product.title).font(.title2).bold()
                Text(product.description)
                Text("\u{00A3}\(product.price, specifier: "%.2f")").bold()
            }.padding()
        }
        .navigationTitle("Details")
    }
}
