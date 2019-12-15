import Foundation

class AlbumFeedModel: NSObject{
    var feedResponse:FeedModel?
    var errorCode:AnyObject?
    var errorMessage:AnyObject?
    
    init(response : NSDictionary) {
        super.init()
        guard(response.allValues.count == 0) else {
            if let feedResponse = response["feed"] as? NSDictionary {
                self.feedResponse = FeedModel.init(response: feedResponse)
            }
            return
        }
    }
}

class FeedModel: NSObject{
    var albumResponse :[AlbumListModel] = []
    var errorCode:AnyObject?
    var errorMessage:AnyObject?
    
    init(response : NSDictionary) {
        super.init()
        guard(response.allValues.count == 0) else {
            if let resultsListResponse = response["results"] {
                if let resultsResponseArr = resultsListResponse as? NSArray{
                    for list in resultsResponseArr{
                        let obj = AlbumListModel.init(response: list as! NSDictionary)
                        albumResponse.append(obj)
                    }
                }
            }
            return
        }
    }
}

class AlbumListModel: NSObject{
    var artistName:AnyObject?
    var artistUrl:AnyObject?
    var albumName:AnyObject?
    var artworkUrl:AnyObject?
    var releaseDate:AnyObject?
    var copyright:AnyObject?
    var urlMusic:AnyObject?
    
    init(response : NSDictionary) {
        super.init()
        guard(response.allValues.count == 0) else {
            if let artistName = response["artistName"]{
                self.artistName = artistName as AnyObject?
            }
            if let artistUrl = response["artistUrl"] {
                self.artistUrl = artistUrl as AnyObject?
            }
            if let albumName = response["name"] {
                self.albumName = albumName as AnyObject?
            }
            if let artworkUrl = response["artworkUrl100"] {
                self.artworkUrl = artworkUrl as AnyObject?
            }
            if let releaseDate = response["releaseDate"] {
                self.releaseDate = releaseDate as AnyObject?
            }
            if let copyright = response["copyright"] {
                self.copyright = copyright as AnyObject?
            }
            if let urlMusic = response["url"] {
                self.urlMusic = urlMusic as AnyObject?
            }
            return
        }
    }
}
