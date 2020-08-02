import UIKit

enum Configuration: String {
    case dev, qa, stage, prod
}

protocol Application {
    var config: Configuration { get }
    var version: Decimal { get }
    var build: UInt { get }
    var net: Network { get }
}

protocol Network {
    var serviceURL: URL { get }
    var contentURL: URL { get }
}

protocol NetClient {
    var session: URLSession { get }
    var baseURL: URL { get }
}

extension NetClient {

    func GET<P: Encodable, T: Decodable>(
        _ parameters: P? = nil,
        _ completion: @escaping (Result<T, Error>) -> Void) {

        session.dataTask(with: URLRequest(url: baseURL)) { (data, response, error) in

        }


    }

}

protocol PathChain {
    associatedtype Parent: PathChain
    static var parentPath: String { get }
    var component: String { get }
    var path: String { get }
}

extension PathChain {
    static var parentPath: String { (self.self == Parent.self ? "" : Parent.parentPath) + "/\(self)" }
    var component: String { "\(self)" }
    var path: String { "\(Self.parentPath)/\(component)".lowercased() }
}

extension PathChain where Self: RawRepresentable, RawValue == String {
    var component: String { rawValue }
}

enum Services: PathChain { typealias Parent = Services

    enum User: PathChain { typealias Parent = Services

        enum Document: String, PathChain { typealias Parent = User
            case upload
            case download = "downloading"
            case create
        }
    }
}

var components = URLComponents()
components.scheme = "https"
components.host = "api.github.com"
components.path = Services.User.Document.download.path
components.port
print(components.url!)
