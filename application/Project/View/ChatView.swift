import UIKit
import Combine

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    private let backgroundView = ChristmasBackgroundView()
    private let tableView = UITableView()
    private let inputContainer = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    private let textField = UITextField()
    private let sendButton = UIButton(type: .system)
    
    private let viewModel = ChatViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupUI() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        inputContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputContainer)
        
        textField.placeholder = "Напиши шефу..."
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        textField.textColor = .black
        textField.layer.cornerRadius = 20
        textField.delegate = self
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 40))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.contentView.addSubview(textField)
        
        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.tintColor = .white
        sendButton.backgroundColor = AppTheme.Colors.mainGreen
        sendButton.layer.cornerRadius = 22
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        inputContainer.contentView.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainer.topAnchor),
            
            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            textField.topAnchor.constraint(equalTo: inputContainer.contentView.topAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: inputContainer.contentView.bottomAnchor, constant: -10),
            textField.leadingAnchor.constraint(equalTo: inputContainer.contentView.leadingAnchor, constant: 16),
            textField.heightAnchor.constraint(equalToConstant: 44),
            
            sendButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 10),
            sendButton.trailingAnchor.constraint(equalTo: inputContainer.contentView.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 44),
            sendButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tableView.addGestureRecognizer(tap)
    }
    
    private func bindViewModel() {
        viewModel.$messages.receive(on: RunLoop.main).sink { [weak self] _ in
            self?.tableView.reloadData()
            self?.scrollToBottom()
        }.store(in: &cancellables)
    }
    
    @objc private func sendTapped() {
        guard let text = textField.text, !text.isEmpty else { return }
        viewModel.inputText = text
        viewModel.sendMessage()
        textField.text = ""
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        cell.configure(with: viewModel.messages[indexPath.row])
        return cell
    }
    
    private func scrollToBottom() {
        guard viewModel.messages.count > 0 else { return }
        let indexPath = IndexPath(row: viewModel.messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y = -keyboardSize.height + (tabBarController?.tabBar.frame.height ?? 0)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
}

class ChatMessageCell: UITableViewCell {
    private let bubbleView = UIView()
    private let messageLabel = UILabel()
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        bubbleView.layer.cornerRadius = 20
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleView)
        
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(messageLabel)
        
        leadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        trailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
            
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 14),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -14)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with message: ChatMessage) {
        messageLabel.text = message.text
        if message.isUser {
            bubbleView.backgroundColor = AppTheme.Colors.mainGreen
            messageLabel.textColor = .white
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
        } else {
            bubbleView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
            messageLabel.textColor = .black
            trailingConstraint.isActive = false
            leadingConstraint.isActive = true
        }
    }
}
