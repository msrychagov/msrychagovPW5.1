import UIKit

extension UIView {
    private static let shimmerLayerName = "shimmerLayerName"
    
    /// Запускаем шимер-анимацию поверх текущего UIView
    func startShimmering() {
        // Если уже есть, ничего не делаем
        if layer.sublayers?.contains(where: { $0.name == Self.shimmerLayerName }) == true {
            return
        }
        
        // Создаём слой с градиентом
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = Self.shimmerLayerName
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        // Цвета для «светлого бегущего» эффекта
        let backgroundColor = UIColor.systemGray4.cgColor
        let lightColor = UIColor.systemGray3.withAlphaComponent(0.6).cgColor
        
        gradientLayer.colors = [backgroundColor, lightColor, backgroundColor]
        gradientLayer.locations = [0, 0.5, 1]
        
        // Анимация
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1, -0.5, 0]
        animation.toValue = [1, 1.5, 2]
        animation.duration = 1.0
        animation.repeatCount = .infinity
        
        gradientLayer.add(animation, forKey: "shimmerAnimation")
        
        layer.addSublayer(gradientLayer)
    }
    
    /// Останавливаем шимер-анимацию и убираем градиент
    func stopShimmering() {
        layer.sublayers?
            .filter { $0.name == Self.shimmerLayerName }
            .forEach { $0.removeFromSuperlayer() }
    }
}
