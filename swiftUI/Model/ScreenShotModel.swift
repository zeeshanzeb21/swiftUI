import Foundation

struct ScreenShotModel: Codable {
    let statusCode: Int?
    let message: String?
    let basePath: String?
    let slices: [String]?

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message
        case basePath = "base_path"
        case slices
    }
}
