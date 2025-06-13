
import Foundation
struct InternalLinksModel: Codable {
    let statusCode: Int?
    let message: String?
    let links: [Link]?

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message, links
    }
}

// MARK: - Link
struct Link: Codable, Hashable {
    let href: String?
    let text: String?
}
