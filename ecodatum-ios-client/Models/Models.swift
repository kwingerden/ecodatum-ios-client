import Foundation

typealias Identifier = String
typealias AuthenticationToken = String

protocol DataValue: LosslessStringConvertible {

}

struct User {

  let id: Identifier
  let fullName: String
  let email: String

}

struct Role {

  let id: Identifier
  let name: String

}

struct AuthenticatedUser {

  let userId: Identifier
  let token: AuthenticationToken
  let fullName: String
  let email: String
  let isRootUser: Bool

}

struct Organization {

  let id: Identifier
  let code: String
  let name: String
  let description: String?
  let createdAt: Date
  let updatedAt: Date

}

struct OrganizationMember {

  let user: User
  let role: Role

}

struct Site {

  let id: Identifier
  let name: String
  let description: String?
  let latitude: Double
  let longitude: Double
  let altitude: Double?
  let horizontalAccuracy: Double?
  let verticalAccuracy: Double?
  let organizationId: String
  let userId: Identifier
  let createdAt: Date
  let updatedAt: Date

}

enum EcoFactor: String {

  case Abiotic
  case Biotic

  static let all: [EcoFactor] = [
    .Abiotic,
    .Biotic
  ]

}

enum AbioticFactor: String {

  case Air
  case Soil
  case Water

  static let all: [AbioticFactor] = [
    .Air,
    .Soil,
    .Water
  ]

}

enum AirDataType: String {

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

enum SoilDataType: String {

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

enum WaterDataType: String {

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

enum AbioticDataUnitChoice: String {

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

enum SoilPotassiumScale: DataValue {

  case Low(index: Int, label: String)
  case Medium(index: Int, label: String)
  case High(index: Int, label: String)

  var description: String {
    return ""
  }

  init?(_ description: String) {
    return nil
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

enum WaterOdorScale: DataValue {

  case NoOdor(index: Int, label: String)
  case SlightOdor(index: Int, label: String)
  case Smelly(index: Int, label: String)
  case VerySmelly(index: Int, label: String)
  case Devastating(index: Int, label: String)

  var description: String {
    return ""
  }

  init?(_ description: String) {
    return nil
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

enum WaterTurbidityScale: DataValue {

  case CrystalClear(index: Int, label: String)
  case SlightlyCloudy(index: Int, label: String)
  case ModeratelyCloudy(index: Int, label: String)
  case VeryCloudy(index: Int, label: String)
  case BlackishOrBrownish(index: Int, label: String)

  var description: String {
    return ""
  }

  init?(_ description: String) {
    return nil
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

struct SoilTextureScale: DataValue {

  var description: String {
    return "\(percentSand),\(percentSilt),\(percentClay)"
  }

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

  init?(_ description: String) {
    return nil
  }

  static func ==(_ lhs: SoilTextureScale, _ rhs: SoilTextureScale) -> Bool {
    return lhs.percentSand == rhs.percentSand &&
      lhs.percentSilt == rhs.percentSilt &&
      lhs.percentClay == rhs.percentClay
  }

}

struct DecimalDataValue: DataValue {

  enum Sign {
    case positive
    case negative
  }

  let sign: Sign
  let number: String
  let decimalPoint: Bool
  let fraction: String?

  var description: String {
    return toString()
  }

  var stringValue: String {
    return toString()
  }

  var doubleValue: Double {
    return Double(toString())!
  }

  init(sign: Sign = .positive,
       number: String = "0",
       decimalPoint: Bool = false,
       fraction: String? = nil) {
    self.sign = sign
    self.number = number
    self.decimalPoint = decimalPoint
    self.fraction = fraction
  }

  init?(_ description: String) {
    return nil
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

struct EcoDatum {

  enum AbioticOrBioticData {
    case Abiotic(AbioticEcoData)
    case Biotic(BioticEcoData)
  }

  let id: Identifier?
  let date: Date
  let time: Date
  let ecoFactor: EcoFactor?
  let data: AbioticOrBioticData?

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
       data: AbioticOrBioticData? = nil) {
    self.id = id
    self.date = date
    self.time = time
    self.ecoFactor = ecoFactor
    self.data = data
  }

  func new(date: Date) -> EcoDatum {
    return EcoDatum(
      date: date,
      time: time,
      ecoFactor: ecoFactor,
      data: data)
  }

  func new(time: Date) -> EcoDatum {
    return EcoDatum(
      date: date,
      time: time,
      ecoFactor: ecoFactor,
      data: data)
  }

  func new(ecoFactor: EcoFactor) -> EcoDatum {
    return EcoDatum(
      date: date,
      time: time,
      ecoFactor: ecoFactor,
      data: data)
  }

  func new(data: AbioticOrBioticData) -> EcoDatum {
    return EcoDatum(
      date: date,
      time: time,
      ecoFactor: ecoFactor,
      data: data)
  }

}

struct AbioticEcoData {

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

  func new(abioticFactor: AbioticFactor) -> AbioticEcoData {
    return AbioticEcoData(
      abioticFactor: abioticFactor,
      dataType: dataType,
      dataUnit: dataUnit,
      dataValue: dataValue)
  }

  func new(dataType: AbioticDataTypeChoice) -> AbioticEcoData {
    return AbioticEcoData(
      abioticFactor: abioticFactor,
      dataType: dataType,
      dataUnit: dataUnit,
      dataValue: dataValue)
  }

  func new(dataUnit: AbioticDataUnitChoice) -> AbioticEcoData {
    return AbioticEcoData(
      abioticFactor: abioticFactor,
      dataType: dataType,
      dataUnit: dataUnit,
      dataValue: dataValue)
  }

  func new(dataValue: DataValue?) -> AbioticEcoData {
    return AbioticEcoData(
      abioticFactor: abioticFactor,
      dataType: dataType,
      dataUnit: dataUnit,
      dataValue: dataValue)
  }

}

struct BioticEcoData {

  let image: UIImage?
  let notes: NSAttributedString?

  init(image: UIImage? = nil,
       notes: NSAttributedString? = nil) {
    self.image = image
    self.notes = notes
  }

  func new(image: UIImage?) -> BioticEcoData {
    return BioticEcoData(
      image: image,
      notes: notes)
  }

  func new(notes: NSAttributedString) -> BioticEcoData {
    return BioticEcoData(
      image: image,
      notes: notes)
  }

}
