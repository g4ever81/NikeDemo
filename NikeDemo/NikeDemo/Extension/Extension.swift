import UIKit

class FUAlertViewController: UIAlertController {
    
    fileprivate lazy var alertWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = FUAlertBackgroundViewController()
        window.backgroundColor = UIColor.clear
        return window
    }()
    
    func show(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        let alertVisisble = isalertViewVisible()
        
        if !alertVisisble {
            if let rootViewController = alertWindow.rootViewController {
                alertWindow.makeKeyAndVisible()
                rootViewController.present(self, animated: flag, completion: completion)
            }
        }
    }
    
    // Fix for bug in iOS 9 Beta 5 that prevents the original window from becoming keyWindow again
    deinit {
        alertWindow.isHidden = true
    }
    
    func anyAlertWindowIsActive() -> Bool {
        var isKeyActive = false
        for (_,element) in UIApplication.shared.windows.enumerated() {
            if element.rootViewController is FUAlertBackgroundViewController {
                if element.isKeyWindow == true {
                    isKeyActive = true
                }
            }
        }
        return isKeyActive
    }
    
    func isalertViewVisible() -> Bool {
        if anyAlertWindowIsActive() == true {
            for (_,element) in UIApplication.shared.windows.enumerated() {
                if element.rootViewController is FUAlertBackgroundViewController {
                    return true
                }
            }
        }
        else {
            return false
        }
        
        return false
    }
}

// In the case of view controller-based status bar style, make sure we use the same style for our view controller
private class FUAlertBackgroundViewController: UIViewController {
    
    fileprivate override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIApplication.shared.statusBarStyle
    }
    
    fileprivate override var prefersStatusBarHidden : Bool {
        return UIApplication.shared.isStatusBarHidden
    }
    
}

extension UIViewController {
    func showAlertWithTitle(_ title:String,message:String,buttonTitle:String) {
        let alert = FUAlertViewController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: buttonTitle, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.show()
    }
    
    func showAlertWithAction(_ title: String, message : String, completion: @escaping(_ success: Bool) -> Void)
    {
        FUProgressView.shared.hideProgressView()
        let alert = FUAlertViewController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            completion(true)
        })
        alert.addAction(action)
        alert.show()
    }
    
    
    func showAlertWithCancelAction(title:String ,titlePos: String, titleNeg: String, message : String, completion: @escaping(_ success: Bool) -> Void)
    {
        FUProgressView.shared.hideProgressView()
        
        let alert = FUAlertViewController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: titlePos, style: .default, handler: { (action) -> Void in
            completion(true)
        })
        let cancelAction = UIAlertAction(title: titleNeg, style: .default, handler: { (action) -> Void in
            completion(false)
        })
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.show()
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
