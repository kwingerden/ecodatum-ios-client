import Foundation

typealias Identifier = String
typealias AuthenticationToken = String

struct User: Codable {

  let id: Identifier
  let fullName: String
  let email: String

}

struct Role: Codable {

  let id: Identifier
  let name: String

}

struct AuthenticatedUser: Codable {

  let userId: Identifier
  let token: AuthenticationToken
  let fullName: String
  let email: String
  let isRootUser: Bool

}

struct Organization: Codable {

  let id: Identifier
  let code: String
  let name: String
  let description: String?
  let createdAt: Date
  let updatedAt: Date

}

struct OrganizationMember: Codable {

  let user: User
  let role: Role

}

struct Site: Codable {

  let id: Identifier
  let name: String
  let description: String?
  let latitude: Double
  let longitude: Double
  let altitude: Double?
  let horizontalAccuracy: Double?
  let verticalAccuracy: Double?
  let organizationId: Identifier
  let userId: Identifier
  let createdAt: Date
  let updatedAt: Date

}

enum EcoFactor: String, Codable {

  case Abiotic
  case Biotic

  static let all: [EcoFactor] = [
    .Abiotic,
    .Biotic
  ]

}

enum AbioticFactor: String, Codable {

  case Air
  case Soil
  case Water

  static let all: [AbioticFactor] = [
    .Air,
    .Soil,
    .Water
  ]

}

enum AirDataType: String, Codable {

  case Velocity
  case CarbonDioxide = "Carbon Dioxide"
  case Light
  case PAR
  case RelativeHumidity = "Relative Humidity"
  case Temperature
  case UVB

  static let all: [AirDataType] = [
    .Velocity,
    .CarbonDioxide,
    .Light,
    .PAR,
    .RelativeHumidity,
    .Temperature,
    .UVB,
  ]

}

enum SoilDataType: String, Codable {

  case Nitrogen
  case Phosphorus
  case Potassium
  case Moisture
  case Texture
  case Temperature

  static let all: [SoilDataType] = [
    .Nitrogen,
    .Phosphorus,
    .Potassium,
    .Moisture,
    .Texture,
    .Temperature
  ]

}

enum WaterDataType: String, Codable {

  case Conductivity
  case DissolvedOxygen = "Dissolved Oxygen"
  case FlowRate = "Flow Rate"
  case Nitrate
  case Odor
  case PAR
  case pH
  case Phosphate
  case Temperature
  case Turbidity

  static let all: [WaterDataType] = [
    .Conductivity,
    .DissolvedOxygen,
    .FlowRate,
    .Nitrate,
    .Odor,
    .PAR,
    .pH,
    .Phosphate,
    .Temperature,
    .Turbidity
  ]

}

enum AbioticDataType {

  case Air([AirDataType])
  case Soil([SoilDataType])
  case Water([WaterDataType])

  static let all: [AbioticDataType] = [
    .Air(AirDataType.all),
    .Soil(SoilDataType.all),
    .Water(WaterDataType.all)
  ]

}

enum AbioticDataTypeChoice {

  case Air(AirDataType)
  case Soil(SoilDataType)
  case Water(WaterDataType)

  static func ==(lhs: AbioticDataTypeChoice, rhs: AbioticDataTypeChoice) -> Bool {
    switch (lhs, rhs) {
    case let (.Air(v1), .Air(v2)) where v1 == v2: return true
    case let (.Soil(v1), .Soil(v2)) where v1 == v2: return true
    case let (.Water(v1), .Water(v2)) where v1 == v2: return true
    default: return false
    }
  }

}

enum AbioticDataUnitChoice: String, Codable {

  case PartsPerMillion = "ppm \\ (Parts \\ Per \\ Million)"
  case Lux = "Lux"
  case PhotosyntheticPhotonFluxDensity = "PPFD \\ (Photosynthetic \\ Photon \\ Flux \\ Density)"
  case MicromolesPerMetersSquaredAndSeconds = "\\mu mol \\ m^{-2}s^{-1}"
  case Percent = "\\%"
  case DegreesCelsius = "^{\\circ}C"
  case DegreesFahrenheit = "^{\\circ}F"
  case MegawattsPerMeterSquared = "\\frac{mW}{m^{2}}"
  case MetersPerSecond = "\\frac{m}{s}"
  case MilesPerHour = "mph"
  case PoundsPerAcre = "\\frac{lb}{a}"
  case MicrosiemensPerCentimeter = "\\frac{\\mu S}{cm}"
  case FeetPerSecond = "\\frac{ft}{s}"
  case MilligramsPerLiter = "\\frac{mg}{L}"
  case NephelometricTurbidityUnits = "NTU \\ (Nephelometric \\ Turbidity \\ Units)"
  case JacksonTurbidityUnits = "JTU \\ (Jackson \\ Turbidity \\ Units)"

  case _Soil_Potassium_Scale_ = "Soil \\ Potassium \\ Scale"
  case _Soil_Texture_Scale_ = "Soil \\ Texture \\ Scale"
  case _Water_Odor_Scale_ = "Water \\ Odor \\ Scale"
  case _Water_pH_Scale_ = "Water \\ pH \\ Scale"
  case _Water_Turbidity_Scale_ = "Water \\ Turbidity \\ Scale"

  static func units(_ dataType: AbioticDataTypeChoice) -> [AbioticDataUnitChoice] {

    switch dataType {

      // ** AIR

    case .Air(let airDataType) where airDataType == .CarbonDioxide:
      return [
        .PartsPerMillion
      ]

    case .Air(let airDataType) where airDataType == .Light:
      return [
        .Lux
      ]

    case .Air(let airDataType) where airDataType == .PAR:
      return [
        .PhotosyntheticPhotonFluxDensity,
        .MicromolesPerMetersSquaredAndSeconds
      ]

    case .Air(let airDataType) where airDataType == .RelativeHumidity:
      return [
        .Percent
      ]

    case .Air(let airDataType) where airDataType == .Temperature:
      return [
        .DegreesCelsius,
        .DegreesFahrenheit
      ]

    case .Air(let airDataType) where airDataType == .UVB:
      return [
        .MegawattsPerMeterSquared,
        .Percent
      ]

    case .Air(let airDataType) where airDataType == .Velocity:
      return [
        .MetersPerSecond,
        .MilesPerHour
      ]

      // ** SOIL

    case .Soil(let soilDataType)
         where soilDataType == .Nitrogen || soilDataType == .Phosphorus:
      return [
        .PoundsPerAcre
      ]

    case .Soil(let soilDataType) where soilDataType == .Potassium:
      return [
        ._Soil_Potassium_Scale_
      ]

    case .Soil(let soilDataType) where soilDataType == .Moisture:
      return [
        .Percent
      ]

    case .Soil(let soilDataType) where soilDataType == .Texture:
      return [
        ._Soil_Texture_Scale_
      ]

    case .Soil(let soilDataType) where soilDataType == .Temperature:
      return [
        .DegreesCelsius,
        .DegreesFahrenheit
      ]

      // ** WATER

    case .Water(let waterDataType) where waterDataType == .Conductivity:
      return [
        .MicrosiemensPerCentimeter
      ]

    case .Water(let waterDataType) where waterDataType == .DissolvedOxygen:
      return [
        .PartsPerMillion,
        .MilligramsPerLiter,
        .Percent
      ]

    case .Water(let waterDataType) where waterDataType == .FlowRate:
      return [
        .MetersPerSecond,
        .FeetPerSecond
      ]

    case .Water(let waterDataType) where waterDataType == .Nitrate:
      return [
        .PartsPerMillion,
        .MilligramsPerLiter
      ]

    case .Water(let waterDataType) where waterDataType == .Odor:
      return [
        ._Water_Odor_Scale_
      ]

    case .Water(let waterDataType) where waterDataType == .PAR:
      return [
        .PhotosyntheticPhotonFluxDensity,
        .MicromolesPerMetersSquaredAndSeconds
      ]

    case .Water(let waterDataType) where waterDataType == .pH:
      return [
        ._Water_pH_Scale_
      ]

    case .Water(let waterDataType) where waterDataType == .Phosphate:
      return [
        .PartsPerMillion,
        .MilligramsPerLiter
      ]

    case .Water(let waterDataType) where waterDataType == .Temperature:
      return [
        .DegreesCelsius,
        .DegreesFahrenheit
      ]

    case .Water(let waterDataType) where waterDataType == .Turbidity:
      return [
        .NephelometricTurbidityUnits,
        .JacksonTurbidityUnits,
        ._Water_Turbidity_Scale_
      ]

    default: return []

    }

  }

}

enum SoilPotassiumScale: Codable {

  case Low(index: Int, label: String)
  case Medium(index: Int, label: String)
  case High(index: Int, label: String)

  init(from decoder: Decoder) throws {
    self = SoilPotassiumScale.all[0]
  }

  enum CodingKeys: String, CodingKey {
    case scale
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .Low(let low):
      try container.encode(low.label, forKey: .scale)
    case .Medium(let medium):
      try container.encode(medium.label, forKey: .scale)
    case .High(let high):
      try container.encode(high.label, forKey: .scale)
    }
  }

  static func ==(_ lhs: SoilPotassiumScale, _ rhs: SoilPotassiumScale) -> Bool {

    var lhsIndex = 0
    switch lhs {
    case .Low(let index, _): lhsIndex = index
    case .Medium(let index, _): lhsIndex = index
    case .High(let index, _): lhsIndex = index
    }

    var rhsIndex = 0
    switch rhs {
    case .Low(let index, _): rhsIndex = index
    case .Medium(let index, _): rhsIndex = index
    case .High(let index, _): rhsIndex = index
    }

    return lhsIndex == rhsIndex

  }

  static let all: [SoilPotassiumScale] = [
    .Low(index: 0, label: "Low"),
    .Medium(index: 1, label: "Medium"),
    .High(index: 2, label: "High")
  ]

}

enum WaterOdorScale: Codable {

  case NoOdor(index: Int, label: String)
  case SlightOdor(index: Int, label: String)
  case Smelly(index: Int, label: String)
  case VerySmelly(index: Int, label: String)
  case Devastating(index: Int, label: String)

  init(from decoder: Decoder) throws {
    self = WaterOdorScale.all[0]
  }

  enum CodingKeys: String, CodingKey {
    case scale
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .NoOdor(let noOdor):
      try container.encode(noOdor.label, forKey: .scale)
    case .SlightOdor(let slightOdor):
      try container.encode(slightOdor.label, forKey: .scale)
    case .Smelly(let smelly):
      try container.encode(smelly.label, forKey: .scale)
    case .VerySmelly(let verySmelly):
      try container.encode(verySmelly.label, forKey: .scale)
    case .Devastating(let devastating):
      try container.encode(devastating.label, forKey: .scale)
    }
  }

  static func ==(_ lhs: WaterOdorScale, _ rhs: WaterOdorScale) -> Bool {

    var lhsIndex = 0
    switch lhs {
    case .NoOdor(let index, _): lhsIndex = index
    case .SlightOdor(let index, _): lhsIndex = index
    case .Smelly(let index, _): lhsIndex = index
    case .VerySmelly(let index, _): lhsIndex = index
    case .Devastating(let index, _): lhsIndex = index
    }

    var rhsIndex = 0
    switch rhs {
    case .NoOdor(let index, _): rhsIndex = index
    case .SlightOdor(let index, _): rhsIndex = index
    case .Smelly(let index, _): rhsIndex = index
    case .VerySmelly(let index, _): rhsIndex = index
    case .Devastating(let index, _): rhsIndex = index
    }

    return lhsIndex == rhsIndex

  }

  static let all: [WaterOdorScale] = [
    .NoOdor(index: 0, label: "No Odor"),
    .SlightOdor(index: 1, label: "Slight Odor"),
    .Smelly(index: 2, label: "Smelly"),
    .VerySmelly(index: 3, label: "Very Smelly"),
    .Devastating(index: 4, label: "Devastating")
  ]

}

enum WaterTurbidityScale: Codable {

  case CrystalClear(index: Int, label: String)
  case SlightlyCloudy(index: Int, label: String)
  case ModeratelyCloudy(index: Int, label: String)
  case VeryCloudy(index: Int, label: String)
  case BlackishOrBrownish(index: Int, label: String)

  init(from decoder: Decoder) throws {
    self = WaterTurbidityScale.all[0]
  }

  enum CodingKeys: String, CodingKey {
    case scale
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .CrystalClear(let crystalClear):
      try container.encode(crystalClear.label, forKey: .scale)
    case .SlightlyCloudy(let slightlyCloudy):
      try container.encode(slightlyCloudy.label, forKey: .scale)
    case .ModeratelyCloudy(let moderatelyCloudy):
      try container.encode(moderatelyCloudy.label, forKey: .scale)
    case .VeryCloudy(let veryCloudy):
      try container.encode(veryCloudy.label, forKey: .scale)
    case .BlackishOrBrownish(let blackishOrBrownish):
      try container.encode(blackishOrBrownish.label, forKey: .scale)
    }
  }

  static func ==(_ lhs: WaterTurbidityScale, _ rhs: WaterTurbidityScale) -> Bool {

    var lhsIndex = 0
    switch lhs {
    case .CrystalClear(let index, _): lhsIndex = index
    case .SlightlyCloudy(let index, _): lhsIndex = index
    case .ModeratelyCloudy(let index, _): lhsIndex = index
    case .VeryCloudy(let index, _): lhsIndex = index
    case .BlackishOrBrownish(let index, _): lhsIndex = index
    }

    var rhsIndex = 0
    switch rhs {
    case .CrystalClear(let index, _): rhsIndex = index
    case .SlightlyCloudy(let index, _): rhsIndex = index
    case .ModeratelyCloudy(let index, _): rhsIndex = index
    case .VeryCloudy(let index, _): rhsIndex = index
    case .BlackishOrBrownish(let index, _): rhsIndex = index
    }

    return lhsIndex == rhsIndex

  }

  static let all: [WaterTurbidityScale] = [
    .CrystalClear(index: 0, label: "Crystal Clear"),
    .SlightlyCloudy(index: 1, label: "Slightly Cloudy"),
    .ModeratelyCloudy(index: 2, label: "Moderately Cloudy"),
    .VeryCloudy(index: 3, label: "Very Cloudy"),
    .BlackishOrBrownish(index: 4, label: "Blackish or Brownish")
  ]

}

struct SoilTextureScale: Codable {

  let percentSand: Int
  let percentSilt: Int
  let percentClay: Int

  init(percentSand: Int,
       percentSilt: Int,
       percentClay: Int) {
    self.percentSand = percentSand
    self.percentSilt = percentSilt
    self.percentClay = percentClay
  }

  static func ==(_ lhs: SoilTextureScale, _ rhs: SoilTextureScale) -> Bool {
    return lhs.percentSand == rhs.percentSand &&
      lhs.percentSilt == rhs.percentSilt &&
      lhs.percentClay == rhs.percentClay
  }

}

enum NumberSign: String, Codable {
  case positive = "+"
  case negative = "-"
}

struct DecimalDataValue: Codable, CustomStringConvertible {

  let sign: NumberSign
  let number: String
  let decimalPoint: Bool
  let fraction: String?

  var description: String {
    return toString()
  }

  var doubleValue: Double {
    return Double(toString())!
  }

  init(sign: NumberSign = .positive,
       number: String = "0",
       decimalPoint: Bool = false,
       fraction: String? = nil) {
    self.sign = sign
    self.number = number
    self.decimalPoint = decimalPoint
    self.fraction = fraction
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    sign = try container.decode(NumberSign.self, forKey: .sign)
    number = try container.decode(String.self, forKey: .number)
    decimalPoint = try container.decode(Bool.self, forKey: .decimalPoint)
    fraction = try container.decodeIfPresent(String.self, forKey: .fraction)
  }

  enum CodingKeys: String, CodingKey {
    case sign
    case number
    case decimalPoint
    case fraction
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(sign, forKey: .sign)
    try container.encode(number, forKey: .number)
    try container.encode(decimalPoint, forKey: .decimalPoint)
    try container.encode(fraction, forKey: .fraction)
  }

  func toggleSign() -> DecimalDataValue {

    if doubleValue == 0 {

      return DecimalDataValue(
        sign: .positive,
        number: number,
        decimalPoint: decimalPoint,
        fraction: fraction)

    } else {

      return DecimalDataValue(
        sign: sign == .positive ? .negative : .positive,
        number: number,
        decimalPoint: decimalPoint,
        fraction: fraction)

    }

  }

  func addDecimalPoint() -> DecimalDataValue {

    if decimalPoint {

      return self

    } else {

      return DecimalDataValue(
        sign: sign,
        number: number,
        decimalPoint: true,
        fraction: nil)

    }

  }

  func addDigit(_ digit: Int) -> DecimalDataValue {

    if let fraction = fraction {

      return DecimalDataValue(
        sign: sign,
        number: number,
        decimalPoint: decimalPoint,
        fraction: "\(fraction)\(digit)")

    } else if decimalPoint {

      return DecimalDataValue(
        sign: sign,
        number: number,
        decimalPoint: decimalPoint,
        fraction: "\(digit)")

    } else {

      var newNumber = "\(number)\(digit)"
      if doubleValue == 0 {
        newNumber = "\(digit)"
      }
      return DecimalDataValue(
        sign: sign,
        number: newNumber,
        decimalPoint: false,
        fraction: nil)

    }

  }

  func deleteDigit() -> DecimalDataValue {

    var newSign = sign
    if doubleValue == 0 {
      newSign = .positive
    }

    if let fraction = fraction {

      var newFraction = fraction
      newFraction.removeLast()
      return DecimalDataValue(
        sign: newSign,
        number: number,
        decimalPoint: decimalPoint,
        fraction: newFraction.count == 0 ? nil : newFraction)

    } else if decimalPoint {

      return DecimalDataValue(
        sign: newSign,
        number: number,
        decimalPoint: false,
        fraction: nil)

    } else {

      var newNumber = number
      newNumber.removeLast()

      if newNumber.count == 0 {
        newSign = .positive
      } else if let intNumber = Int(newNumber),
                intNumber == 0 {
        newSign = .positive
      }

      return DecimalDataValue(
        sign: newSign,
        number: newNumber.count == 0 ? "0" : newNumber,
        decimalPoint: false,
        fraction: nil)

    }

  }

  static func ==(_ lhs: DecimalDataValue, _ rhs: DecimalDataValue) -> Bool {
    return lhs.sign == rhs.sign &&
      lhs.number == rhs.number &&
      lhs.decimalPoint == rhs.decimalPoint &&
      lhs.fraction == rhs.fraction
  }

  private func toString() -> String {

    let sign = self.sign == .positive ? "" : "-"
    let decimalPoint = self.decimalPoint ? "." : ""

    if let fraction = fraction {
      return "\(sign)\(number).\(fraction)"
    } else if Int(number) == 0 {
      return "0\(decimalPoint)"
    } else {
      return "\(sign)\(number)\(decimalPoint)"
    }

  }

}

enum AbioticOrBioticData: Codable {

  case Abiotic(AbioticEcoData)
  case Biotic(BioticEcoData)

  enum CodingKeys: String, CodingKey {
    case abiotic
    case biotic
  }

  init(from decoder: Decoder) throws {
    self = .Abiotic(AbioticEcoData())
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .Abiotic(let abioticEcoData):
      try container.encode(abioticEcoData, forKey: .abiotic)
    case .Biotic(let bioticEcoData):
      try container.encode(bioticEcoData, forKey: .biotic)
    }
  }

}

enum DataValue {

  case DecimalDataValue(DecimalDataValue)
  case SoilPotassiumScale(SoilPotassiumScale)
  case SoilTextureScale(SoilTextureScale)
  case WaterOdorScale(WaterOdorScale)
  case WaterTurbidityScale(WaterTurbidityScale)

  static func ==(_ lhs: DataValue, _ rhs: DataValue) -> Bool {

    switch lhs {
    case .DecimalDataValue(let lhsDecimalDataValue):
      switch rhs {
      case .DecimalDataValue(let rhsDecimalDataValue):
        return lhsDecimalDataValue == rhsDecimalDataValue
      default: break
      }
    case .SoilPotassiumScale(let lhsSoilPotassiumScale):
      switch rhs {
      case .SoilPotassiumScale(let rhsSoilPotassiumScale):
        return lhsSoilPotassiumScale == rhsSoilPotassiumScale
      default: break
      }
    case .SoilTextureScale(let lhsSoilTextureScale):
      switch rhs {
      case .SoilTextureScale(let rhsSoilTextureScale):
        return lhsSoilTextureScale == rhsSoilTextureScale
      default: break
      }
    case .WaterOdorScale(let lhsWaterOdorScale):
      switch rhs {
      case .WaterOdorScale(let rhsWaterOdorScale):
        return lhsWaterOdorScale == rhsWaterOdorScale
      default: break
      }
    case .WaterTurbidityScale(let lhsWaterTurbidityScale):
      switch rhs {
      case .WaterTurbidityScale(let rhsWaterTurbidityScale):
        return lhsWaterTurbidityScale == rhsWaterTurbidityScale
      default: break
      }
    }

    return false

  }

}

struct EcoDatum: Codable {

  let id: Identifier?
  let date: Date
  let time: Date
  let ecoFactor: EcoFactor?
  let data: AbioticOrBioticData?
  let siteId: Identifier
  let userId: Identifier

  var json: String {
    let jsonEncoder = JSONEncoder()
    jsonEncoder.dateEncodingStrategy = .customISO8601
    let data = try! jsonEncoder.encode(self)
    return String(data: data, encoding: .utf8)!
  }

  enum CodingKeys: String, CodingKey {
    case id
    case date
    case time
    case ecoFactor
    case data
    case siteId
    case userId
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decodeIfPresent(Identifier.self, forKey: .id)
    date = try container.decode(Date.self, forKey: .date)
    time = try container.decode(Date.self, forKey: .time)
    ecoFactor = try container.decode(EcoFactor.self, forKey: .ecoFactor)
    switch ecoFactor {
    case .Abiotic?:
      data = AbioticOrBioticData.Abiotic(
        try container.decode(AbioticEcoData.self, forKey: .data))
    case .Biotic?:
      data = AbioticOrBioticData.Biotic(
        try container.decode(BioticEcoData.self, forKey: .data))
    default:
      fatalError()
    }
    siteId = try container.decode(Identifier.self, forKey: .siteId)
    userId = try container.decode(Identifier.self, forKey: .userId)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(date, forKey: .date)
    try container.encode(time, forKey: .time)
    try container.encode(ecoFactor, forKey: .ecoFactor)
    switch data {
    case .Abiotic(let abioticEcoData)?:
      try container.encode(abioticEcoData, forKey: .data)
    case .Biotic(let bioticEcoData)?:
      try container.encode(bioticEcoData, forKey: .data)
    default:
      fatalError()
    }
    try container.encode(siteId, forKey: .siteId)
    try container.encode(userId, forKey: .userId)
  }

  var abioticEcoData: AbioticEcoData? {
    switch data {
    case .Abiotic(let abioticEcoData)?: return abioticEcoData
    default: return nil
    }
  }

  var bioticEcoData: BioticEcoData? {
    switch data {
    case .Biotic(let bioticEcoData)?: return bioticEcoData
    default: return nil
    }
  }

  var abioticFactor: AbioticFactor? {
    return abioticEcoData?.abioticFactor
  }

  init(id: Identifier? = nil,
       date: Date = Date(),
       time: Date = Date(),
       ecoFactor: EcoFactor? = nil,
       data: AbioticOrBioticData? = nil,
       userId: Identifier,
       siteId: Identifier) {
    self.id = id
    self.date = date
    self.time = time
    self.ecoFactor = ecoFactor
    self.data = data
    self.userId = userId
    self.siteId = siteId
  }

  func new(id: Identifier) -> EcoDatum {
    return EcoDatum(
      id: id,
      date: date,
      time: time,
      ecoFactor: ecoFactor,
      data: data,
      userId: userId,
      siteId: siteId)
  }

  func new(date: Date) -> EcoDatum {
    return EcoDatum(
      id: id,
      date: date,
      time: time,
      ecoFactor: ecoFactor,
      data: data,
      userId: userId,
      siteId: siteId)
  }

  func new(time: Date) -> EcoDatum {
    return EcoDatum(
      id: id,
      date: date,
      time: time,
      ecoFactor: ecoFactor,
      data: data,
      userId: userId,
      siteId: siteId)
  }

  func new(ecoFactor: EcoFactor) -> EcoDatum {
    return EcoDatum(
      id: id,
      date: date,
      time: time,
      ecoFactor: ecoFactor,
      data: data,
      userId: userId,
      siteId: siteId)
  }

  func new(data: AbioticOrBioticData) -> EcoDatum {
    return EcoDatum(
      id: id,
      date: date,
      time: time,
      ecoFactor: ecoFactor,
      data: data,
      userId: userId,
      siteId: siteId)
  }

}

struct AbioticEcoData: Codable {

  let abioticFactor: AbioticFactor?
  let dataType: AbioticDataTypeChoice?
  let dataUnit: AbioticDataUnitChoice?
  let dataValue: DataValue?

  init(abioticFactor: AbioticFactor? = nil,
       dataType: AbioticDataTypeChoice? = nil,
       dataUnit: AbioticDataUnitChoice? = nil,
       dataValue: DataValue? = nil) {
    self.abioticFactor = abioticFactor
    self.dataType = dataType
    self.dataUnit = dataUnit
    self.dataValue = dataValue
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    abioticFactor = try container.decode(AbioticFactor.self, forKey: .abioticFactor)

    switch abioticFactor {
    case .Air?:
      dataType = AbioticDataTypeChoice.Air(
        try container.decode(AirDataType.self, forKey: .dataType))
    case .Soil?:
      dataType = AbioticDataTypeChoice.Soil(
        try container.decode(SoilDataType.self, forKey: .dataType))
    case .Water?:
      dataType = AbioticDataTypeChoice.Water(
        try container.decode(WaterDataType.self, forKey: .dataType))
    default: fatalError()
    }

    dataUnit = try container.decode(AbioticDataUnitChoice.self, forKey: .dataUnit)

    switch dataUnit {

    case ._Soil_Potassium_Scale_?:
      var tempDataValue: DataValue?
      let dataValueString = try container.decode(String.self, forKey: .dataValue)
      SoilPotassiumScale.all.forEach {
        switch $0 {
        case .Low(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.SoilPotassiumScale($0)
          }
        case .Medium(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.SoilPotassiumScale($0)
          }
        case .High(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.SoilPotassiumScale($0)
          }
        }
      }
      dataValue = tempDataValue

    case ._Water_Odor_Scale_?:
      var tempDataValue: DataValue?
      let dataValueString = try container.decode(String.self, forKey: .dataValue)
      WaterOdorScale.all.forEach {
        switch $0 {
        case .NoOdor(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterOdorScale($0)
          }
        case .SlightOdor(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterOdorScale($0)
          }
        case .Smelly(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterOdorScale($0)
          }
        case .VerySmelly(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterOdorScale($0)
          }
        case .Devastating(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterOdorScale($0)
          }
        }
      }
      dataValue = tempDataValue

    case ._Water_Turbidity_Scale_?:
      var tempDataValue: DataValue?
      let dataValueString = try container.decode(String.self, forKey: .dataValue)
      WaterTurbidityScale.all.forEach {
        switch $0 {
        case .CrystalClear(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterTurbidityScale($0)
          }
        case .SlightlyCloudy(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterTurbidityScale($0)
          }
        case .ModeratelyCloudy(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterTurbidityScale($0)
          }
        case .VeryCloudy(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterTurbidityScale($0)
          }
        case .BlackishOrBrownish(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterTurbidityScale($0)
          }
        }
      }
      dataValue = tempDataValue

    case ._Soil_Texture_Scale_?:
      dataValue = DataValue.SoilTextureScale(
        try container.decode(SoilTextureScale.self, forKey: .dataValue))

    default:
      dataValue = DataValue.DecimalDataValue(
        try container.decode(DecimalDataValue.self, forKey: .dataValue))

    }
  }

  enum CodingKeys: String, CodingKey {
    case abioticFactor
    case dataType
    case dataUnit
    case dataValue
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(abioticFactor, forKey: .abioticFactor)

    switch dataType {
    case .Air(let airDataType)?:
      try container.encode(airDataType, forKey: .dataType)
    case .Soil(let soilDataType)?:
      try container.encode(soilDataType, forKey: .dataType)
    case .Water(let waterDataType)?:
      try container.encode(waterDataType, forKey: .dataType)
    default: fatalError()
    }

    try container.encode(dataUnit, forKey: .dataUnit)

    switch dataValue {

    case .DecimalDataValue(let decimalDataValue)?:
      try container.encode(decimalDataValue, forKey: .dataValue)

    case .SoilPotassiumScale(let soilPotassiumScale)?:
      switch soilPotassiumScale {
      case .Low(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .Medium(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .High(_, let label):
        try container.encode(label, forKey: .dataValue)
      }

    case .SoilTextureScale(let soilTextureScale)?:
      try container.encode(soilTextureScale, forKey: .dataValue)

    case .WaterOdorScale(let waterOdorScale)?:
      switch waterOdorScale {
      case .NoOdor(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .SlightOdor(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .Smelly(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .VerySmelly(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .Devastating(_, let label):
        try container.encode(label, forKey: .dataValue)
      }

    case .WaterTurbidityScale(let waterTurbidityScale)?:
      switch waterTurbidityScale {
      case .CrystalClear(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .SlightlyCloudy(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .ModeratelyCloudy(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .VeryCloudy(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .BlackishOrBrownish(_, let label):
        try container.encode(label, forKey: .dataValue)
      }

    default: fatalError()

    }

  }

  func new(abioticFactor: AbioticFactor) -> AbioticEcoData {
    return AbioticEcoData(
      abioticFactor: abioticFactor,
      dataType: nil,
      dataUnit: nil,
      dataValue: nil)
  }

  func new(dataType: AbioticDataTypeChoice) -> AbioticEcoData {
    return AbioticEcoData(
      abioticFactor: abioticFactor,
      dataType: dataType,
      dataUnit: nil,
      dataValue: nil)
  }

  func new(dataUnit: AbioticDataUnitChoice) -> AbioticEcoData {
    return AbioticEcoData(
      abioticFactor: abioticFactor,
      dataType: dataType,
      dataUnit: dataUnit,
      dataValue: nil)
  }

  func new(dataValue: DataValue?) -> AbioticEcoData {
    return AbioticEcoData(
      abioticFactor: abioticFactor,
      dataType: dataType,
      dataUnit: dataUnit,
      dataValue: dataValue)
  }

}

struct BioticEcoData: Codable {

  let image: UIImage?
  let notes: NSAttributedString?

  init(image: UIImage? = nil,
       notes: NSAttributedString? = nil) {
    self.image = image
    self.notes = notes
  }

  enum CodingKeys: String, CodingKey {
    case image
    case notes
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    image = UIImage.base64Decode(
      try container.decode(Base64Encoded.self, forKey: .image))
    notes = try NSAttributedString.base64Decode(
      try container.decode(Base64Encoded.self, forKey: .notes))
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(image!.base64Encode(), forKey: .image)
    try container.encode(notes!.base64Encode(), forKey: .notes)
  }

  func new(image: UIImage?) -> BioticEcoData {
    return BioticEcoData(
      image: image,
      notes: nil)
  }

  func new(notes: NSAttributedString) -> BioticEcoData {
    return BioticEcoData(
      image: image,
      notes: notes)
  }

}
