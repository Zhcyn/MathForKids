import Foundation
import UIKit
class HowToPlayViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let topColor = UIColor(red: (255/255.0), green: (253/255.0), blue: (191/255.0), alpha: 1)
        let bottomColor = UIColor(red: (254/255.0), green: (253/255.0), blue: (120/255.0), alpha: 1)
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.navigationController?.setNavigationBarHidden(false, animated: true)
     }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
