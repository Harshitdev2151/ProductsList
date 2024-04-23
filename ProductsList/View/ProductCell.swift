
import UIKit
import CoreData

class ProductCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productBackgroundView: UIView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        productBackgroundView.clipsToBounds = false
        productBackgroundView.layer.cornerRadius = 15

        productImageView.layer.cornerRadius = 10

        self.productBackgroundView.backgroundColor = .systemGray6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureWith(_ product: Product) {
        productTitleLabel.text = product.title
        productCategoryLabel.text = product.category
        descriptionLabel.text = product.description
        if let price = product.price {
            priceLabel.text = "$\(price)"
        }
        rateButton.setTitle("\(product.rating ?? 0)", for: .normal)
        self.productImageView.image = UIImage(named: Constants.defaultLoaderImage)
    }

    func setImage(_ img: UIImage?) {
        DispatchQueue.main.async {
            self.productImageView.image = img
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.productImageView.image = nil
    }
    
}
