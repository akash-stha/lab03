//
//  WeatherResponseModel.swift
//  Lab03
//
//  Created by Akash Shrestha on 2023-11-18.
//

import Foundation

struct WeatherResponseModel: Decodable {
    let location: Location?
    let current: Current?
}

struct Location: Decodable {
    let name: String?
}

struct Current: Decodable {
    let temp_c: Float?
    let temp_f: Float?
    let condition: Condition?
}

struct Condition: Decodable {
    let text: String?
    let code: Int?
}

struct CityWeatherModel {
    let name: String
    let imgCode: Int
    let temp_c: String
    let temp_f: String
}
