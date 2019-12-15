import UIKit

class AlbumDetailVC: UIViewController {
    //MARK:- All IBOutlet and variable declaration
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var imgArtwork: UIImageView!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblCopyRight: UILabel!
    @IBOutlet weak var lblArtiseName: UILabel!
    var albumResponse : AlbumListModel?

    //MARK:- View Controller Cycle
    override func viewDidLoad() {
        setUpDetails()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setUpDetails() {
        albumTitle.text = albumResponse?.albumName as? String
        imgArtwork.downloaded(from: albumResponse?.artworkUrl as? String ?? "")
        lblGenre.text = ""
        lblReleaseDate.text = "Release Date : " + (albumResponse?.releaseDate as? String ?? "")
        lblCopyRight.text = albumResponse?.copyright as? String
        lblArtiseName.text = "Artise Name : " + (albumResponse?.artistName as? String ?? "")
    }
    
    @IBAction func backBtnTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func itunesBtnTapped(){
        guard let url = URL(string: albumResponse?.urlMusic as? String ?? "") else {
                //handle error here
                return
            }
        UIApplication.shared.openURL(url)
    }
}
