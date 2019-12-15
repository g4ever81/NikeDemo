import UIKit

open class FUProgressView {
    
    var activityIndicator = UIView()
    
    open class var shared: FUProgressView {
        struct Static {
            static let instance: FUProgressView = FUProgressView()
        }
        return Static.instance
    }
    
    
    func showProgressView(_ view : UIView) {
        let spinnerView = UIView.init(frame: view.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            view.addSubview(spinnerView)
        }
        
        activityIndicator = spinnerView
    }
    
    func hideProgressView() {
        DispatchQueue.main.async {
            self.activityIndicator.removeFromSuperview()
        }
    }
}

