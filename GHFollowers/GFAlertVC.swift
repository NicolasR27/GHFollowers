
import UIKit

class GFAlertVC: UIViewController {
   
    let containerview = UIView()
    let titleLabel = GFTitleLabel(textAligment: .center, fontsize: 32)
    let messageLabel = GFBodyLabel(textAligment: .center, fontsize: 20)
    let actionButton = GFButton(backgroundColor: .systemPink, title: "Ok" )

    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    
    init(title:String, message: String,buttonTitle:String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        
        
    }
    
    func configureContainerView() {
        view.addSubview(containerview)
        containerview.layer.cornerRadius = 16
        containerview.layer.borderWidth = 2
        containerview.layer.borderColor = .
        containerview.trailingAncho
    }
    
}
