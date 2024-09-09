//
//  Network.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 31/08/2024.
//

import Foundation

// MARK: Networkble
private protocol Networkble: DataSource {
    typealias UrlPathMaker = (String) -> String
    
    var responedQueue: DispatchQueue { get }
    var root: String { get }
    var url: UrlPathMaker { get }
}

// MARK: NetworkError
private enum NetworkError: Error {
    case badUrl
    case invalidRequestBody
    case badResponse
    case badStatus
    case noData
    case failedToDecodeResponse
}

// MARK: HttpMethod
internal enum HttpMethod: String {
    case post = "POST", get = "GET"
}

// MARK: Network
class Network: Networkble {
    // MARK: responedQueue
    fileprivate let responedQueue: DispatchQueue = DispatchQueue.main
    
    // MARK: root - root url value
    internal var root: String {
        guard type(of: self) == Network.self else {
            let className = "\(self)".replacingOccurrences(of: "TaxiShare_MVP.", with: "")
            fatalError("must override root in \(className)")
        }
        return ""
    }
    
    // MARK: path - path url value
    fileprivate var url: UrlPathMaker {
        return { [weak self] url in
            guard let self else { return "" }
            return "\(root)/\(url)"
        }
    }
    
    // MARK: init
    internal init() {}
    
    // MARK: send - to network
    /// - Parameter method
    /// - Parameter url
    /// - Parameter parameters
    /// - Parameter complition
    /// - Parameter error
    private func send<T: Codable>(method: HttpMethod, url: String, parameters: [String: Any], complition: @escaping (Response<T>) -> (), error: @escaping (Error) -> ()) {
        do {
            let request = try Request(method: method, url: url, parameters: parameters).build()
            
            URLSession.shared.dataTask(with: request) { data, response, err in
                guard let err else {
                    do {
                        guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
                        guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
                        guard let data else { throw NetworkError.noData }
                        guard let decodedResponse = try? JSONDecoder().decode(Response<T>.self, from: data) else { throw NetworkError.failedToDecodeResponse }
                        
                        // return result
                        return complition(decodedResponse)
                        
                        // handele expetions
                    } catch let err {
                        return error(err.localizedDescription)
                    }
                }
                
                // return error
                return error(err)
                
            }.resume()
            
            // handele expetions
        } catch let err {
            return error(err.localizedDescription)
        }
    }
}

// MARK: Network internal extension
extension Network {
    // MARK: send - call send to network and unwrap (result || error)
    /// - Parameter method
    /// - Parameter url
    /// - Parameter parameters
    /// - Parameter complition
    /// - Parameter error
    internal func send<T: Codable>(method: HttpMethod, route: String, parameters: [String: Any] = [:], complition: @escaping (T) -> (), error: @escaping (String) -> ()) {
        send(method: method,
             url: url(route),
             parameters: parameters) { [weak self] result in
            guard let self else { return }
            responedQueue.async { complition(result.value) }
        } error: { [weak self] err in
            guard let self else { return }
            responedQueue.async { error(err.localizedDescription) }
        }
    }
    
    
    // MARK: ComplitionHandeler
    internal class ComplitionHandeler: ObservableObject {
        func makeValid<T: Codable>(_ complition: @escaping () -> ()) -> (T) -> () { return { _ in complition() } }
        func makeValid<T: Codable>(_ complition: @escaping (T) -> ()) -> (T) -> () { return complition }
    }
    
    // MARK: ParameterHndeler
    internal class ParameterHndeler: ObservableObject {
        // MARK: toDict
        /// - Parameter values
        func toDict(values: DictionaryRepresentable...) -> [String: Any] {
            var dict: [String: Any] = [:]
            values.forEach { dict.merge(dict: $0.dictionary()) }
            return dict
        }
    }
}

// MARK: Network private extension
extension Network {
    // MARK: BaseUrl
    private struct BaseUrl {
        static var value: String {
            get {
#if DEBUG
                //                        return "http://localhost:3000/"
                return "https://shtaxi-server.onrender.com/"
#else
                return "https://shtaxi-server.onrender.com/"
#endif
            }
        }
    }
    
    // MARK: Request
    private struct Request {
        private var base: String { get { return BaseUrl.value } }
        
        let method: HttpMethod
        let url: String
        let parameters: [String: Any]
        
        // MARK: build
        var build: () throws -> URLRequest { newRequest }
        
        // MARK: Private
        private func newRequest() throws -> URLRequest {
            return try createRequestWithType()
                .withHttpMethod(method.rawValue)
                .withHeaders(.init(value: "application/json", headerField: "Content-Type"),
                             .init(value: "application/json", headerField: "Accept"))
        }
        
        // createRequestWithType -> throws
        private func createRequestWithType() throws -> URLRequest {
            switch method {
            case .post:
                guard let httpBody = parameters.httpBody() else { throw NetworkError.invalidRequestBody }
                return try createRequest().withHttpBody(httpBody)
            case .get:
                return try createRequest()
            }
        }
        
        // createRequest -> throws
        private func createRequest() throws -> URLRequest {
            return URLRequest(url: try createUrl())
        }
        
        // createUrl -> throws
        private func createUrl() throws -> URL {
            guard let url = URL(string: createUrlString()) else { throw NetworkError.badUrl }
            return url
        }
        
        // createUrlString
        private func createUrlString() -> String {
            switch method {
            case .post:
                return "\(base)\(url)"
            case .get:
                let prametrersFormatted = parameters.requestFormatted()
                let keyValue = prametrersFormatted.isEmpty ? "" : "?\(prametrersFormatted)"
                let urlString = "\(url)\(keyValue)"
                return "\(base)\(urlString)"
            }
        }
    }
}

// MARK: NetworkError private extension
extension NetworkError: LocalizedError {
    fileprivate var errorDescription: String? {
        switch self {
        case .badUrl:
            return "There was an error creating the URL"
        case .invalidRequestBody:
            return "There was an error creating the request body"
        case .badResponse:
            return "Did not get a valid response"
        case .badStatus:
            return "Did not get a 2xx status code from the response"
        case .noData:
            return "No data"
        case .failedToDecodeResponse:
            return "Failed to decode response into the given type"
        }
    }
}
