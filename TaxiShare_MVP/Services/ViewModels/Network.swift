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

internal class BaseUrl: ObservableObject {
    static var value: String {
        get {
#if DEBUG
            return "http://localhost:3000/"
            //            return "https://shtaxi-server.onrender.com/"
#else
            return "https://shtaxi-server.onrender.com/"
#endif
        }
    }
}

internal struct Request {
    let method: HttpMethod
    let url: String
    let parameters: [String: Any]
    
    private var base: String { get { return BaseUrl.value } }
    
    func build() throws -> URLRequest {
        switch method {
        case .post:
            let urlString = "\(base)\(url)"
            guard let url = URL(string: urlString) else { throw NetworkError.badUrl }
            guard let httpBody = parameters.httpBody() else { throw NetworkError.badUrl }
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = method.rawValue
            request.httpBody = httpBody
            return request
            
        case .get:
            var url = url
            if let keysValues = parameters.requestFormatted() {
                url += "?\(keysValues)"
            }
            let urlString = "\(base)\(url)"
            guard let url = URL(string: urlString) else { throw NetworkError.badUrl }
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = method.rawValue
            return request
        }
    }
}

class Network: Networkble {
    internal var root: String {
        guard type(of: self) == Network.self else { fatalError("must override root in \(self)".replacingOccurrences(of: "TaxiShare_MVP.", with: "")) }
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
    
    private let responedQueue = DispatchQueue.main
    
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
                    } catch NetworkError.badResponse {
                        return error("Did not get a valid response")
                    } catch NetworkError.badStatus {
                        return error("Did not get a 2xx status code from the response")
                    } catch NetworkError.failedToDecodeResponse {
                        return error("Failed to decode response into the given type")
                    } catch NetworkError.noData {
                        return error("No data")
                    } catch(_) {
                        return error("An error occured downloading the data")
                    }
                }
                
                // return error
                return error(err)
                
            }.resume()
            
            // handele expetions
        } catch NetworkError.badUrl {
            return error("There was an error creating the URL")
        } catch(_) {
            return error("An error occured downloading the data")
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
