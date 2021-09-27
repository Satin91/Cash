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
}
struct Metric: Codable {
    var value: Double
}

extension Metric: CustomStringConvertible {
    private static var valueFormatter: NumberFormatter = {
           let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 3
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
           formatter.numberStyle = .decimal
           
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
    
    
    func changeTextAttributeForFirstLiteralsISO(ISO: String, Balance: Double,additionalText: (String,UIColor)? ) {
        let currencySymbol = CurrencySymbol()
        guard self.text != nil else {return}
        let characterSet = NSCharacterSet(charactersIn: "1234567890, ")
        var counter: Int = 0
        
        
        let symbol = currencySymbol.getSymbolForCurrencyCode(code: ISO)
        
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
        if additionalText != nil {
            self.text! += additionalText!.0
        }
        let splittedFontSize = self.font.pointSize / 2
        let attrString = NSMutableAttributedString(string: self.text!)
        attrString.addAttribute(.font, value: UIFont.systemFont(ofSize: splittedFontSize,weight: .medium), range: NSRange(location: 0, length: counter))
        if additionalText != nil {
            attrString.addAttribute(.font, value: UIFont.systemFont(ofSize: self.font.pointSize / 1.5,weight: .regular) , range: NSRange(location: self.text!.count - additionalText!.0.count, length: additionalText!.0.count))
            attrString.addAttribute(.foregroundColor, value: additionalText?.1, range: NSRange(location: self.text!.count - additionalText!.0.count, length: additionalText!.0.count) )
        }
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
                self.changeTextAttributeForFirstLiteralsISO(ISO: iso, Balance: doubl.removeHundredthsFromEnd(), additionalText: nil)
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
        for i in CurrencyList().identifiers {
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






///SomeFunc
//ImageToData
func imageToData(imageName: String) -> Data{
    let imageName2 = imageName
    let image = UIImage(named: imageName2)
    print(imageName)
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
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2 //maximum digits in Double after dot (maximum precision)
        return Double(String(formatter.string(from: number) ?? "0")) ?? 0
    }
    func fromNumberToString() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 2
        return formatter.string(from: number) ?? " "
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

func setupNavigationController(_ controller: UINavigationController?) {
    guard let controller = controller else {
        print("Navigation is nill(setupNavigationController)")
        return}
    let colors = AppColors()
    colors.loadColors()
    controller.navigationBar.shadowImage = UIImage()
    controller.navigationBar.setBackgroundImage(UIImage(), for: .default)
    controller.navigationBar.tintColor = colors.contrastColor1
    
    //controller.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "SF-Pro-Text-Medium", size: 46)!]
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
    func animateView(animatedView: UIView, parentView: UIView) {
        let background = parentView
        background.addSubview(animatedView)
       // animatedView.center = parentView.center
        //scaling view to 120%
        animatedView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        animatedView.alpha = 0
        //start the animation
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear) {
            animatedView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            animatedView.alpha = 1
        }
    }
    
    func reservedAnimateView(animatedView: UIView, viewController: UIViewController?){
        //start the animation
        viewController!.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            animatedView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            animatedView.alpha = 0}completion: { _ in
                animatedView.transform = CGAffineTransform.identity
                viewController!.view.isUserInteractionEnabled = true
            }
    }
    
    func reservedAnimateView2(animatedView: UIView){
        //start the animation
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            animatedView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            animatedView.alpha = 0}completion: { _ in
                
                
                
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
    
    func drawDash(radius: CGFloat, color: UIColor) {
        //Нужно чтобы слой не повторялся
        self.layer.sublayers?.removeAll()
        let border = CAShapeLayer()
        border.removeFromSuperlayer()
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        //border.path = UIBezierPath(roundedRect:dashView.bounds, cornerRadius:10.0).cgPath
        border.frame = self.bounds
        border.fillColor = nil
        border.strokeColor = color.cgColor
        border.lineWidth = 3 // doubled since half will be clipped
        border.lineDashPattern = [15.0,4]
        self.layer.addSublayer(border)
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
    
    func setImageTintColor(_ color: UIColor, imageName: String) {
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        self.setImage(image, for: .normal)
        self.tintColor = color
    }
    
    func scaleButtonAnimation() {
        let duration: TimeInterval = 0.15
        UIView.animate(withDuration: duration, delay: 0, options: .allowUserInteraction) {
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        } completion: { _ in
            UIView.animate(withDuration: duration) {
                self.transform = CGAffineTransform.identity
            }
        }

   
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
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationName), object: nil, userInfo: ["index":indexPath])
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
    let storyboard = UIStoryboard(name: "QuickPay", bundle: nil)
    let QuiclPayVC = storyboard.instantiateViewController(withIdentifier: "QuickPayVC") as! QuickPayViewController
    
    QuiclPayVC.payObject = PayObject
    QuiclPayVC.modalPresentationStyle = .pageSheet
    let vc = UINavigationController(rootViewController: QuiclPayVC)
    classViewController?.present(vc, animated: true, completion: nil)
    
    
    
//
//    if classViewController == nil {
//        classViewController = QuiclPayVC
//        classViewController!.view.frame = CGRect(x: delegateController.view.frame.width / 2, y: delegateController.view.frame.height / 2, width: delegateController.view.bounds.width * 0.8, height: delegateController.view.bounds.height * 0.55)
//        classViewController!.view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
//        //delegateController.addChild(classViewController!) // Не знаю зачем это, надо удалить без него тоже работает
//        delegateController.view.animateViewWithBlur(animatedView: classViewController!.view, parentView: delegateController.view)
//        classViewController!.didMove(toParent: delegateController)
//    }
}
enum PopUpType {
    case menu
    case tableView
}
func goToPopUpTableView(delegateController: UIViewController,payObject: [Any], sourseView: UIView) {
    let popTableView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PopUpTableView") as! PopTableViewController
    // let selectDateVC = UIViewController(nibName: "SelectDateViewControllerXib", bundle: nil) as! SelectDateCalendarPopUpViewController
    popTableView.closeSelectDateDelegate = delegateController as? ClosePopUpTableViewProtocol
    popTableView.payObject = payObject
    let navVC = UINavigationController(rootViewController: popTableView)
    navVC.modalPresentationStyle = .popover
    let popVC = navVC.popoverPresentationController
    
    popVC?.delegate = delegateController as? UIPopoverPresentationControllerDelegate
    //let barButtonView = delegateController.navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView
    popVC?.sourceView = sourseView
    popVC?.sourceRect = sourseView.bounds
    popVC?.permittedArrowDirections = .down
    
    
    navVC.view.alpha = 0
    
    
    let navBarHeight = 44
    let height = payObject is [IndexPath] ? 2 *  Int(popTableView.cellHeight): payObject.count * Int(popTableView.cellHeight)
    popTableView.preferredContentSize = CGSize(width: 150, height: (height) - navBarHeight )
    delegateController.present(navVC, animated: true, completion: nil)
}

///MARK: Alert controller

extension UIViewController {

    func showSubscriptionViewController() {
        
        let open = OpenNextController(storyBoardID: "SubscriptionsManager", fromViewController: self, toViewControllerID: "SubscriptionsManager", toViewController: SubscriptionsManagerViewController())
        open.makeTheTransition()
    }
    
    func showMiniAlert(message: String, alertStyle: MiniAlertStyle) {
        
        var miniAlert: MiniAlertView!
        for i in self.view.subviews {
            if i.accessibilityIdentifier == "Alert-View" {
                
                print("Есть такой идентификатор")
                return
            }
        }
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
        let from: Double = (Double(form.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: "")))!
        return from
    }
    
    func changeVisualDesigh() {
        self.borderStyle = .none
        self.layer.cornerRadius = 16
        self.layer.cornerCurve = .continuous
        self.layer.borderWidth = 1
        self.backgroundColor = ThemeManager2.currentTheme().secondaryBackgroundColor
        self.layer.borderColor = ThemeManager2.currentTheme().borderColor.cgColor
        self.textColor = ThemeManager2.currentTheme().titleTextColor
        self.font = .systemFont(ofSize: 17, weight: .regular)
        self.textAlignment = .left
        let shadowLayer = CAShapeLayer()
        shadowLayer.setSmallShadow(color: ThemeManager2.currentTheme().shadowColor)
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        shadowLayer.fillColor = ThemeManager2.currentTheme().secondaryBackgroundColor.cgColor
        shadowLayer.cornerCurve = .continuous
        self.clipsToBounds = true
        self.layer.masksToBounds = false
      //  self.layer.setSmallShadow(color: ThemeManager.currentTheme().shadowColor)
        self.layer.insertSublayer(shadowLayer, at: 0)
        indent(size: 17)
    }
    
    func indent(size:CGFloat) {
            self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height))
            self.leftViewMode = .always
        }
 
}
extension UIViewController {
    
    func goToQuickPayVC(PayObject: Any) {
        let storyboard = UIStoryboard(name: "QuickPay", bundle: nil)
        let QuicklPayVC = storyboard.instantiateViewController(withIdentifier: "QuickPayVC") as! QuickPayViewController
        QuicklPayVC.payObject = PayObject
        let vc = UINavigationController(rootViewController: QuicklPayVC)
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)
    }
}
