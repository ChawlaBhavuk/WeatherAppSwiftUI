//
//  APIService.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 02/10/23.
//

import Foundation
import Combine

protocol APIService {
    func request<T: Decodable>(type: T.Type, _ endpoint: Endpoint) -> Future<T, Error> 
}
