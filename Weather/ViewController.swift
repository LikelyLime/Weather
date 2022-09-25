//
//  ViewController.swift
//  Weather
//
//  Created by 백시훈 on 2022/09/25.
//

import UIKit

class ViewController: UIViewController {
    
    
    /**
     IBOutlet 변수
     */
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var weatherStackView: UIStackView!
    @IBOutlet weak var minTempLabel: UILabel!
    //-----------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    /**
        날짜가져오기 버튼 함수
     */
    @IBAction func tabFetchWeatherButton(_ sender: UIButton) {
        if let cityName = self.cityNameTextField.text{
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true)
        }
    }
    /**
     실패시 에러메세지 Alert띄우는 메서드
     */
    func showAlert(errorMessage: String){
        let alert = UIAlertController(title: "에러", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    /**
     http로 서버에서 받은 데이터를 화면에 뿌려주는 메서드
     */
    func configureView(weatherInfomation: WeatherInfomation){
        self.cityNameTextField.text = weatherInfomation.name
        if let weather = weatherInfomation.weather.first{
            self.weatherDescription.text = weather.description
        }
        self.tempLabel.text = "\(Int(weatherInfomation.temp.temp - 273.15))℃"
        self.maxTempLabel.text = "최고: \(Int(weatherInfomation.temp.maxTemp - 273.15))℃"
        self.minTempLabel.text = "최저: \(Int(weatherInfomation.temp.minTemp - 273.15))℃"
    }
    
    /**
    URL로 Http통신하여 날씨 정보를 가져오는 메서드
     */
    func getCurrentWeather(cityName: String){
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=1f0728df4cc5a4d34a0dd7036dafbc75") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url){[weak self] data, response, error in
            let successRange = (200 ..< 300)
            guard let data = data , error == nil else { return }
            let decoder = JSONDecoder()
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode){
                guard let weatherInfomation = try? decoder.decode(WeatherInfomation.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInfomation: weatherInfomation)
                }
            } else{
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.showAlert(errorMessage: errorMessage.message)
                }
            }
            
        }.resume()
        
    }
}

