//
//  Network.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 31/08/2024.
//

import Foundation

internal protocol Networkble: ObservableObject {
    typealias UrlPathHolder = () -> (String)
    typealias UrlPathMaker = (String) -> UrlPathHolder
    
    var root: String { get }
    var path: UrlPathMaker { get }
    var responedQueue: DispatchQueue { get }
}

internal enum HttpMethod: String {
    case post = "POST", get = "GET"
}

internal enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case noData
    case failedToDecodeResponse
}
extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badUrl:
            return "There was an error creating the URL"
        case .invalidRequest:
            return "There was an error creating the request"
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

internal class BaseUrl: ObservableObject {
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

internal struct Request {
    private var base: String { get { return BaseUrl.value } }
    
    let method: HttpMethod
    let url: String
    let parameters: [String: Any]
    
    var build: () throws -> URLRequest { newRequest }

    private func newRequest() throws -> URLRequest {
        var request: URLRequest = try {
            switch method {
            case .post:
                let urlString = "\(base)\(url)"
                guard let url = URL(string: urlString) else { throw NetworkError.badUrl }
                guard let httpBody = parameters.httpBody() else { throw NetworkError.badUrl }
                var request = URLRequest(url: url)
                request.httpBody = httpBody
                return request
                
            case .get:
                var url = url
                if let keysValues = parameters.requestFormatted() { url += "?\(keysValues)" }
                let urlString = "\(base)\(url)"
                guard let url = URL(string: urlString) else { throw NetworkError.badUrl }
                let request = URLRequest(url: url)
                return request
            }
        }()
        
        request.httpMethod = method.rawValue
        return request.withHeaders(.init(value: "application/json", headerField: "Content-Type"),
                                   .init(value: "application/json", headerField: "Accept"))
    }
}

class Network: Networkble {
    internal var root: String {
        guard type(of: self) == Network.self else { 
            let className = "\(self)".replacingOccurrences(of: "TaxiShare_MVP.", with: "")
            fatalError("must override root in \(className)")
        }
        return ""
    }
    
    internal var path: UrlPathMaker {
        return { url in 
            { [weak self] in
                guard let self else { return "" }
                return "\(root)/\(url)"
            }
        }
    }
    
    internal let responedQueue = DispatchQueue.main
    
    internal init() {}
    
    private func send<T: Codable>(method: HttpMethod = .post, url: String, parameters: [String: Any] = [:], complition: @escaping (Response<T>) -> (), error: @escaping (Error) -> ()) {
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


extension Network {
    internal func send<T: Codable>(url: UrlPathHolder, parameters: [String: Any] = [:], complition: @escaping (T) -> (), error: @escaping (String) -> ()) {
        send(url: url(), parameters: parameters) { [weak self] result in
            guard let self else { return }
            responedQueue.async {
                complition(result.value)
            }
        } error: { [weak self] err in
            guard let self else { return }
            responedQueue.async {
                error(err.localizedDescription)
            }
        }
    }
}
