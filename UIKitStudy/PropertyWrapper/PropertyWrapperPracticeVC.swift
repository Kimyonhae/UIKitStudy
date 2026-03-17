import UIKit
import Combine

// MARK: - Property Wrapper
@propertyWrapper
final class CountWrapper {
    @Published var count: Int = 0
    
    init() {}
    
    /// `wrappedValue`: 외부에서 'count' 프로퍼티로 접근할 때 사용되는 값 (Int)
    var wrappedValue: Int {
        get { count }
        set { count = newValue }
    }
    
    /// `projectedValue`: '$' 접두사를 사용하여 `Published` 프로퍼티의 `Publisher`에 직접 접근하게 함.
    /// 이렇게 하면 `$count`가 직접 `Published<Int>.Publisher` 타입이 됩니다.
    var projectedValue: Published<Int>.Publisher { return $count }
    
    func plus() {
        count += 1
    }
    
    func minus() {
        count -= 1
    }
}

// MARK: - View Controller
final class PropertyWrapperPracticeVC: UIViewController {
    
    // @CountWrapper를 통해 count 프로퍼티 선언
    // count: wrappedValue (Int)
    // $count: projectedValue (Published<Int>.Publisher)
    // _count: CountWrapper 인스턴스 자체에 접근할 때 사용 (PropertyWrapper 인스턴스)
    @CountWrapper var count: Int
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        // 초기값 설정
        l.text = count.description
        l.font = .systemFont(ofSize: 60, weight: .bold)
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()
    
    private let plusBtn: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        var config: UIButton.Configuration = .borderedProminent()
        config.image = UIImage(systemName: "plus.circle.fill")
        config.title = " 추가"
        config.baseBackgroundColor = .systemBlue
        b.configuration = config
        return b
    }()
    
    private let minusBtn: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        var config: UIButton.Configuration = .borderedProminent()
        config.image = UIImage(systemName: "minus.circle.fill")
        config.title = " 빼기"
        config.baseBackgroundColor = .systemRed
        b.configuration = config
        return b
    }()
    
    private lazy var buttonStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [minusBtn, plusBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 20
        sv.distribution = .fillEqually
        return sv
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(label)
        view.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            
            buttonStack.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            buttonStack.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        plusBtn.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
        minusBtn.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
    }
    
    func bind() {
        $count
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                self?.label.text = newValue.description
                
                // 애니메이션 효과 추가
                UIView.animate(withDuration: 0.1, animations: {
                    self?.label.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }) { _ in
                    UIView.animate(withDuration: 0.1) {
                        self?.label.transform = .identity
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    @objc private func didTapPlus() {
        // CountWrapper 인스턴스 자체에 접근하려면 '_count'를 사용합니다.
        // (projectedValue($count)는 이제 Publisher이므로 plus() 메서드를 직접 호출할 수 없습니다.)
        _count.plus()
    }
    
    @objc private func didTapMinus() {
        _count.minus()
    }
}
