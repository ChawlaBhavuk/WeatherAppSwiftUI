//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 02/10/23.
//

import Foundation
import Combine

class NetworkService: APIService {

    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL = AppConstants.baseUrl, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    private var cancellables = Set<AnyCancellable>()

    func request<T>(type: T.Type, _ endpoint: Endpoint) -> Future<T, NetworkError> where T : Decodable {

        return Future<T, NetworkError>  { [weak self] promise in

            guard let self = self,
                  let request =  self.getUrlRequest(endpoint) else {
                return promise(.failure(NetworkError.invalidURL))
            }

            self.session.dataTaskPublisher(for: request)
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }

                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.responseError))
                        }
                    }
                } receiveValue: { data in
                    promise(.success(data))
                }
                .store(in: &self.cancellables)

        }
    }

    func getUrlRequest(_ endpoint: Endpoint) -> URLRequest?  {
        let url = baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        // Set query parameters if present
        if let queryItems = endpoint.queryItems {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            if let newURL = components?.url {
                request.url = newURL
            }
        }

        // Set request body and headers if present
        request.httpBody = endpoint.body
        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        return request

    }
}

