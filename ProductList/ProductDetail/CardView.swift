import SwiftUI

struct CartView: View {
    let cartItems: Set<Int>
    let products: [Product]
    @State private var showThankYou = false

    var body: some View {
        VStack {
            List {
                ForEach(products.filter { cartItems.contains($0.id) }) { product in
                    HStack {
                        AsyncImage(url: URL(string: product.image)) { image in
                            image.resizable().aspectRatio(contentMode: .fit).frame(width: 50, height: 50)
                        } placeholder: {
                            ProgressView()
                        }
                        VStack(alignment: .leading) {
                            Text(product.title).font(.headline)
                            Text("\u{00A3}\(product.price, specifier: "%.2f")")
                        }
                    }
                }
            }
            Button("Checkout") {
                showThankYou = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
            .alert(isPresented: $showThankYou) {
                Alert(title: Text("Thank You"), message: Text("Your order has been placed!"), dismissButton: .default(Text("OK")))
            }
        }
        .navigationTitle("Cart")
    }
}
