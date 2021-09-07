//
//  CurrencyModel.swift
//  
//
//  Created by Артур on 5.05.21.
//

import Foundation
import RealmSwift





class CurrencyList {
let validISOList = ["USD","EUR","JPY","GBP","AUD","CHF","CAD","CNY","SEK","NOK","NZD","SGD","HKD","KRW","TRY","RUB","INR","BRL","ZAR","BYN","UAH","ILS","BGN","CZK","DKK","HRK","HUF","IDR","ISK","MXN","MYR","PLN","RON","THB","KZT","AMD","ALL","BAM","RSD","AZN","SAR","EGP","TMT"]


public var identifiers: [String: CurrencyLocale] = ["USD": .englishUnitedStates
                                                ,"EUR":.englishGermany,
                                                "JPY":.japaneseJapan, // минимальный 1 иен
                                                "GBP": .englishUnitedKingdom,
                                                "AUD": .englishAustralia,
                                                "CHF": .swissGermanSwitzerland,
                                                "CAD": .englishCanada,
                                                "CNY":.chineseChina,
                                                "SEK":.swedishSweden,//Минимальная 1 крона
                                                "NOK":.norwegianBokmlNorway, //Минимальная 1 крона
                                                "NZD":.englishNewZealand,
                                                "SGD": .englishSingapore,
                                                "HKD": .chineseHongKongSarChina,
                                                "KRW":.koreanSouthKorea,
                                                "TRY":.turkishTurkey,
                                                "RUB": .russianRussia,
                                                "INR":.englishIndia,
                                                "BRL": .portugueseBrazil,
                                                "ZAR": .englishSouthAfrica,
                                                "BYN": .russianBelarus,
                                                "UAH":.ukrainianUkraine,
                                                "ILS":.englishIsrael,
                                                "BGN":.bulgarianBulgaria,
                                                "CZK":.czechCzechRepublic, // Минимальная единица 1 крона
                                                "DKK":.danishDenmark,
                                                "HRK":.englishCroatia,
                                                "HUF": .hungarianHungary, // Минимальная едигница 1 форит
                                                "IDR":.indonesianIndonesia,//Минимальная единица 1 рупий
                                                "ISK": .faroeseFaroeIslands,// минималльная единица 1 крон
                                                "MXN":.spanishMexico, //
                                                "MYR":.englishMalaysia,
                                                "PLN":.polishPoland,
                                                "RON":.romanianMoldova,
                                                "THB":.thaiThailand,
                                                "KZT":.russianKazakhstan,
                                                "AMD":.armenianArmenia,
                                                "ALL":.albanianAlbania,
                                                "BAM":.bosnianBosniaHerzegovina,
                                                "RSD":.serbianSerbia,
                                                "AZN": .azerbaijaniAzerbaijan,
                                                "SAR": .arabicSaudiArabia,
                                                "EGP": .arabicEgypt,
                                                "TMT": .turkmenTurkmenistan
]



//["USD","EUR","JPY","GBP","AUD","CHF","CAD","CNY","SEK","NOK","NZD","SGD","HKD","KRW","TRY","RUB","INR","BRL","ZAR","BYN","UAH","ILS","BGN","CZK","DKK","HRK","HUF","IDR","ISK","MXN","MYR","PLN","RON","THB","KZT"]
public enum CurrencyName: String {
    case USD
    case EUR
    case JPY
    case GBP
    case AUD
    case CHF
    case CAD
    case CNY
    case SEK
    case NOK
    case NZD
    case SGD
    case HKD
    case KRW
    case TRY
    case RUB
    case INR
    case BRL
    case ZAR
    case BYN
    case UAH
    case ILS
    case BGN
    case CZK
    case DKK
    case HRK
    case HUF
    case IDR
    case ISK
    case MXN
    case MYR
    case PLN
    case RON
    case THB
    case KZT
    case AMD
    case ALL
    case BAM
    case RSD
    case AZN
    case SAR
    case EGP
    case TMT
    func getLocalozed(iso: String) -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    var getRaw: String {
        switch self {
        case .USD: return NSLocalizedString("USD", comment: "")
        
        case .EUR: return NSLocalizedString("EUR", comment: "")
        
        case .JPY:
            return NSLocalizedString("JPY", comment: "")
        case .GBP:
            return NSLocalizedString("GBP", comment: "")
        case .AUD:
            return NSLocalizedString("AUD", comment: "")
        case .CHF:
            return NSLocalizedString("CHF", comment: "")
        case .CAD:
            return NSLocalizedString("CAD", comment: "")
        case .CNY:
            return NSLocalizedString("CNY", comment: "")
        case .SEK:
            return NSLocalizedString("SEK", comment: "")
        case .NOK:
            return NSLocalizedString("NOK", comment: "")
        case .NZD:
            return NSLocalizedString("NZD", comment: "")
        case .SGD:
            return NSLocalizedString("SGD", comment: "")
        case .HKD:
            return NSLocalizedString("HKD", comment: "")
        case .KRW:
            return NSLocalizedString("KRW", comment: "")
        case .TRY:
            return NSLocalizedString("TRY", comment: "")
        case .RUB:
            return NSLocalizedString("RUB", comment: "")
        case .INR:
            return NSLocalizedString("INR", comment: "")
        case .BRL:
            return NSLocalizedString("BRL", comment: "")
        case .ZAR:
            return NSLocalizedString("ZAR", comment: "")
        case .BYN:
            return NSLocalizedString("BYN", comment: "")
        case .UAH:
            return NSLocalizedString("UAH", comment: "")
        case .ILS:
            return NSLocalizedString("ILS", comment: "")
        case .BGN:
            return NSLocalizedString("BGN", comment: "")
        case .CZK:
            return NSLocalizedString("CZK", comment: "")
        case .DKK:
            return NSLocalizedString("DKK", comment: "")
        case .HRK:
            return NSLocalizedString("HRK", comment: "")
        case .HUF:
            return NSLocalizedString("HUF", comment: "")
        case .IDR:
            return NSLocalizedString("IDR", comment: "")
        case .ISK:
            return NSLocalizedString("ISK", comment: "")
        case .MXN:
            return NSLocalizedString("MXN", comment: "")
        case .MYR:
            return NSLocalizedString("MYR", comment: "")
        case .PLN:
            return NSLocalizedString("PLN", comment: "")
        case .RON:
            return NSLocalizedString("RON", comment: "")
        case .THB:
            return NSLocalizedString("THB", comment: "")
        case .KZT:
            return NSLocalizedString("KZT", comment: "")
        case .AMD:
            return NSLocalizedString("AMD", comment: "")
        case .ALL:
            return NSLocalizedString("ALL", comment: "")
        case .BAM:
            return NSLocalizedString("BAM", comment: "")
        case .RSD:
            return NSLocalizedString("RSD", comment: "")
        case .AZN:
            return NSLocalizedString("AZN", comment: "")
        case .SAR:
            return NSLocalizedString("SAR", comment: "")
        case .EGP:
            return NSLocalizedString("EGP", comment: "")
        case .TMT:
            return NSLocalizedString("TMT", comment: "")
            
        }
        
      
    }
    


//    func getTitleFor(title: String) -> String {
//           return CurrencyName.localizedString()
//       }

}

public enum CurrencyLocale: String {
    
    case current = "current"
    case autoUpdating = "currentAutoUpdating"
    
    case afrikaans = "af"
    case afrikaansNamibia = "af_NA"
    case afrikaansSouthAfrica = "af_ZA"
    case aghem = "agq"
    case aghemCameroon = "agq_CM"
    case akan = "ak"
    case akanGhana = "ak_GH"
    case albanian = "sq"
    case albanianAlbania = "sq_AL"
    case albanianKosovo = "sq_XK"
    case albanianMacedonia = "sq_MK"
    case amharic = "am"
    case amharicEthiopia = "am_ET"
    case arabic = "ar"
    case arabicAlgeria = "ar_DZ"
    case arabicBahrain = "ar_BH"
    case arabicChad = "ar_TD"
    case arabicComoros = "ar_KM"
    case arabicDjibouti = "ar_DJ"
    case arabicEgypt = "ar_EG"
    case arabicEritrea = "ar_ER"
    case arabicIraq = "ar_IQ"
    case arabicIsrael = "ar_IL"
    case arabicJordan = "ar_JO"
    case arabicKuwait = "ar_KW"
    case arabicLebanon = "ar_LB"
    case arabicLibya = "ar_LY"
    case arabicMauritania = "ar_MR"
    case arabicMorocco = "ar_MA"
    case arabicOman = "ar_OM"
    case arabicPalestinianTerritories = "ar_PS"
    case arabicQatar = "ar_QA"
    case arabicSaudiArabia = "ar_SA"
    case arabicSomalia = "ar_SO"
    case arabicSouthSudan = "ar_SS"
    case arabicSudan = "ar_SD"
    case arabicSyria = "ar_SY"
    case arabicTunisia = "ar_TN"
    case arabicUnitedArabEmirates = "ar_AE"
    case arabicWesternSahara = "ar_EH"
    case arabicWorld = "ar_001"
    case arabicYemen = "ar_YE"
    case armenian = "hy"
    case armenianArmenia = "hy_AM"
    case assamese = "as"
    case assameseIndia = "as_IN"
    case asu = "asa"
    case asuTanzania = "asa_TZ"
    case azerbaijani = "az_Latn"
    case azerbaijaniAzerbaijan = "az_Latn_AZ"
    case azerbaijaniCyrillic = "az_Cyrl"
    case azerbaijaniCyrillicAzerbaijan = "az_Cyrl_AZ"
    case bafia = "ksf"
    case bafiaCameroon = "ksf_CM"
    case bambara = "bm_Latn"
    case bambaraMali = "bm_Latn_ML"
    case basaa = "bas"
    case basaaCameroon = "bas_CM"
    case basque = "eu"
    case basqueSpain = "eu_ES"
    case belarusian = "be"
    case belarusianBelarus = "be_BY"
    case bemba = "bem"
    case bembaZambia = "bem_ZM"
    case bena = "bez"
    case benaTanzania = "bez_TZ"
    case bengali = "bn"
    case bengaliBangladesh = "bn_BD"
    case engaliIndia = "bn_IN"
    case bodo = "brx"
    case bodoIndia = "brx_IN"
    case bosnian = "bs_Latn"
    case bosnianBosniaHerzegovina = "bs_Latn_BA"
    case bosnianCyrillic = "bs_Cyrl"
    case bosnianCyrillicBosniaHerzegovina = "bs_Cyrl_BA"
    case breton = "br"
    case bretonFrance = "br_FR"
    case bulgarian = "bg"
    case bulgarianBulgaria = "bg_BG"
    case burmese = "my"
    case burmeseMyanmarBurma = "my_MM"
    case catalan = "ca"
    case catalanAndorra = "ca_AD"
    case catalanFrance = "ca_FR"
    case catalanItaly = "ca_IT"
    case catalanSpain = "ca_ES"
    case centralAtlasTamazight = "tzm_Latn"
    case centralAtlasTamazightMorocco = "tzm_Latn_MA"
    case centralKurdish = "ckb"
    case centralKurdishIran = "ckb_IR"
    case centralKurdishIraq = "ckb_IQ"
    case cherokee = "chr"
    case cherokeeUnitedStates = "chr_US"
    case chiga = "cgg"
    case chigaUganda = "cgg_UG"
    case chinese = "zh"
    case chineseChina = "zh_Hans_CN"
    case chineseHongKongSarChina = "zh_Hant_HK"
    case chineseMacauSarChina = "zh_Hant_MO"
    case chineseSimplified = "zh_Hans"
    case chineseSimplifiedHongKongSarChina = "zh_Hans_HK"
    case chineseSimplifiedMacauSarChina = "zh_Hans_MO"
    case chineseSingapore = "zh_Hans_SG"
    case chineseTaiwan = "zh_Hant_TW"
    case chineseTraditional = "zh_Hant"
    case colognian = "ksh"
    case colognianGermany = "ksh_DE"
    case cornish = "kw"
    case cornishUnitedKingdom = "kw_GB"
    case croatian = "hr"
    case croatianBosniaHerzegovina = "hr_BA"
    case croatianCroatia = "hr_HR"
    case czech = "cs"
    case czechCzechRepublic = "cs_CZ"
    case danish = "da"
    case danishDenmark = "da_DK"
    case danishGreenland = "da_GL"
    case duala = "dua"
    case dualaCameroon = "dua_CM"
    case dutch = "nl"
    case dutchAruba = "nl_AW"
    case dutchBelgium = "nl_BE"
    case dutchCaribbeanNetherlands = "nl_BQ"
    case dutchCuraao = "nl_CW"
    case dutchNetherlands = "nl_NL"
    case dutchSintMaarten = "nl_SX"
    case dutchSuriname = "nl_SR"
    case dzongkha = "dz"
    case dzongkhaBhutan = "dz_BT"
    case embu = "ebu"
    case embuKenya = "ebu_KE"
    case english = "en"
    case englishAlbania = "en_AL"
    case englishAmericanSamoa = "en_AS"
    case englishAndorra = "en_AD"
    case englishAnguilla = "en_AI"
    case englishAntiguaBarbuda = "en_AG"
    case englishAustralia = "en_AU"
    case englishAustria = "en_AT"
    case englishBahamas = "en_BS"
    case englishBarbados = "en_BB"
    case englishBelgium = "en_BE"
    case englishBelize = "en_BZ"
    case englishBermuda = "en_BM"
    case englishBosniaHerzegovina = "en_BA"
    case englishBotswana = "en_BW"
    case englishBritishIndianOceanTerritory = "en_IO"
    case englishBritishVirginIslands = "en_VG"
    case englishCameroon = "en_CM"
    case englishCanada = "en_CA"
    case englishCaymanIslands = "en_KY"
    case englishChristmasIsland = "en_CX"
    case englishCocosKeelingIslands = "en_CC"
    case englishCookIslands = "en_CK"
    case englishCroatia = "en_HR"
    case englishCyprus = "en_CY"
    case englishCzechRepublic = "en_CZ"
    case englishDenmark = "en_DK"
    case englishDiegoGarcia = "en_DG"
    case englishDominica = "en_DM"
    case englishEritrea = "en_ER"
    case englishEstonia = "en_EE"
    case englishEurope = "en_150"
    case englishFalklandIslands = "en_FK"
    case englishFiji = "en_FJ"
    case englishKuwait = "en_KW"
    case englishFinland = "en_FI"
    case englishFrance = "en_FR"
    case englishGambia = "en_GM"
    case englishGermany = "en_DE"
    case englishGhana = "en_GH"
    case englishGibraltar = "en_GI"
    case englishGreece = "en_GR"
    case englishGrenada = "en_GD"
    case englishGuam = "en_GU"
    case englishGuernsey = "en_GG"
    case englishGuyana = "en_GY"
    case englishHongKongSarChina = "en_HK"
    case englishHungary = "en_HU"
    case englishIceland = "en_IS"
    case englishIndia = "en_IN"
    case englishIreland = "en_IE"
    case englishIsleOfMan = "en_IM"
    case englishIsrael = "en_IL"
    case englishItaly = "en_IT"
    case englishJamaica = "en_JM"
    case englishJersey = "en_JE"
    case englishKenya = "en_KE"
    case englishKiribati = "en_KI"
    case englishLatvia = "en_LV"
    case englishLesotho = "en_LS"
    case englishLiberia = "en_LR"
    case englishLithuania = "en_LT"
    case englishLuxembourg = "en_LU"
    case englishMacauSarChina = "en_MO"
    case englishMadagascar = "en_MG"
    case englishMalawi = "en_MW"
    case englishMalaysia = "en_MY"
    case englishMalta = "en_MT"
    case englishMarshallIslands = "en_MH"
    case englishMauritius = "en_MU"
    case englishMicronesia = "en_FM"
    case englishMontenegro = "en_ME"
    case englishMontserrat = "en_MS"
    case englishNamibia = "en_NA"
    case englishNauru = "en_NR"
    case englishNetherlands = "en_NL"
    case englishNewZealand = "en_NZ"
    case englishNigeria = "en_NG"
    case englishNiue = "en_NU"
    case englishNorfolkIsland = "en_NF"
    case englishNorthernMarianaIslands = "en_MP"
    case englishNorway = "en_NO"
    case englishPakistan = "en_PK"
    case englishPalau = "en_PW"
    case englishPapuaNewGuinea = "en_PG"
    case englishPhilippines = "en_PH"
    case englishPitcairnIslands = "en_PN"
    case englishPoland = "en_PL"
    case englishPortugal = "en_PT"
    case englishPuertoRico = "en_PR"
    case englishRomania = "en_RO"
    case englishRussia = "en_RU"
    case englishRwanda = "en_RW"
    case englishSamoa = "en_WS"
    case englishSeychelles = "en_SC"
    case englishSierraLeone = "en_SL"
    case englishSingapore = "en_SG"
    case englishSintMaarten = "en_SX"
    case englishSlovakia = "en_SK"
    case englishSlovenia = "en_SI"
    case englishSolomonIslands = "en_SB"
    case englishSouthAfrica = "en_ZA"
    case englishSouthSudan = "en_SS"
    case englishSpain = "en_ES"
    case englishStHelena = "en_SH"
    case englishStKittsNevis = "en_KN"
    case englishStLucia = "en_LC"
    case englishStVincentGrenadines = "en_VC"
    case englishSudan = "en_SD"
    case englishSwaziland = "en_SZ"
    case englishSweden = "en_SE"
    case englishSwitzerland = "en_CH"
    case englishTanzania = "en_TZ"
    case englishTokelau = "en_TK"
    case englishTonga = "en_TO"
    case englishTrinidadTobago = "en_TT"
    case englishTurkey = "en_TR"
    case englishTurksCaicosIslands = "en_TC"
    case englishTuvalu = "en_TV"
    case englishUSOutlyingIslands = "en_UM"
    case englishUSVirginIslands = "en_VI"
    case englishUganda = "en_UG"
    case englishUnitedKingdom = "en_GB"
    case englishUnitedStates = "en_US"
    case englishUnitedStatesComputer = "en_US_POSIX"
    case englishVanuatu = "en_VU"
    case englishWorld = "en_001"
    case englishZambia = "en_ZM"
    case englishZimbabwe = "en_ZW"
    case esperanto = "eo"
    case estonian = "et"
    case estonianEstonia = "et_EE"
    case ewe = "ee"
    case eweGhana = "ee_GH"
    case eweTogo = "ee_TG"
    case ewondo = "ewo"
    case ewondoCameroon = "ewo_CM"
    case faroese = "fo"
    case faroeseFaroeIslands = "fo_FO"
    case filipino = "fil"
    case filipinoPhilippines = "fil_PH"
    case finnish = "fi"
    case finnishFinland = "fi_FI"
    case french = "fr"
    case frenchAlgeria = "fr_DZ"
    case frenchBelgium = "fr_BE"
    case frenchBenin = "fr_BJ"
    case frenchBurkinaFaso = "fr_BF"
    case frenchBurundi = "fr_BI"
    case frenchCameroon = "fr_CM"
    case frenchCanada = "fr_CA"
    case frenchCentralAfricanRepublic = "fr_CF"
    case frenchChad = "fr_TD"
    case frenchComoros = "fr_KM"
    case frenchCongoBrazzaville = "fr_CG"
    case frenchCongoKinshasa = "fr_CD"
    case frenchCteDivoire = "fr_CI"
    case frenchDjibouti = "fr_DJ"
    case frenchEquatorialGuinea = "fr_GQ"
    case frenchFrance = "fr_FR"
    case frenchFrenchGuiana = "fr_GF"
    case frenchFrenchPolynesia = "fr_PF"
    case frenchGabon = "fr_GA"
    case frenchGuadeloupe = "fr_GP"
    case frenchGuinea = "fr_GN"
    case frenchHaiti = "fr_HT"
    case frenchLuxembourg = "fr_LU"
    case frenchMadagascar = "fr_MG"
    case frenchMali = "fr_ML"
    case frenchMartinique = "fr_MQ"
    case frenchMauritania = "fr_MR"
    case frenchMauritius = "fr_MU"
    case frenchMayotte = "fr_YT"
    case frenchMonaco = "fr_MC"
    case frenchMorocco = "fr_MA"
    case frenchNewCaledonia = "fr_NC"
    case frenchNiger = "fr_NE"
    case frenchRunion = "fr_RE"
    case frenchRwanda = "fr_RW"
    case frenchSenegal = "fr_SN"
    case frenchSeychelles = "fr_SC"
    case frenchStBarthlemy = "fr_BL"
    case frenchStMartin = "fr_MF"
    case frenchStPierreMiquelon = "fr_PM"
    case frenchSwitzerland = "fr_CH"
    case frenchSyria = "fr_SY"
    case frenchTogo = "fr_TG"
    case frenchTunisia = "fr_TN"
    case frenchVanuatu = "fr_VU"
    case frenchWallisFutuna = "fr_WF"
    case friulian = "fur"
    case friulianItaly = "fur_IT"
    case fulah = "ff"
    case fulahCameroon = "ff_CM"
    case fulahGuinea = "ff_GN"
    case fulahMauritania = "ff_MR"
    case fulahSenegal = "ff_SN"
    case galician = "gl"
    case galicianSpain = "gl_ES"
    case ganda = "lg"
    case gandaUganda = "lg_UG"
    case georgian = "ka"
    case georgianGeorgia = "ka_GE"
    case german = "de"
    case germanAustria = "de_AT"
    case germanBelgium = "de_BE"
    case germanGermany = "de_DE"
    case germanLiechtenstein = "de_LI"
    case germanLuxembourg = "de_LU"
    case germanSwitzerland = "de_CH"
    case greek = "el"
    case greekCyprus = "el_CY"
    case greekGreece = "el_GR"
    case gujarati = "gu"
    case gujaratiIndia = "gu_IN"
    case gusii = "guz"
    case gusiiKenya = "guz_KE"
    case hausa = "ha_Latn"
    case hausaGhana = "ha_Latn_GH"
    case hausaNiger = "ha_Latn_NE"
    case hausaNigeria = "ha_Latn_NG"
    case hawaiian = "haw"
    case hawaiianUnitedStates = "haw_US"
    case hebrew = "he"
    case hebrewIsrael = "he_IL"
    case hindi = "hi"
    case hindiIndia = "hi_IN"
    case hungarian = "hu"
    case hungarianHungary = "hu_HU"
    case icelandic = "is"
    case icelandicIceland = "is_IS"
    case igbo = "ig"
    case igboNigeria = "ig_NG"
    case inariSami = "smn"
    case inariSamiFinland = "smn_FI"
    case indonesian = "id"
    case indonesianIndonesia = "id_ID"
    case inuktitut = "iu"
    case inuktitutUnifiedCanadianAboriginalSyllabics = "iu_Cans"
    case inuktitutUnifiedCanadianAboriginalSyllabicsCanada = "iu_Cans_CA"
    case irish = "ga"
    case irishIreland = "ga_IE"
    case italian = "it"
    case italianItaly = "it_IT"
    case italianSanMarino = "it_SM"
    case italianSwitzerland = "it_CH"
    case japanese = "ja"
    case japaneseJapan = "ja_JP"
    case jolaFonyi = "dyo"
    case jolaFonyiSenegal = "dyo_SN"
    case kabuverdianu = "kea"
    case kabuverdianuCapeVerde = "kea_CV"
    case kabyle = "kab"
    case kabyleAlgeria = "kab_DZ"
    case kako = "kkj"
    case kakoCameroon = "kkj_CM"
    case kalaallisut = "kl"
    case kalaallisutGreenland = "kl_GL"
    case kalenjin = "kln"
    case kalenjinKenya = "kln_KE"
    case kamba = "kam"
    case kambaKenya = "kam_KE"
    case kannada = "kn"
    case kannadaIndia = "kn_IN"
    case kashmiri = "ks"
    case kashmiriArabic = "ks_Arab"
    case kashmiriArabicIndia = "ks_Arab_IN"
    case kazakh = "kk_Cyrl"
    case kazakhKazakhstan = "kk_Cyrl_KZ"
    case khmer = "km"
    case khmerCambodia = "km_KH"
    case kikuyu = "ki"
    case kikuyuKenya = "ki_KE"
    case kinyarwanda = "rw"
    case kinyarwandaRwanda = "rw_RW"
    case konkani = "kok"
    case konkaniIndia = "kok_IN"
    case korean = "ko"
    case koreanNorthKorea = "ko_KP"
    case koreanSouthKorea = "ko_KR"
    case koyraChiini = "khq"
    case koyraChiiniMali = "khq_ML"
    case koyraboroSenni = "ses"
    case koyraboroSenniMali = "ses_ML"
    case kwasio = "nmg"
    case kwasioCameroon = "nmg_CM"
    case kyrgyz = "ky_Cyrl"
    case kyrgyzKyrgyzstan = "ky_Cyrl_KG"
    case lakota = "lkt"
    case lakotaUnitedStates = "lkt_US"
    case langi = "lag"
    case langiTanzania = "lag_TZ"
    case lao = "lo"
    case laoLaos = "lo_LA"
    case latvian = "lv"
    case latvianLatvia = "lv_LV"
    case lingala = "ln"
    case lingalaAngola = "ln_AO"
    case lingalaCentralAfricanRepublic = "ln_CF"
    case lingalaCongoBrazzaville = "ln_CG"
    case lingalaCongoKinshasa = "ln_CD"
    case lithuanian = "lt"
    case lithuanianLithuania = "lt_LT"
    case lowerSorbian = "dsb"
    case lowerSorbianGermany = "dsb_DE"
    case lubaKatanga = "lu"
    case lubaKatangaCongoKinshasa = "lu_CD"
    case luo = "luo"
    case luoKenya = "luo_KE"
    case luxembourgish = "lb"
    case luxembourgishLuxembourg = "lb_LU"
    case luyia = "luy"
    case luyiaKenya = "luy_KE"
    case macedonian = "mk"
    case macedonianMacedonia = "mk_MK"
    case machame = "jmc"
    case machameTanzania = "jmc_TZ"
    case makhuwaMeetto = "mgh"
    case makhuwaMeettoMozambique = "mgh_MZ"
    case makonde = "kde"
    case makondeTanzania = "kde_TZ"
    case malagasy = "mg"
    case malagasyMadagascar = "mg_MG"
    case malay = "ms_Latn"
    case malayArabic = "ms_Arab"
    case malayArabicBrunei = "ms_Arab_BN"
    case malayArabicMalaysia = "ms_Arab_MY"
    case malayBrunei = "ms_Latn_BN"
    case malayMalaysia = "ms_Latn_MY"
    case malaySingapore = "ms_Latn_SG"
    case malayalam = "ml"
    case malayalamIndia = "ml_IN"
    case maltese = "mt"
    case malteseMalta = "mt_MT"
    case manx = "gv"
    case manxIsleOfMan = "gv_IM"
    case marathi = "mr"
    case marathiIndia = "mr_IN"
    case masai = "mas"
    case masaiKenya = "mas_KE"
    case masaiTanzania = "mas_TZ"
    case meru = "mer"
    case meruKenya = "mer_KE"
    case meta = "mgo"
    case metaCameroon = "mgo_CM"
    case mongolian = "mn_Cyrl"
    case mongolianMongolia = "mn_Cyrl_MN"
    case morisyen = "mfe"
    case morisyenMauritius = "mfe_MU"
    case mundang = "mua"
    case mundangCameroon = "mua_CM"
    case nama = "naq"
    case namaNamibia = "naq_NA"
    case nepali = "ne"
    case nepaliIndia = "ne_IN"
    case nepaliNepal = "ne_NP"
    case ngiemboon = "nnh"
    case ngiemboonCameroon = "nnh_CM"
    case ngomba = "jgo"
    case ngombaCameroon = "jgo_CM"
    case northNdebele = "nd"
    case northNdebeleZimbabwe = "nd_ZW"
    case northernSami = "se"
    case northernSamiFinland = "se_FI"
    case northernSamiNorway = "se_NO"
    case northernSamiSweden = "se_SE"
    case norwegianBokml = "nb"
    case norwegianBokmlNorway = "nb_NO"
    case norwegianBokmlSvalbardJanMayen = "nb_SJ"
    case norwegianNynorsk = "nn"
    case norwegianNynorskNorway = "nn_NO"
    case nuer = "nus"
    case nuerSudan = "nus_SD"
    case nyankole = "nyn"
    case nyankoleUganda = "nyn_UG"
    case oriya = "or"
    case oriyaIndia = "or_IN"
    case oromo = "om"
    case oromoEthiopia = "om_ET"
    case oromoKenya = "om_KE"
    case ossetic = "os"
    case osseticGeorgia = "os_GE"
    case osseticRussia = "os_RU"
    case pashto = "ps"
    case pashtoAfghanistan = "ps_AF"
    case persian = "fa"
    case persianAfghanistan = "fa_AF"
    case persianIran = "fa_IR"
    case polish = "pl"
    case polishPoland = "pl_PL"
    case portuguese = "pt"
    case portugueseAngola = "pt_AO"
    case portugueseBrazil = "pt_BR"
    case portugueseCapeVerde = "pt_CV"
    case portugueseGuineaBissau = "pt_GW"
    case portugueseMacauSarChina = "pt_MO"
    case portugueseMozambique = "pt_MZ"
    case portuguesePortugal = "pt_PT"
    case portugueseSoTomPrncipe = "pt_ST"
    case portugueseTimorLeste = "pt_TL"
    case punjabi = "pa_Guru"
    case punjabiArabic = "pa_Arab"
    case punjabiArabicPakistan = "pa_Arab_PK"
    case punjabiIndia = "pa_Guru_IN"
    case quechua = "qu"
    case quechuaBolivia = "qu_BO"
    case quechuaEcuador = "qu_EC"
    case quechuaPeru = "qu_PE"
    case romanian = "ro"
    case romanianMoldova = "ro_MD"
    case romanianRomania = "ro_RO"
    case romansh = "rm"
    case romanshSwitzerland = "rm_CH"
    case rombo = "rof"
    case romboTanzania = "rof_TZ"
    case rundi = "rn"
    case rundiBurundi = "rn_BI"
    case russian = "ru"
    case russianBelarus = "ru_BY"
    case russianKazakhstan = "ru_KZ"
    case russianKyrgyzstan = "ru_KG"
    case russianMoldova = "ru_MD"
    case russianRussia = "ru_RU"
    case russianUkraine = "ru_UA"
    case rwa = "rwk"
    case rwaTanzania = "rwk_TZ"
    case sakha = "sah"
    case sakhaRussia = "sah_RU"
    case samburu = "saq"
    case samburuKenya = "saq_KE"
    case sango = "sg"
    case sangoCentralAfricanRepublic = "sg_CF"
    case sangu = "sbp"
    case sanguTanzania = "sbp_TZ"
    case scottishGaelic = "gd"
    case scottishGaelicUnitedKingdom = "gd_GB"
    case sena = "seh"
    case senaMozambique = "seh_MZ"
    case serbian = "sr_Cyrl"
    case serbianBosniaHerzegovina = "sr_Cyrl_BA"
    case serbianKosovo = "sr_Cyrl_XK"
    case serbianLatin = "sr_Latn"
    case serbianLatinBosniaHerzegovina = "sr_Latn_BA"
    case serbianLatinKosovo = "sr_Latn_XK"
    case serbianLatinMontenegro = "sr_Latn_ME"
    case serbianLatinSerbia = "sr_Latn_RS"
    case serbianMontenegro = "sr_Cyrl_ME"
    case serbianSerbia = "sr_Cyrl_RS"
    case shambala = "ksb"
    case shambalaTanzania = "ksb_TZ"
    case shona = "sn"
    case shonaZimbabwe = "sn_ZW"
    case sichuanYi = "ii"
    case sichuanYiChina = "ii_CN"
    case sinhala = "si"
    case sinhalaSriLanka = "si_LK"
    case slovak = "sk"
    case slovakSlovakia = "sk_SK"
    case slovenian = "sl"
    case slovenianSlovenia = "sl_SI"
    case soga = "xog"
    case sogaUganda = "xog_UG"
    case somali = "so"
    case somaliDjibouti = "so_DJ"
    case somaliEthiopia = "so_ET"
    case somaliKenya = "so_KE"
    case somaliSomalia = "so_SO"
    case spanish = "es"
    case spanishArgentina = "es_AR"
    case spanishBolivia = "es_BO"
    case spanishCanaryIslands = "es_IC"
    case spanishCeutaMelilla = "es_EA"
    case spanishChile = "es_CL"
    case spanishColombia = "es_CO"
    case spanishCostaRica = "es_CR"
    case spanishCuba = "es_CU"
    case spanishDominicanRepublic = "es_DO"
    case spanishEcuador = "es_EC"
    case spanishElSalvador = "es_SV"
    case spanishEquatorialGuinea = "es_GQ"
    case spanishGuatemala = "es_GT"
    case spanishHonduras = "es_HN"
    case spanishLatinAmerica = "es_419"
    case spanishMexico = "es_MX"
    case spanishNicaragua = "es_NI"
    case spanishPanama = "es_PA"
    case spanishParaguay = "es_PY"
    case spanishPeru = "es_PE"
    case spanishPhilippines = "es_PH"
    case spanishPuertoRico = "es_PR"
    case spanishSpain = "es_ES"
    case spanishUnitedStates = "es_US"
    case spanishUruguay = "es_UY"
    case spanishVenezuela = "es_VE"
    case standardMoroccanTamazight = "zgh"
    case standardMoroccanTamazightMorocco = "zgh_MA"
    case swahili = "sw"
    case swahiliCongoKinshasa = "sw_CD"
    case swahiliKenya = "sw_KE"
    case swahiliTanzania = "sw_TZ"
    case swahiliUganda = "sw_UG"
    case swedish = "sv"
    case swedishlandIslands = "sv_AX"
    case swedishFinland = "sv_FI"
    case swedishSweden = "sv_SE"
    case swissGerman = "gsw"
    case swissGermanFrance = "gsw_FR"
    case swissGermanLiechtenstein = "gsw_LI"
    case swissGermanSwitzerland = "gsw_CH"
    case tachelhit = "shi_Latn"
    case tachelhitMorocco = "shi_Latn_MA"
    case tachelhitTifinagh = "shi_Tfng"
    case tachelhitTifinaghMorocco = "shi_Tfng_MA"
    case taita = "dav"
    case taitaKenya = "dav_KE"
    case tajik = "tg_Cyrl"
    case tajikTajikistan = "tg_Cyrl_TJ"
    case tamil = "ta"
    case tamilIndia = "ta_IN"
    case tamilMalaysia = "ta_MY"
    case tamilSingapore = "ta_SG"
    case tamilSriLanka = "ta_LK"
    case tasawaq = "twq"
    case tasawaqNiger = "twq_NE"
    case telugu = "te"
    case teluguIndia = "te_IN"
    case teso = "teo"
    case tesoKenya = "teo_KE"
    case tesoUganda = "teo_UG"
    case thai = "th"
    case thaiThailand = "th_TH"
    case tibetan = "bo"
    case tibetanChina = "bo_CN"
    case tibetanIndia = "bo_IN"
    case tigrinya = "ti"
    case tigrinyaEritrea = "ti_ER"
    case tigrinyaEthiopia = "ti_ET"
    case tongan = "to"
    case tonganTonga = "to_TO"
    case turkish = "tr"
    case turkishCyprus = "tr_CY"
    case turkishTurkey = "tr_TR"
    case turkmen = "tk_Latn"
    case turkmenTurkmenistan = "tk_Latn_TM"
    case ukrainian = "uk"
    case ukrainianUkraine = "uk_UA"
    case upperSorbian = "hsb"
    case upperSorbianGermany = "hsb_DE"
    case urdu = "ur"
    case urduIndia = "ur_IN"
    case urduPakistan = "ur_PK"
    case uyghur = "ug"
    case uyghurArabic = "ug_Arab"
    case uyghurArabicChina = "ug_Arab_CN"
    case uzbek = "uz_Cyrl"
    case uzbekArabic = "uz_Arab"
    case uzbekArabicAfghanistan = "uz_Arab_AF"
    case uzbekLatin = "uz_Latn"
    case uzbekLatinUzbekistan = "uz_Latn_UZ"
    case uzbekUzbekistan = "uz_Cyrl_UZ"
    case vai = "vai_Vaii"
    case vaiLatin = "vai_Latn"
    case vaiLatinLiberia = "vai_Latn_LR"
    case vaiLiberia = "vai_Vaii_LR"
    case vietnamese = "vi"
    case vietnameseVietnam = "vi_VN"
    case vunjo = "vun"
    case vunjoTanzania = "vun_TZ"
    case walser = "wae"
    case walserSwitzerland = "wae_CH"
    case welsh = "cy"
    case welshUnitedKingdom = "cy_GB"
    case westernFrisian = "fy"
    case westernFrisianNetherlands = "fy_NL"
    case yangben = "yav"
    case yangbenCameroon = "yav_CM"
    case yiddish = "yi"
    case yiddishWorld = "yi_001"
    case yoruba = "yo"
    case yorubaBenin = "yo_BJ"
    case yorubaNigeria = "yo_NG"
    case zarma = "dje"
    case zarmaNiger = "dje_NE"
    case zulu = "zu"
    case zuluSouthAfrica = "zu_ZA"
    
    public var locale: Locale {
        switch self {
        case .current:          return Locale.current
        case .autoUpdating:     return Locale.autoupdatingCurrent
        default:                return Locale(identifier: rawValue)
        }
    }
}
}
