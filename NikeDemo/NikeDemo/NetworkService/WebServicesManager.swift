import UIKit

struct ServiceIdentifiers {
    static let BASE_SERVICE_URL         = "https://rss.itunes.apple.com/api/v1/in/"
    static let APPLE_MUSIC_TOP_ALBUMS   = "apple-music/top-albums/all/10/explicit.json"
}

class WebServicesManager: NSObject {
    
    let kPostMethod     = "POST"
    let kGetMethod      = "GET"
    let kDeleteMethod   = "DELETE"
    let kPutMethod      = "PUT"
    
    let service = NetworkBaseService()
    static let sharedInstance = WebServicesManager()
    
    fileprivate override init() {
        //init
    }
    
    // MARK:- Registeration Service
    func getAlbumList(completion: @escaping (_ response:AlbumFeedModel)->(),
                        onError: @escaping (_ error:Error)->()){
        
        let localSerIdentifier = ServiceIdentifiers.APPLE_MUSIC_TOP_ALBUMS
        service.makeServiceRequestWithUrl(url: ServiceIdentifiers.BASE_SERVICE_URL + localSerIdentifier, requestType: kGetMethod, parameters: [:], headers: [:], body:[:], success: { (response) in
            
            if let getkeyResponse = convertToDictionary(text: response){
                let getkeysModel = AlbumFeedModel.init(response: getkeyResponse as NSDictionary)
                completion(getkeysModel)
            }else{
                onError(NSError(domain: "Method Not Allowed", code: 405, userInfo: nil))
            }
        }) { (errorResponse) in
            onError(errorResponse)
        }
    }
}


func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}
