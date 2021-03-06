//
//  AnyOptions.swift
//  CashApp
//
//  Created by Артур on 9/11/20.
//  Copyright © 2020 Артур. All rights reserved.
//
import Foundation
import UIKit
import RealmSwift




///View the numeric
extension Locale {
    static let englishUS: Locale = .init(identifier: "en_US")
    static let frenchFR: Locale = .init(identifier: "fr_FR")
    static let portugueseBR: Locale = .init(identifier: "pt_BR")
    static let belarusBY: Locale = .init(identifier: "be_BY")
    
    
    // ... and so on
}
struct Metric: Codable {
    var value: Double
}

extension Metric: CustomStringConvertible {
    private static var valueFormatter: NumberFormatter = {
           let formatter = NumberFormatter()
           formatter.numberStyle = .decimal
           formatter.maximumFractionDigits = 3
           formatter.groupingSeparator = " "
           formatter.decimalSeparator = ","
           return formatter
       }()

    
    var currencyFormattedValue: String {
        
        return "asd"
    }
    
       var formattedValue: String {
           let number = NSNumber(value: value)
           return Self.valueFormatter.string(from: number)!
       }

       var description: String {
           "\(formattedValue)"
       }
}

extension Formatter {
    static let number = NumberFormatter()
    static let num: NumberFormatter = {
        
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        //formatter.numberStyle = .decimal
        
        
        return formatter
    }()
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        
        return formatter
    }()
    
    static let withoutSpaces: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ""
        formatter.maximumFractionDigits = 3
        formatter.decimalSeparator = "."
        return formatter
    }()
    
}
//extension Numeric {
//    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
//}
extension String {

    var formattedWithoutSpaces: String { Formatter.withoutSpaces.string(for: self) ?? "" }
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
    var withoutSpaces: String {
        let str = self.replacingOccurrences(of: " ", with: "")
        return str
    }
    
    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
extension UILabel {
    
    
    func changeTextAttributeForFirstLiteralsISO(ISO: String, Balance: Double) {
        guard self.text != nil else {return}
        let characterSet = NSCharacterSet(charactersIn: "1234567890, ")
        var counter: Int = 0
        
        let currencyModelController = CurrencyModelController()
        let symbol = currencyModelController.getSymbolForCurrencyCode(code: ISO)
        
        let text = symbol + " " + Metric.init(value: Balance).formattedValue
        self.text = text
        for i in self.text! {
            let str = String(i)
          //  print(counter)
            if str.rangeOfCharacter(from: characterSet as CharacterSet) == nil {
                counter += 1
            }else {
                break
            }
        }
        let splittedFontSize = self.font.pointSize / 2
        let attrString = NSMutableAttributedString(string: self.text!)
        attrString.addAttribute(.font, value: UIFont.systemFont(ofSize: splittedFontSize,weight: .medium), range: NSRange(location: 0, length: counter))
        self.attributedText = attrString
    }
    func countPersentAnimation(upto: Double) {
        let from: Double = text?.replacingOccurrences(of: ",", with: ".").components(separatedBy: CharacterSet.init(charactersIn: "-0123456789.").inverted).first.flatMap { Double($0) } ?? 0.0
        let steps: Int = 20
        let duration = 0.25
        let rate = duration / Double(steps)
        let diff = upto - from
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + rate * Double(i)) {
                let doubl = (from + diff * (Double(i) / Double(steps)))
                self.text = String(Int(doubl)) + "%"
            }
        }
    }
    
    func countISOAnimation(upto: Double, iso: String) {
        let characterSet = CharacterSet(charactersIn: "-0123456789.,")
        let form = self.text?.trimmingCharacters(in: characterSet.inverted)
        guard let form = form else {return}
        let from: Double = Double(form.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: ""))!
        let steps: Int = 15
        let duration = 0.25
        let rate = duration / Double(steps)
        let diff = upto - from
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + rate * Double(i)) {
                let doubl = (from + diff * (Double(i) / Double(steps)))
                self.changeTextAttributeForFirstLiteralsISO(ISO: iso, Balance: doubl)
            }
        }
    }
}
extension Numeric {

    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
    var formattedWithoutSpaces: String { Formatter.withoutSpaces.string(for: self) ?? "" }
    
    
    
    func currencyFormatter( ISO: String?) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        // formatter.locale = NSLocale.currentLocale() // This is the default
        // In Swift 4, this ^ was renamed to simply NSLocale.current
        var id = String()
        //let decimalsISO = ["SEK","NOK","CZK","JPY","HUF","IDR","ISK"]
        for i in curIdentifiers {
            if i.key == ISO {
                id = i.value.rawValue
            }
        }
        formatter.usesGroupingSeparator = true
        formatter.locale = Locale(identifier: id)
        return formatter.string(for: self) ?? "ISO value is empty"
    }
    
    
    func formatted(with groupingSeparator: String? = nil, style: NumberFormatter.Style, locale: Locale = .current) -> String {
        Formatter.number.locale = locale
        Formatter.number.numberStyle = style
        if let groupingSeparator = groupingSeparator {
            Formatter.number.groupingSeparator = groupingSeparator
        }
        return Formatter.number.string(for: self) ?? ""
    }
    
    // Localized
    var currency:   String { formatted(style: .currency) }
   // var format: String {}
//    var currencyBY: String { formatted(style: .currency, locale: .belarusBY) }
//    var currencyUS: String { formatted(style: .currency, locale: .englishUS) }
//    var currencyFR: String { formatted(style: .currency, locale: .frenchFR) }
//    var currencyBR: String { formatted(style: .currency, locale: .portugueseBR) }
    // ... and so on
    //  var calculator: String { formatted(groupingSeparator: " ", style: .decimal) }
    ///func for tableviews change animations
}

extension CALayer {
    
    public func setMiddleShadow(color: UIColor) {
           shadowColor = color.cgColor
           shadowOffset = CGSize(width: 4, height: 4)
           shadowRadius = 30
           shadowOpacity = 0.3
           //shouldRasterize = true
           //rasterizationScale = UIScreen.main.scale
       }
    public func setSmallShadow(color: UIColor) {
        shadowColor = color.cgColor
        shadowOffset = CGSize(width: 2, height: 2)
        shadowRadius = 14
        shadowOpacity = 0.17
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
    }
    public func setCircleShadow(color: UIColor) {
        shadowColor = color.cgColor
        shadowOffset = CGSize(width: 0, height: 0)
        shadowRadius = 5
        shadowOpacity = 0.4
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
    }
}




///SomeFunc
//ImageToData
func imageToData(imageName: String) -> Data{
    let imageName2 = imageName
    let image = UIImage(named: imageName2)
    
    let imageData = image?.pngData()
    return imageData!
}
//MARK: Enumerateds & append Realm objects
func EnumeratedAccounts (array: [Results<MonetaryAccount>]) -> [MonetaryAccount] {
    var account: [MonetaryAccount] = []
    for (_, element) in array.enumerated(){
        for (_, element2) in element.enumerated() {
            account.append(element2)
        }
    }
    return account
}
//func EnumeratedPayPerTime(array: [])
func EnumeratedSequence(array: [Results<MonetaryCategory>]) -> [MonetaryCategory]  {
    
    var entity: [MonetaryCategory] = []
    for (_, element) in array.enumerated() {
        for (_, element2) in element.enumerated() {
            entity.append(element2)
        }
    }
    return entity
}
func EnumeratedSchedulers(object: [Results<MonetaryScheduler>]) -> [MonetaryScheduler]{
    var monetaryArray: [MonetaryScheduler] = []
    for (_, index) in object.enumerated() {
        monetaryArray.append(contentsOf: index)
    }
    return monetaryArray
}
func enumeratedALL<T: Comparable>(object:Results<T>) -> [T] {
    var array = [T]()
    for i in object {
        array.append(i)
    }
    return array
}

//MARK: Extension Double
extension Double {
    func removeHundredthsFromEnd() -> Double {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2 //maximum digits in Double after dot (maximum precision)
        return Double(String(formatter.string(from: number) ?? "0")) ?? 0
    }
}




//MARK: TableView reload delegate
protocol ReloadParentTableView{
    func reloadData()
}


///MARK: Gradient view

class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    @IBInspectable private var startColor: UIColor? {didSet{setupGradientColors()}}
    @IBInspectable private var endColor: UIColor? {didSet{setupGradientColors()}}
    
    @IBInspectable private var cornerRadius: CGFloat = 0 {
        didSet{
            setupCornerRadius()
        }
    }
    @IBInspectable private var startPoint: CGPoint = CGPoint(x: 1, y: 0) {
        didSet{
            setupCornerRadius()
        }
    }
    @IBInspectable private var endPoint: CGPoint = CGPoint(x: 0, y: 1) {
        didSet{
            setupGradient(startPioint: startPoint, endPoint: endPoint)
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient(startPioint: startPoint, endPoint: endPoint)
    }
    
    
    private func setupCornerRadius() {
        gradientLayer.cornerRadius = cornerRadius
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.autoresizingMask = [.flexibleWidth, . flexibleHeight]
        gradientLayer.frame = bounds
    }
    
    // Для применения градиента нужно указать клас вьюхи в Сториборде
    
    private func setupGradient(startPioint: CGPoint, endPoint: CGPoint) {
        self.layer.insertSublayer(gradientLayer, at: 0)
        setupGradientColors()
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        
        
        setupCornerRadius()
        
    }
    
    private func setupGradientColors() {
        guard let startColor = startColor else {return}
        guard let endColor = endColor else {return}
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        self.backgroundColor = .none
    }
    
    
}

//MARK: NavigationBarSettings

func setupNavigationController(Navigation Controller: UINavigationController) {
    Controller.navigationBar.shadowImage = UIImage()
    Controller.navigationBar.setBackgroundImage(UIImage(), for: .default)
    Controller.navigationBar.tintColor = whiteThemeRed
    Controller.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 26)!]
}
///MARK: dismissVC
protocol dismissVC {
    func dismissVC(goingTo: String,typeIdentifier: String)
}
///MARK: ScrollToAccount

///MARK: DropDownProtocol
protocol DropDownProtocol {
    func dropDownAccountNameAndIndexPath(string: String, indexPath: Int)
    func dropDownAccountIdentifier(identifier: String)
}

///MARK: PopUpProtocol
protocol QuickPayCloseProtocol {
    func closePopUpMenu()
}

extension UIImageView{
    func changePngColorTo(color: UIColor){
        guard let image =  self.image else {return}
        self.image = image.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}


//MARK: Extension UIView (Animate)
extension UIView {
    ///
    func animateViewWithBlur (animatedView: UIView, parentView: UIView) {
        let background = parentView
        background.addSubview(animatedView)
        animatedView.center = parentView.center
        //scaling view to 120%
        animatedView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        animatedView.alpha = 0
        //start the animation
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut) {
            animatedView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            animatedView.alpha = 1
        
            
        }
    }
    
    func reservedAnimateView(animatedView: UIView, viewController: UIViewController?){
        //start the animation
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            animatedView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            animatedView.alpha = 0}completion: { _ in
                if viewController != nil {
                    viewController!.willMove(toParent: nil)
                    viewController!.removeFromParent()
                }

                animatedView.removeFromSuperview()
            }
    }
    
    func reservedAnimateView2(animatedView: UIView){
        //start the animation
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            animatedView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            animatedView.alpha = 0}completion: { _ in
                
                animatedView.removeFromSuperview()
                
            }
    }
    func selectivelyRoundedRadius(usingCorners: UIRectCorner, radius: CGSize, view: UIView) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: usingCorners, cornerRadii: radius)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
    }
}

//MARK:     Extension for UIView
extension UIView {
    func setGradient(view: UIView, startColor: UIColor, endColor: UIColor, startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer: CAGradientLayer = {
            let gradientView = CAGradientLayer()
            let startColor = startColor
            let endColor = endColor
            let startPoint = startPoint
            let endPoint = endPoint
            
            gradientView.colors = [startColor.cgColor,endColor.cgColor]
            gradientView.backgroundColor = .none
            gradientView.startPoint = startPoint
            gradientView.endPoint = endPoint
            
            return gradientView
        }()
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        
    }
}


//MARK:     Extension for hide keyboard

extension UIViewController {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) // скрывает клавиатуру по тапу на View
    }
}


//MARK:     Color for UIImage

//image changeColor

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
//MARK:    Shadows

extension UIView{
    
    func setLayerShadow(view: UIView, layer: CALayer) {
        
        layer.shadowOffset = CGSize(width: -2, height: -2)
        layer.shadowColor = whiteThemeMainText.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 6
        view.layer.insertSublayer(layer, at: 0)
    }
    
    func setShadow (view: UIView, size: CGSize, opacity: Float, radius: CGFloat, color: CGColor){
        view.layer.shadowOffset = size
        view.layer.shadowColor = color
        view.layer.shadowOpacity = opacity
        view.layer.shadowRadius = radius
    }
}

extension UIImageView {
    
    func setImageShadow(image: UIImageView) {
        image.layer.shadowColor = whiteThemeMainText.cgColor
        image.layer.shadowRadius = 2.0
        image.layer.shadowOpacity = 0.6
        image.layer.shadowOffset = CGSize(width: 1, height: 1)
        image.layer.masksToBounds = false
        
    }
}
//MARK: Button settings
extension UIButton{
    
    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .disabled)
        self.tintColor = color
    }
    
}
//MARK: Uniq
//sorted uniq array of dates
 func uniq<S: Sequence, T: Hashable> (source: S) -> [T] where S.Iterator.Element == T {
    var buffer = [T]() // возвращаемый массив
    var added = Set<T>() // набор - уникальные значения
    var repeating = [T]()
    for elem in source {
        if !added.contains(elem) {
            buffer.append(elem)
            added.insert(elem)
        }else{
            repeating.append(elem)
        }
    }
    return repeating
}

//MARK: Date ext
extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    var removeOter: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month,.day], from: self)
        
        return calendar.date(from: components)!
    }
    
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    var nextMonth: Date {
        var components = DateComponents()
        components.month = 1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    
    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
    
    
    
}

///MARK : Notification

func reportIndex(notificationName: String, collectionView: UICollectionView) {
    var visibleRect = CGRect() // создали квадрат
    
    visibleRect.origin = collectionView.contentOffset // инициализировали квадрат
    visibleRect.size = collectionView.bounds.size // задали ему размеры как у колекции
    
    let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY) // установили точку в центре квадрата
    guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return } //проверка на присутствие ячейки в этой точке
    var notification = NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationName), object: nil, userInfo: ["index":indexPath])
}

//MARK: Init constraints

func initConstraints(view: UIView, to: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    //применили констрейнты для собственной вьюшки
    view.leftAnchor.constraint(equalTo: to.leftAnchor).isActive = true
    view.rightAnchor.constraint(equalTo: to.rightAnchor).isActive = true
    view.topAnchor.constraint(equalTo: to.topAnchor).isActive = true
    view.bottomAnchor.constraint(equalTo: to.bottomAnchor).isActive = true
    view.centerYAnchor.constraint(equalTo: to.centerYAnchor).isActive = true
}
///MARK: Present Pop ip view controller
func goToPickTypeVC(delegateController: UIViewController,buttonsNames: [String],goingTo: String) {
    let pickTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickTypeVC") as! PickTypePopUpTableViewController
    pickTypeVC.cellNames = buttonsNames
    pickTypeVC.goingTo = goingTo
    pickTypeVC.delegate = delegateController as? dismissVC
    
    let navVC = UINavigationController(rootViewController: pickTypeVC)
    navVC.modalPresentationStyle = .popover
    let popVC = navVC.popoverPresentationController
    popVC?.delegate = delegateController as? UIPopoverPresentationControllerDelegate
    let barButtonView = delegateController.navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView
    popVC?.sourceView = barButtonView
    popVC?.sourceRect = barButtonView!.bounds
    pickTypeVC.preferredContentSize = CGSize(width: 200, height: pickTypeVC.cellNames.count * 60)
    delegateController.present(navVC, animated: true, completion: nil)
}
///MARK: Go to some VC
func goToQuickPayVC(delegateController: UIViewController, classViewController: inout UIViewController?, PayObject: Any) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let QuiclPayVC = storyboard.instantiateViewController(withIdentifier: "QuickPayVC") as! QuickPayViewController
    
    QuiclPayVC.payObject = PayObject
    QuiclPayVC.closePopUpMenuDelegate = delegateController as! QuickPayCloseProtocol //Почему то работает делегат только если кастить до popupviiewController'a
    // Проверка для того чтобы каждый раз не добавлять viewController при его открытии
 
    if classViewController == nil {
        classViewController = QuiclPayVC
        classViewController!.view.frame = CGRect(x: delegateController.view.frame.width / 2, y: delegateController.view.frame.height / 2, width: delegateController.view.bounds.width * 0.8, height: delegateController.view.bounds.height * 0.55)
        classViewController!.view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        //delegateController.addChild(classViewController!) // Не знаю зачем это, надо удалить без него тоже работает
        delegateController.view.animateViewWithBlur(animatedView: classViewController!.view, parentView: delegateController.view)
        classViewController!.didMove(toParent: delegateController)
    }
}

func goToSelectDateVC(delegateController: UIViewController,payObject: [Any], sourseView: UIView) {
    let selectDateVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "selectDateVC") as! SelectDateCalendarPopUpTableViewController
    // let selectDateVC = UIViewController(nibName: "SelectDateViewControllerXib", bundle: nil) as! SelectDateCalendarPopUpViewController
    selectDateVC.closeSelectDateDelegate = delegateController as? CloseSelectDateProtocol
    selectDateVC.payObject = payObject
    let navVC = UINavigationController(rootViewController: selectDateVC)
    navVC.modalPresentationStyle = .popover
    let popVC = navVC.popoverPresentationController
    popVC?.delegate = delegateController as? UIPopoverPresentationControllerDelegate
    //let barButtonView = delegateController.navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView
    popVC?.sourceView = sourseView
    popVC?.sourceRect = sourseView.bounds
    selectDateVC.preferredContentSize = CGSize(width: 200, height: selectDateVC.payObject.count * 120)
    delegateController.present(navVC, animated: true, completion: nil)
}

///MARK: Alert controller

extension UIViewController {
    func showAlert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
   
    func showMiniAlert(message: String, alertStyle: MiniAlertStyle) {
        var miniAlert: MiniAlertView!
        miniAlert = MiniAlertView.loadFromNib()
        miniAlert.frame = CGRect(x: self.view.bounds.width, y: 97, width: self.view.bounds.width - (Layout.side * 2), height: 98)
        self.view.addSubview(miniAlert)
        miniAlert.messageLabel.text = message
        UIView.animate(withDuration: 0.45, delay: 0,usingSpringWithDamping: 0.7,initialSpringVelocity: 0.9,options: .curveEaseInOut) {
            miniAlert.frame.origin.x = Layout.side
        }completion: { (true) in
            UIView.animate(withDuration: 0.25,delay: 2.0) {
                    miniAlert.frame.origin.x = self.view.bounds.width
                }completion: { _ in
                    miniAlert.removeFromSuperview()
            }
        
        }
        
    }
    func closeAlert(alertView: AlertViewController) {
        
      //  self.view.reservedAnimateView(animatedView: alertView.view, viewController: self)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            alertView.view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            alertView.view.alpha = 0}completion: { _ in
                
                alertView.dismiss(animated: false) {
                    alertView.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }
    }
    
    func addAlert( alertView: AlertViewController, title: String, message: String, alertStyle: AlertStyle) {
        alertView.modalPresentationStyle = .overFullScreen
        alertView.view.alpha = 0
        alertView.titleLabel.text = title
        alertView.messageLabel.text = message
        alertView.setAlertStyle(alertStyle: alertStyle)
        self.present(alertView, animated: false) {
            alertView.view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut )  {
                alertView.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                alertView.view.alpha = 1
            }completion: { (true) in
                
            }
        }
        
    }
    
    func showAlertController(title: String, message: String, alertStyle: AlertStyle, blurView: UIView) -> AlertViewController? {
        print(title,message)
        let alertView = AlertViewController()
        
        //guard !self.children.contains(AlertViewController()) else {return nil}
        
        if self.children.contains(AlertViewController()) {
            print("Есть такое")
        }
        self.addChild(alertView)
        alertView.didMove(toParent: self)
        
      //  alertView.titleLabel.text = title
        //alertView.messageLabel.text = message
        alertView.alertStyle = alertStyle
        alertView.view.frame = CGRect(x:Layout.side + (Layout.side / 2), y: 0, width: view.frame.width - (Layout.side + (Layout.side / 2)) * 2 , height: self.view.bounds.height * 0.55)
        alertView.view.center = self.view.center
        blurView.frame = self.view.frame
        
        self.view.animateViewWithBlur(animatedView: blurView, parentView: self.view)
        self.view.animateViewWithBlur(animatedView: alertView.view, parentView: self.view)
        
        return alertView
        //self.present(xib, animated: true, completion: nil)
    }
    
    var topBarHeight: CGFloat {
        var top = self.navigationController?.navigationBar.frame.height ?? 0.0
        if #available(iOS 13.0, *) {
            top += UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            top += UIApplication.shared.statusBarFrame.height
        }
        return top
    }
    

}

//MARK: Extension textField
extension UITextField {
    func removeAllExceptNumbers()->Double {
        guard self.text != nil else {return 0}
        let characterSet = CharacterSet(charactersIn: "-0123456789., ")
        let form = self.text?.trimmingCharacters(in: characterSet.inverted)
        guard let form = form else {return 0}
        print(self.text, form)
        
        let from: Double = (Double(form.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: "")))!
        return from
    }
    
    func changeVisualDesigh() {
       
        self.borderStyle = .none
        
        self.layer.cornerRadius = 16
        self.layer.cornerCurve = .continuous
        self.layer.borderWidth = 1
        self.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
        self.layer.borderColor = ThemeManager.currentTheme().borderColor.cgColor
        self.textColor = ThemeManager.currentTheme().titleTextColor
        self.font = .systemFont(ofSize: 17, weight: .regular)
        let shadowLayer = CAShapeLayer()
        shadowLayer.setSmallShadow(color: ThemeManager.currentTheme().shadowColor)
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        shadowLayer.fillColor = ThemeManager.currentTheme().secondaryBackgroundColor.cgColor
        shadowLayer.cornerCurve = .continuous
//        shadowLayer.shadowColor = UIColor.darkGray.cgColor
//        shadowLayer.shadowPath = shadowLayer.path
//        shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        shadowLayer.shadowOpacity = 0.8
//        shadowLayer.shadowRadius = 2
        
        
        self.clipsToBounds = true
        self.layer.masksToBounds = false
      //  self.layer.setSmallShadow(color: ThemeManager.currentTheme().shadowColor)
        self.layer.insertSublayer(shadowLayer, at: 0)
        
    }
 
}
