import UIKit

class NetworkManager {
    
    var timezone: String?
    var timezoneOffset: Int?
    var temperature: Int?
    var dt: Int?
    var sunrise: Int?
    var sunset: Int?
    var tempIcon: String?
    var tempDescription: String?
    var description: String?
    var dailyMinTemp: Int?
    var dailyMaxTemp: Int?
    var weatherImage = UIImageView()
    
    struct Hourly {
        let time: Int?
        let temp: Int?
        let icon: UIImage?
    }
    var hourlyWeather: [Hourly] = []
    
    private let session: URLSession
    lazy var jsonDecoder = JSONDecoder()
    
    init(with configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
    
    public func setUrlStr(with city: City) -> String {
        let str = "https://api.openweathermap.org/data/2.5/onecall?lat=\(city.LATitude)&lon=\(city.LONgitude)&exclude=minutely&units=metric&lang=ru&appid=452ffef46ff70eb99a5709692724b78a"
        return str
    }
    
    func fetchTimezoneData(for city: City, completion: @escaping (_ city: City) -> Void) {
        guard let url = URL(string: setUrlStr(with: city)) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let weatherData = try self.jsonDecoder.decode(WeatherData.self, from: data)
                    
                    self.timezone = weatherData.timezone
                    self.timezoneOffset = weatherData.timezoneOffset
                    
                    if let current = weatherData.current {
                        self.temperature = Int(current.temp!)
                        self.dt = current.dt! + (self.timezoneOffset ?? 0)
                        
                        if let weather = current.weather, let description = weather.first?.description {
                            self.description = description
                        }
                    }
                    
                    if let daily = weatherData.daily, let temp = daily.first?.temp {
                        let minTemp = temp.min
                        self.dailyMinTemp = Int(minTemp!)
                        
                        let maxTemp = temp.max
                        self.dailyMaxTemp = Int(maxTemp!)
                    }
                    
                    if let hourly = weatherData.hourly {
                        for hourData in hourly {
                            if let date = hourData.dt, let temp = hourData.temp {
                                let hourlyData = Hourly(time: date, temp: Int(temp), icon: nil)
                                self.hourlyWeather.append(hourlyData)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completion(city)
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}
