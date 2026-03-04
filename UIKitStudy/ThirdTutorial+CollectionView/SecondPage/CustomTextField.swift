import UIKit

// MARK: - CustomTextField subclass
final class CustomTextField: UITextField {
    static let leadingPadding: CGFloat = 59 // 왼쪽 패딩
    var textInsets = UIEdgeInsets(top: 0, left: leadingPadding, bottom: 0, right: 12)
    
    private let searchIconContainer: UIView = {
        let s = UIView()
        s.translatesAutoresizingMaskIntoConstraints = false
        
        return s
    }()
    
    private let searchIcon: UIImageView = {
        let s = UIImageView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.image = UIImage(systemName: "magnifyingglass")
        s.tintColor = .systemGray
        s.contentMode = .scaleAspectFit
        
        return s
    }()
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        setUp()
        setUpLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.borderStyle = .none
        self.backgroundColor = .white
        self.layer.cornerRadius = 30
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.clipsToBounds = false
        self.leftViewMode = .always
        self.leftView = searchIconContainer
    }
    private func setUpLayout() {
        searchIconContainer.addSubview(searchIcon)
        
        NSLayoutConstraint.activate([
            searchIconContainer.widthAnchor.constraint(equalToConstant: Self.leadingPadding),
            searchIconContainer.heightAnchor.constraint(equalToConstant: Self.leadingPadding),
            searchIcon.centerXAnchor.constraint(equalTo: searchIconContainer.centerXAnchor),
            searchIcon.centerYAnchor.constraint(equalTo: searchIconContainer.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 30),
            searchIcon.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
}
