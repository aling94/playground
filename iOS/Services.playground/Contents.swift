import UIKit

enum Configuration: String {
    case dev, qa, stage, release
}

protocol Application {
    var config: Configuration { get }
    var version: Decimal { get }
    var build: UInt { get }
    var env: Environment { get }
}

protocol Environment {
    var serviceURL: URL { get }
    var contentURL: URL { get }
}

protocol WebClient {
    typealias Callback<T> = (Result<T, Error>, URLResponse?) -> Void
    var session: URLSession { get }
    func request(from url: URL) -> URLRequest
}

extension URLRequest {
    enum Method: String {
        case GET, POST, DELETE
    }

    var method: Method? {
        get { Method(rawValue: httpMethod ?? "") }
        set { httpMethod = newValue?.rawValue }
    }
}

extension WebClient {

    private func serveRequest<T: Decodable>(_ request: URLRequest, _ method: URLRequest.Method, _ completion: @escaping Callback<T>) {
        var request = request
        request.method = method
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error { completion(.failure(error), response) }
                return
            }
            do { completion(.success(try JSONDecoder().decode(T.self, from: data)), response) }
            catch { completion(.failure(error), response) }
        }.resume()
    }

    func GET<T: Decodable>(_ url: URL, _ completion: @escaping Callback<T>) {
        GET(request(from: url), completion)
    }

    func GET<T: Decodable>(_ request: URLRequest, _ completion: @escaping Callback<T>) {
        serveRequest(request, .GET, completion)
    }
}

protocol WebResource {
    var client: WebClient { get }
    var baseURL: URL { get }
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
    enum User: PathChain { typealias Parent = Services }
}

extension Services.User {
    enum Document: String, PathChain {
        typealias Parent = Services.User

        case upload
        case download = "downloading"
        case create
    }
}

var components = URLComponents()
components.scheme = "https"
components.host = "api.github.com"
components.path = Services.User.Document.download.path
print(components.url!)

extension URL {
    func appendingPath<T: PathChain>(_ chain: T) -> URL {
        appendingPathComponent(chain.path)
    }

    mutating func appendPath<T: PathChain>(_ chain: T) {
        appendPathComponent(chain.path)
    }
}

let testURL = URL(string: "https://api.github.com")!
print(testURL.absoluteURL)
print(testURL.appendingPath(Services.User.Document.download).absoluteURL)
