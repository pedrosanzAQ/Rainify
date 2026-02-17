//
//  WeatherResponse.swift
//  Rainify
//
//  Created by pedrosanz on 03/06/25.
//

import Foundation

// MARK: - Welcome
struct WeatherResponse: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

// MARK: - Current
struct Current: Codable {
    let lastUpdatedEpoch: Int?
    let lastUpdated: String?
    let tempC, tempF: Double
    let isDay: Int
    let condition: Condition
    let windMph, windKph: Double
    let windDegree: Int
    let windDir: String
    let pressureMB: Double
    let pressureIn, precipMm, precipIn: Double
    let humidity, cloud: Int
    let feelslikeC, feelslikeF, windchillC, windchillF: Double
    let heatindexC, heatindexF, dewpointC, dewpointF: Double
    let visKM, visMiles: Double
    let uv, gustMph, gustKph: Double
    let airQuality: [String: Double]?
    let timeEpoch: Int?
    let time: String?
    let snowCM: Double?
    let willItRain, chanceOfRain, willItSnow: Int?
    let chanceOfSnow: Int?

    enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMB = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case precipIn = "precip_in"
        case humidity, cloud
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case windchillC = "windchill_c"
        case windchillF = "windchill_f"
        case heatindexC = "heatindex_c"
        case heatindexF = "heatindex_f"
        case dewpointC = "dewpoint_c"
        case dewpointF = "dewpoint_f"
        case visKM = "vis_km"
        case visMiles = "vis_miles"
        case uv
        case gustMph = "gust_mph"
        case gustKph = "gust_kph"
        case airQuality = "air_quality"
        case timeEpoch = "time_epoch"
        case time
        case snowCM = "snow_cm"
        case willItRain = "will_it_rain"
        case chanceOfRain = "chance_of_rain"
        case willItSnow = "will_it_snow"
        case chanceOfSnow = "chance_of_snow"
    }
}

// MARK: - Condition
struct Condition: Codable {
    let text, icon: String
    let code: Int
}

// MARK: - Forecast
struct Forecast: Codable {
    let forecastday: [Forecastday]
}

// MARK: - Forecastday
struct Forecastday: Codable {
    let date: String
    let dateEpoch: Int
    let day: Day
    let astro: Astro
    let hour: [Current]

    enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case day, astro, hour
    }
}

// MARK: - Astro
struct Astro: Codable {
    let sunrise, sunset, moonrise, moonset: String
    let moonPhase: String
    let moonIllumination, isMoonUp, isSunUp: Int

    enum CodingKeys: String, CodingKey {
        case sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case moonIllumination = "moon_illumination"
        case isMoonUp = "is_moon_up"
        case isSunUp = "is_sun_up"
    }
}

// MARK: - Day
struct Day: Codable {
    let maxtempC, maxtempF, mintempC, mintempF: Double
    let avgtempC, avgtempF, maxwindMph, maxwindKph: Double
    let totalprecipMm, totalprecipIn: Double
    let totalsnowCM: Int
    let avgvisKM: Double
    let avgvisMiles, avghumidity, dailyWillItRain, dailyChanceOfRain: Int
    let dailyWillItSnow, dailyChanceOfSnow: Int
    let condition: Condition
    let uv: Double

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case maxtempF = "maxtemp_f"
        case mintempC = "mintemp_c"
        case mintempF = "mintemp_f"
        case avgtempC = "avgtemp_c"
        case avgtempF = "avgtemp_f"
        case maxwindMph = "maxwind_mph"
        case maxwindKph = "maxwind_kph"
        case totalprecipMm = "totalprecip_mm"
        case totalprecipIn = "totalprecip_in"
        case totalsnowCM = "totalsnow_cm"
        case avgvisKM = "avgvis_km"
        case avgvisMiles = "avgvis_miles"
        case avghumidity
        case dailyWillItRain = "daily_will_it_rain"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case dailyWillItSnow = "daily_will_it_snow"
        case dailyChanceOfSnow = "daily_chance_of_snow"
        case condition, uv
    }
}

// MARK: - Location
struct Location: Codable {
    let name, region, country: String
    let lat, lon: Double
    let tzID: String
    let localtimeEpoch: Int
    let localtime: String

    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzID = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}

// MARK: - WeatherResponse Mock

extension WeatherResponse {
    
    /// Mock base (London)
    static var mock: WeatherResponse {
        WeatherResponse(
            location: Location(
                name: "London",
                region: "England",
                country: "United Kingdom",
                lat: 51.5074,
                lon: -0.1278,
                tzID: "Europe/London",
                localtimeEpoch: 1_704_000_000,
                localtime: "2026-01-15 12:00"
            ),
            
            current: Current(
                lastUpdatedEpoch: 1_704_000_000,
                lastUpdated: "2026-01-15 12:00",
                tempC: 15.0,
                tempF: 59.0,
                isDay: 1,
                condition: Condition(
                    text: "Cloudy",
                    icon: "//cdn.weatherapi.com/cloud.png",
                    code: 1003
                ),
                windMph: 5.0,
                windKph: 8.0,
                windDegree: 120,
                windDir: "SE",
                pressureMB: 1012,
                pressureIn: 29.88,
                precipMm: 0,
                precipIn: 0,
                humidity: 72,
                cloud: 80,
                feelslikeC: 14.0,
                feelslikeF: 57.2,
                windchillC: 14.0,
                windchillF: 57.2,
                heatindexC: 15.0,
                heatindexF: 59.0,
                dewpointC: 10.0,
                dewpointF: 50.0,
                visKM: 10,
                visMiles: 6,
                uv: 3.0,
                gustMph: 7.0,
                gustKph: 11.0,
                airQuality: ["pm2_5": 12.3, "pm10": 20.1],
                timeEpoch: nil,
                time: nil,
                snowCM: nil,
                willItRain: nil,
                chanceOfRain: nil,
                willItSnow: nil,
                chanceOfSnow: nil
            ),
            
            forecast: Forecast(
                forecastday: [
                    Forecastday(
                        date: "2026-01-15",
                        dateEpoch: 1_704_000_000,
                        day: Day(
                            maxtempC: 17,
                            maxtempF: 62.6,
                            mintempC: 9,
                            mintempF: 48.2,
                            avgtempC: 13,
                            avgtempF: 55.4,
                            maxwindMph: 10,
                            maxwindKph: 16,
                            totalprecipMm: 0,
                            totalprecipIn: 0,
                            totalsnowCM: 0,
                            avgvisKM: 10,
                            avgvisMiles: 6,
                            avghumidity: 70,
                            dailyWillItRain: 0,
                            dailyChanceOfRain: 0,
                            dailyWillItSnow: 0,
                            dailyChanceOfSnow: 0,
                            condition: Condition(
                                text: "Partly Cloudy",
                                icon: "",
                                code: 1003
                            ),
                            uv: 4
                        ),
                        astro: Astro(
                            sunrise: "07:45 AM",
                            sunset: "04:45 PM",
                            moonrise: "10:00 PM",
                            moonset: "08:00 AM",
                            moonPhase: "Waxing Crescent",
                            moonIllumination: 30,
                            isMoonUp: 1,
                            isSunUp: 0
                        ),
                        hour: [] // vacío para mock simple
                    )
                ]
            )
        )
    }
    
    /// Array de 3 mocks
    static var mocks: [WeatherResponse] {
        [
            WeatherResponse.mock, // London
            
            // 🇲🇽 Mexico City
            WeatherResponse(
                location: Location(
                    name: "Mexico City",
                    region: "CDMX",
                    country: "Mexico",
                    lat: 19.4326,
                    lon: -99.1332,
                    tzID: "America/Mexico_City",
                    localtimeEpoch: 1_704_000_100,
                    localtime: "2026-01-15 13:00"
                ),
                current: Current(
                    lastUpdatedEpoch: 1_704_000_100,
                    lastUpdated: "2026-01-15 13:00",
                    tempC: 22.0,
                    tempF: 71.6,
                    isDay: 1,
                    condition: Condition(
                        text: "Partly cloudy",
                        icon: "//cdn.weatherapi.com/weather/64x64/day/116.png",
                        code: 1003
                    ),
                    windMph: 6.2,
                    windKph: 10.0,
                    windDegree: 120,
                    windDir: "SE",
                    pressureMB: 1018,
                    pressureIn: 30.06,
                    precipMm: 0.0,
                    precipIn: 0.0,
                    humidity: 48,
                    cloud: 30,
                    feelslikeC: 23.0,
                    feelslikeF: 73.4,
                    windchillC: 17.0,
                    windchillF: 59.2,
                    heatindexC: 18.0,
                    heatindexF: 62.0,
                    dewpointC: 13.0,
                    dewpointF: 55.0,

                    visKM: 8.0,
                    visMiles: 5.0,
                    uv: 8.0,
                    gustMph: 9.4,
                    gustKph: 15.0,
                    airQuality: WeatherResponse.mock.current.airQuality,
                    
                    // ---
                    timeEpoch: nil,
                    time: nil,
                    snowCM: nil,
                    willItRain: nil,
                    chanceOfRain: nil,
                    willItSnow: nil,
                    chanceOfSnow: nil
                ),
                forecast: Forecast(
                    forecastday: [
                        Forecastday(
                            date: "2026-01-15",
                            dateEpoch: 1_704_000_000,
                            day: Day(
                                maxtempC: 24,
                                maxtempF: 69.8,
                                mintempC: 10,
                                mintempF: 47.0,
                                avgtempC: 18,
                                avgtempF: 50.4,
                                maxwindMph: 9,
                                maxwindKph: 18,
                                totalprecipMm: 0,
                                totalprecipIn: 0,
                                totalsnowCM: 0,
                                avgvisKM: 9,
                                avgvisMiles: 10,
                                avghumidity: 50,
                                dailyWillItRain: 0,
                                dailyChanceOfRain: 5,
                                dailyWillItSnow: 0,
                                dailyChanceOfSnow: 0,
                                condition: Condition(
                                    text: "Sunny intervals",
                                    icon: "//cdn.weatherapi.com/weather/64x64/day/113.png",
                                    code: 1000
                                ),
                                uv: 8
                            ),
                            astro: WeatherResponse.mock.forecast.forecastday.first!.astro,
                            hour: WeatherResponse.mock.forecast.forecastday.first!.hour
                        )
                    ]
                )
            ),
            
            // 🇯🇵 Tokyo
            WeatherResponse(
                location: Location(
                    name: "Tokyo",
                    region: "Kanto",
                    country: "Japan",
                    lat: 35.6762,
                    lon: 139.6503,
                    tzID: "Asia/Tokyo",
                    localtimeEpoch: 1_704_000_200,
                    localtime: "2026-01-15 22:00"
                ),
                current: Current(
                    lastUpdatedEpoch: 1_704_000_200,
                    lastUpdated: "2026-01-15 22:00",
                    tempC: 4.0,
                    tempF: 39.2,
                    isDay: 0,
                    condition: Condition(
                        text: "Overcast",
                        icon: "//cdn.weatherapi.com/weather/64x64/night/122.png",
                        code: 1009
                    ),
                    windMph: 12.4,
                    windKph: 20.0,
                    windDegree: 10,
                    windDir: "N",
                    pressureMB: 1025,
                    pressureIn: 30.27,
                    precipMm: 0.5,
                    precipIn: 0.02,
                    humidity: 65,
                    cloud: 90,
                    feelslikeC: 1.0,
                    feelslikeF: 33.8,
                    windchillC: 13.0,
                    windchillF: 56.2,
                    heatindexC: 14.0,
                    heatindexF: 58.0,
                    dewpointC: 9.0,
                    dewpointF: 49.0,
                    visKM: 6.0,
                    visMiles: 3.7,
                    uv: 1.0,
                    gustMph: 18.6,
                    gustKph: 30.0,
                    airQuality: WeatherResponse.mock.current.airQuality,
                    timeEpoch: nil,
                    time: nil,
                    snowCM: nil,
                    willItRain: nil,
                    chanceOfRain: nil,
                    willItSnow: nil,
                    chanceOfSnow: nil
                ),
                forecast: Forecast(
                    forecastday: [
                        Forecastday(
                            date: "2026-01-16",
                            dateEpoch: 1_704_086_400,
                            day: Day(
                                maxtempC: 7,
                                maxtempF: 58.4,
                                mintempC: -1,
                                mintempF: 49.0,
                                avgtempC: 3,
                                avgtempF: 52.9,
                                maxwindMph: 11,
                                maxwindKph: 30,
                                totalprecipMm: 3,
                                totalprecipIn: 1,
                                totalsnowCM: 0,
                                avgvisKM: 6,
                                avgvisMiles: 7,
                                avghumidity: 70,
                                dailyWillItRain: 1,
                                dailyChanceOfRain: 40,
                                dailyWillItSnow: 0,
                                dailyChanceOfSnow: 20,
                                condition: Condition(
                                    text: "Light snow showers",
                                    icon: "//cdn.weatherapi.com/weather/64x64/day/326.png",
                                    code: 1213
                                ),
                                uv: 2
                            ),
                            astro: WeatherResponse.mock.forecast.forecastday.first!.astro,
                            hour: WeatherResponse.mock.forecast.forecastday.first!.hour
                        )
                    ]
                )
            )

        ]
    }
}

