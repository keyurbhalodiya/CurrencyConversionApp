//
//  NetworkService.swift
//  CurrencyConversionApp
//
//  Created by Keyur Bhalodiya on 2024/07/02.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "")
        }
    }
}

private enum Constant {
  static let token = "c50a29c989e68d21aa9487e5" // TODO: Add token here
  static let baseUrl = "https://v6.exchangerate-api.com/v6/"
}

final class NetworkService {
  
  static let shared = NetworkService()
  
  private var cancellables = Set<AnyCancellable>()
  
  func getData<T: Decodable>(baseCurrency: String, type: T.Type) -> Future<T, Error> {
    
    return Future<T, Error> { [weak self] promise in
      guard let self = self, let url = URL(string: "\(Constant.baseUrl)\(Constant.token)/latest/\(baseCurrency)") else {
        return promise(.failure(NetworkError.invalidURL))
      }
      let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
     
      guard let componentsUrl = components?.url else {
        return promise(.failure(NetworkError.invalidURL))
      }
      
      var request = URLRequest(url: componentsUrl)
      request.httpMethod = "GET"
      if Constant.token.count > 0 {
        request.addValue("Bearer \(Constant.token)", forHTTPHeaderField: "Authorization")
      }
      URLSession.shared.dataTaskPublisher(for: request)
        .tryMap { (data, response) -> Data in  // -> Operator
          guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.responseError
          }
          return data
        }
        .decode(type: T.self, decoder: JSONDecoder())  // -> Operator
        .receive(on: RunLoop.main) // -> Sheduler Operator
        .sink(receiveCompletion: { (completion) in  // -> Subscriber
          if case let .failure(error) = completion {
            switch error {
            case let decodingError as DecodingError:
              promise(.failure(decodingError))
            case let apiError as NetworkError:
              promise(.failure(apiError))
            default:
              promise(.failure(NetworkError.unknown))
            }
          }
        }, receiveValue: { data in
          promise(.success(data)
          ) })
        .store(in: &self.cancellables)
    }
  }
}
