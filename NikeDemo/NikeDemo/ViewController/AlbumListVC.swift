import UIKit

class AlbumListVC: UIViewController {
    //MARK:- All IBOutlet and variable declaration
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var tableView: UITableView!
    var albumResponse :[AlbumListModel] = []

    //MARK:- View Controller Cycle
    override func viewDidLoad() {
        self.tableView.register(UINib(nibName: "AlbumListTvCell", bundle: nil), forCellReuseIdentifier: "AlbumListTvCell")
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callWebService()
    }
    
    //MARK:- Web Service
    func callWebService(){
        FUProgressView.shared.showProgressView(view)
        WebServicesManager.sharedInstance.getAlbumList(completion: {(albumFeedModel) in
            self.albumResponse = albumFeedModel.feedResponse?.albumResponse ?? []
            self.tableView.reloadData()
            FUProgressView.shared.hideProgressView()
        }, onError: { (error) in
            FUProgressView.shared.hideProgressView()
        })
    }
}

//MARK:- UITableView Data Source
extension AlbumListVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumListTvCell", for: indexPath) as! AlbumListTvCell
        cell.imgArtwork.downloaded(from: self.albumResponse[indexPath.row].artworkUrl as? String ?? "")
        cell.lblAlbumName.text  = (self.albumResponse[indexPath.row].albumName as? String)
        cell.lblArtiseName.text  = (self.albumResponse[indexPath.row].artistName as? String)
        return cell
    }
}

//MARK:- UITableView Delegate
extension AlbumListVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AlbumDetailVC") as! AlbumDetailVC
        nextViewController.albumResponse = self.albumResponse[indexPath.row]
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
