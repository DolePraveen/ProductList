import SwiftUI

struct ProductCard: View {
    let product: Product
    let isInCart: Bool
    let onHeartTap: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: product.image)) { image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            HStack {
                Text(product.title).font(.headline).lineLimit(1)
                Spacer()
                Button(action: onHeartTap) {
                    Image(systemName: isInCart ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }
            Text(product.description).lineLimit(2).font(.caption)
            Text("\u{00A3}\(product.price, specifier: "%.2f")").bold()
            HStack {
                Image(systemName: "star.fill").foregroundColor(.yellow)
                Text("\(product.rating.rate, specifier: "%.1f") (\(product.rating.count))")
            }.font(.caption)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
