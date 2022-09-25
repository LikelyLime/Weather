//
//  WeatherInfomation.swift
//  Weather
//
//  Created by 백시훈 on 2022/09/25.
//

import Foundation

//Codable : 자신을 변환하거나 외부표현으로 변환할 수 있는 타입
// ex) JSON
struct WeatherInfomation: Codable{
    let weather: [Weather]
    let temp : Temp
    let name : String
    enum CodingKeys: String, CodingKey{
        case weather
        case temp = "main"
        case name
    }
}


//decode작업 json으로 외부에서 받는 데이터를 구조체로 전환하는 작업
struct Weather: Codable{
    let id: Int
    let main: String
    let description: String
    let icon: String
}

//JSON과 네이밍이 달라도 받을수 있도록 구현
struct Temp: Codable{
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    
    enum CodingKeys: String, CodingKey{
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}
