import UIKit
import Foundation

class NetworkBaseService: NSObject, URLSessionDelegate {
    //    MARK: Properties
    
    /// BaseURL variable
    var baseUrl: String!
    
    /// Default header variable
    var defaultHeaders: [String: String] = [:]
    var serviceIdentifier: String!
    
    /// Current task variable
    var currentTask:URLSessionDataTask!
    
    /// Network Check variable
    //    let network: NetworkManager = NetworkManager.sharedInstance
    
    /**
     Convenience Init Method for initialization of variables such as baseUrl, defaultHeaders
     */
    override init() {
        baseUrl = ServiceIdentifiers.BASE_SERVICE_URL
        super.init()
    }
    
    /**
     This is to cancel the current service request
     */
    func cancelAllCurrentRequests() {
        if self.currentTask != nil {
            self.currentTask.cancel()
        }
    }
    
    func getStatusOfService() -> URLSessionTask.State {
        return self.currentTask.state
    }
    
    func makeServiceRequestWithUrl(url: String,
                                   requestType: String?,
                                   parameters: [String: String]?,
                                   headers: [String: String]?,
                                   body: [String: String],
                                   success: @escaping (_ response: String) -> Void,
                                   failure: @escaping (_ error: NSError) -> Void) -> Void {
        let request : NSMutableURLRequest = createRequest(url, parameters: parameters, body: body as [String : String]?, headers: [:],requestType:requestType!)
        
        let configuration = URLSessionConfiguration.default
        
        configuration.timeoutIntervalForRequest = 300 // Timeout for Service
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        
        let session:Foundation.URLSession
        session = Foundation.URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        if Reachability.isConnectedToNetwork(){
            currentTask = session.dataTask(with: request as URLRequest, completionHandler: {
                data, response, error -> Void in
                if error != nil {
                    var messageTxt = ""
                    var titleTxt = ""
                    // Reachable
                    messageTxt = NSLocalizedString("NetworkConnectionProblemMessage", comment: "")
                    titleTxt = ""
                    failure(NSError(domain:titleTxt ,code:(error! as NSError).code,userInfo:["message":messageTxt]))
                }else {
                    if let responseJsonString = String(data: data!, encoding: .utf8) {
                        success(responseJsonString)
                    }else{
                        success("")
                    }
                    URLCache.shared.removeAllCachedResponses()
                    return
                }
            })
            self.currentTask.resume()
        }else{
            FUProgressView.shared.hideProgressView()
            let alertController = FUAlertViewController(title: "", message: "No Internet Connection.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alertController.addAction(ok)
            alertController.show()
        }
        
    }
    
    /**
     This method makes the service request
     
     - Parameters:
     - url: Request url
     - parameters: Required parameters
     - headers: Headers array
     - body: Body in the form of an array
     - requestType: Type of request POST/GET
     
     - returns:
     - NSMutableURLRequest parameter
     
     */
    func createRequest(_ url: String,
                       parameters: [String: String]?,
                       body: [String: String]?,
                       headers: [String: String]?,
                       requestType:String) -> NSMutableURLRequest {
        
        let request: NSMutableURLRequest = NSMutableURLRequest()
        // Add final request url
        request.url = URL(string: url)
        request.httpMethod = requestType
        // Check for Request Type
        if requestType == "GET" {
            request.httpBody = Data()
        }else{
            let httpBody = try! JSONSerialization.data(withJSONObject: body!, options: .prettyPrinted)
            let JSONString: NSString = NSString(data: httpBody, encoding: String.Encoding.utf8.rawValue)!
            request.httpBody = JSONString.data(using: String.Encoding.utf8.rawValue)
            print("Request Body :- \n\(JSONString)\n")
        }
        return request
    }
}

