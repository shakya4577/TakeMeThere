import UIKit


class LocationTableCell: UITableViewCell {

    @IBOutlet weak var lblLocation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    public func initCell(locName:String)
    {
        lblLocation.text = locName
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
