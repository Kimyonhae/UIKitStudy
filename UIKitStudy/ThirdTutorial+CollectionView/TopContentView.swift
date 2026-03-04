import UIKit

final class TopContentView: UIView {
    // MARK: - State Variable
    private let bgColor: UIColor = UIColor(red: 255/255, green: 231/255, blue: 246/255, alpha: 1)
    private let data: [OnBoarding] = [
        OnBoarding(indicator: 0, image: UIImage(named: "face.pink")),
        OnBoarding(indicator: 1, image: UIImage(named: "face.pink")),
        OnBoarding(indicator: 2, image: UIImage(named: "face.pink")),
    ]

    // MARK: - Initialize Func
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollview.delegate = self
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Componenet
    
    private lazy var topContainer: UIView = {
        let t = UIView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.backgroundColor = bgColor
        t.layer.cornerRadius = 20
        t.layer.maskedCorners = CACornerMask(arrayLiteral: [
            .layerMaxXMaxYCorner,
            .layerMinXMaxYCorner
        ])

        return t
    }()
    
    private let slider: UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .horizontal
        s.spacing = 8
        s.distribution = .fillEqually
        
        return s
    }()
    
    private let scrollview: UIScrollView = {
        let s = UIScrollView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.isPagingEnabled = true
        s.showsHorizontalScrollIndicator = false
        s.showsVerticalScrollIndicator = false
        
        return s
    }()
    
    private var images: [UIImageView] = []
    
    private var steps: [UIView] = []
    
    private func setUpLayout() {
        
        for i in 0..<data.count {
            let step: UIView = createStep()
            let image: UIImageView = createImage(image: data[i].image)
            
            images.append(image)
            steps.append(step)
            
            scrollview.addSubview(image)
            slider.addArrangedSubview(step)
        }
        updateIndicator(index: 0) // indicator 초기화
        
        topContainer.addSubview(slider)
        topContainer.addSubview(scrollview)
        
        addSubview(topContainer)
        
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            topContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            topContainer.heightAnchor.constraint(equalTo: heightAnchor),
            
            slider.topAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.topAnchor),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            slider.heightAnchor.constraint(equalToConstant: 5),
            
            scrollview.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 20),
            scrollview.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 12),
            scrollview.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -12),
            scrollview.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: -20),
        ])
        
        for (index, image) in images.enumerated() {
            NSLayoutConstraint.activate([
                image.widthAnchor.constraint(equalTo: scrollview.frameLayoutGuide.widthAnchor),
                image.heightAnchor.constraint(equalTo: scrollview.frameLayoutGuide.heightAnchor),
            ])
            
            if index == 0 {
                image.leadingAnchor.constraint(equalTo: scrollview.contentLayoutGuide.leadingAnchor).isActive = true
            } else {
                image.leadingAnchor.constraint(equalTo: images[index - 1].trailingAnchor).isActive = true
            }
            
            if index == images.count - 1 {
                image.trailingAnchor.constraint(equalTo: scrollview.contentLayoutGuide.trailingAnchor).isActive = true
            }
        }
    }
}

// MARK: - Helper Function

extension TopContentView {
    func createStep() -> UIView {
        let s = UIView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = .systemGray
        
        return s
    }
    
    func createImage(image: UIImage?) -> UIImageView {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.image = image
        i.contentMode = .scaleAspectFit
        
        return i
    }
    
    func updateIndicator(index: Int) {
        for (i, step) in steps.enumerated() {
            step.backgroundColor = (i == index) ? .black : .systemGray
        }
    }
}

// MARK: - ScrollView Delegate
extension TopContentView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        UIView.animate(withDuration: 0.25) {
            self.updateIndicator(index: page)
        }
    }
}

// MARK: - ScrollView Indicator Data Structure
extension TopContentView {
    struct OnBoarding {
        let indicator: Int // 이건 쓸모가 없지만 가독성을 위함.
        let image: UIImage?
    }
}
