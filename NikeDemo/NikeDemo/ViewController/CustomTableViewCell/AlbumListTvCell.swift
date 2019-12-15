import UIKit

class AlbumListTvCell: UITableViewCell {
    @IBOutlet weak var imgArtwork: UIImageView!
    @IBOutlet weak var lblAlbumName: UILabel!
    @IBOutlet weak var lblArtiseName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
