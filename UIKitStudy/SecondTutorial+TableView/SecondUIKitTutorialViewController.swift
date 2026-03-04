import UIKit

final class SecondUIKitTutorialViewController: UIViewController {
    
    private var headerTopConstraint: NSLayoutConstraint!
    
    private let headerview: HeaderView = {
        let h = HeaderView()
        h.translatesAutoresizingMaskIntoConstraints = false
        
        return h
    }()
    
    private let tableview: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.backgroundColor = .clear
        t.showsVerticalScrollIndicator = false
        
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHeaderConfiguration()
        setConfiguration()
        setTableViewConfiguration()
    }
    
    // MARK: - Header Area
    private func setUpHeaderConfiguration() {
        view.addSubview(headerview)
        
        headerTopConstraint = headerview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        
        NSLayoutConstraint.activate([
            headerTopConstraint,
            headerview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerview.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    // MARK: - Navigation, Title: Setting
    private func setConfiguration() {
        self.view.backgroundColor = .secondarySystemBackground
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - TableView Setting
    private func setTableViewConfiguration() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 100
        tableview.separatorStyle = .none
        
        tableview.register(SecondTableViewCell.self, forCellReuseIdentifier: SecondTableViewCell.reuseIdentifier)
        view.addSubview(tableview)
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: headerview.bottomAnchor),
            tableview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - TableView Delegate,DataSource
extension SecondUIKitTutorialViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ScheduleItem.mockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SecondTableViewCell.reuseIdentifier, for: indexPath) as! SecondTableViewCell
        
        let item: ScheduleItem = ScheduleItem.mockData[indexPath.row]
        cell.set(with: item)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        
        let swipingDown: Bool = y <= 0
        let shouldSnap: Bool = y > 30
        let topHeaderHeight: CGFloat = headerview.bounds.height
        
        UIView.animate(withDuration: 0.3) {
            self.headerview.alpha = swipingDown ? 1.0 : 0.0
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
            self.headerTopConstraint.constant = shouldSnap ? -topHeaderHeight : 0
            self.view.layoutIfNeeded()
        }
        
    }
}

#Preview {
    SecondUIKitTutorialViewController()
}
