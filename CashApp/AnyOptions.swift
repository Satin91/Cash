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
extension Formatter {
    static let number = NumberFormatter()
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        
        formatter.groupingSeparator = " "
        return formatter
    }()
}
//extension Numeric {
//    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
//}

extension Numeric {
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
    // Fixed locales
    
    var currencyBY: String { formatted(style: .currency, locale: .belarusBY) }
    var currencyUS: String { formatted(style: .currency, locale: .englishUS) }
    var currencyFR: String { formatted(style: .currency, locale: .frenchFR) }
    var currencyBR: String { formatted(style: .currency, locale: .portugueseBR) }
    // ... and so on
    //  var calculator: String { formatted(groupingSeparator: " ", style: .decimal) }
    ///func for tableviews change animations
    
    
    
}



extension UILabel {
    
    
    func setLabelMiddleShadow(label: UILabel){
        label.layer.shadowColor = whiteThemeShadowText.cgColor
        label.layer.shadowRadius = 3
        label.layer.shadowOpacity = 0.6
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false
    }
    
    func setLabelSmallShadow(label: UILabel){
        label.layer.shadowColor = whiteThemeShadowText.cgColor
        label.layer.shadowRadius = 1
        label.layer.shadowOpacity = 0.3
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.masksToBounds = false
    }
    var smallShadow: UILabel {
        let label = UILabel()
        label.layer.shadowColor = whiteThemeShadowText.cgColor
        label.layer.shadowRadius = 1
        label.layer.shadowOpacity = 0.3
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.masksToBounds = false
        return label
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

func EnumeratedSequence (array: [Results<MonetaryEntity>]) -> [MonetaryEntity]  {
    
    var entity: [MonetaryEntity] = []
    for (_, element) in array.enumerated() {
        for (_, element2) in element.enumerated() {
            entity.append(element2)
        }
    }
    return entity
}
func appendAccounts(object: [Results<MonetaryAccount>]) -> [MonetaryAccount]{
    var monetaryArray: [MonetaryAccount] = []
    for (_, index) in object.enumerated() {
        monetaryArray.append(contentsOf: index)
    }
     return monetaryArray
    }


//MARK: anyOptions







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
    func dismissVC(goingTo: String,restorationIdentifier: String)
}


///MARK: DropDownProtocol
protocol DropDownProtocol {
    func dropDownAccountNameAndIndexPath(string: String, indexPath: Int)
    func dropDownAccountIdentifier(identifier: String)
}

///MARK: PopUpProtocol
protocol PopUpProtocol {
    func closePopUpMenu(enteredSum: Double, indexPath: Int?)
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
    func animateView (animatedView: UIView, parentView: UIView) {
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

extension UIButton{
    
    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .disabled)
        self.tintColor = color
    }
    
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
