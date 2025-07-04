// Models
struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let image: String
    let rating: Rating
}

struct Rating: Codable {
    let rate: Double
    let count: Int
}
