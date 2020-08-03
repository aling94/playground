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
    func error(from response: URLResponse?) -> Error?
    var defaultError: Error { get }
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
    func send(
        _ request: URLRequest,
        _ method: URLRequest.Method,
        _ completion: @escaping Callback<Data>
    ) {
        var request = request
        request.method = method
        session.dataTask(with: request) { (data, response, err) in
            if let err = err ?? self.error(from: response) { completion(.failure(err), response) }
            else if let data = data { completion(.success(data), response) }
            else { completion(.failure(self.defaultError), response) }
        }.resume()
    }

    func send<T: Decodable>(
        _ request: URLRequest,
        _ method: URLRequest.Method,
        _ completion: @escaping Callback<T>
    ) {
        send(request, method) { (result, response) in
            switch result {
            case let .failure(error):
                completion(.failure(error), response)
            case let .success(data):
                do { completion(.success(try JSONDecoder().decode(T.self, from: data)), response) }
                catch { completion(.failure(error), response) }
            }
        }
    }

    func send(_ url: URL, _ method: URLRequest.Method, _ completion: @escaping Callback<Data>) {
        send(request(from: url), method, completion)
    }

    func send<T: Decodable>(_ url: URL, _ method: URLRequest.Method, _ completion: @escaping Callback<T>) {
        send(request(from: url), method, completion)
    }

}

private extension Encodable {
    var httpBody: Data? { try? JSONEncoder().encode(self) }

    var queryItems: [URLQueryItem]? {
        guard let info = try? JSONEncoder().encode(self),
            let obj = try? JSONSerialization.jsonObject(with: info, options: .allowFragments),
            let dict = obj as? [String : Any]
        else { return nil }
        let items = dict.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        return items.isEmpty ? nil : items
    }
}

protocol WebResource {
    var client: WebClient { get }
    var baseURL: URL { get }
}

extension WebResource {

    func request<P: Encodable, Q: Encodable>(
        _ path: String,
        _ param: P? = nil,
        _ queryObj: Q? = nil
    ) -> URLRequest? {
        var comp = URLComponents(string: baseURL.absoluteString)
        comp?.path = path
        comp?.queryItems = queryObj?.queryItems
        guard let url = comp?.url else { return nil }
        var req = client.request(from: url)
        req.httpBody = param?.httpBody
        return req
    }

    func request<T: PathChain, P: Encodable, Q: Encodable>(
        _ path: T,
        _ param: P? = nil,
        _ queryObj: Q? = nil
    ) -> URLRequest? { request(path.path, param, queryObj) }

    func request<T: PathChain, P: Encodable, Q: Encodable>(
        _ path: T.Type,
        _ param: P? = nil,
        _ queryObj: Q? = nil
    ) -> URLRequest? { request(path.parentPath, param, queryObj) }

}

protocol PathChain {
    associatedtype Parent: PathChain
    static var parentPath: String { get }
    static var name: String { get }
    var name: String { get }
    var path: String { get }
}

extension PathChain {
    static var parentPath: String { (self.self == Parent.self ? "" : Parent.parentPath) + "/\(name)" }
    static var name: String { "\(self)" }
    var name: String { "\(self)" }
    var path: String { "\(Self.parentPath)/\(name)".lowercased() }
}

extension PathChain where Self: RawRepresentable, RawValue == String {
    var name: String { rawValue }
}

enum Services: PathChain { typealias Parent = Services

    static let name: String = "CustomServiceName"

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

    func appendingPath<T: PathChain>(_ chain: T.Type) -> URL {
        appendingPathComponent(chain.parentPath)
    }

    mutating func appendPath<T: PathChain>(_ chain: T.Type) {
        appendPathComponent(chain.parentPath)
    }
}

let testURL = URL(string: "https://api.github.com")!
print(testURL.absoluteURL)
print(testURL.appendingPath(Services.User.Document.self).absoluteURL)
