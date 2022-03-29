public final class JMessageInput: UIView {
    let maxTextHeight:CGFloat = 100
    let minTextHeight:CGFloat = 35
    
    let animationDuration:Double = 0.3
    
    var temporaryConstraints = [NSLayoutConstraint]()
    var textViewHeightConstraint: NSLayoutConstraint?
//    var textField
    
    func processState() {
        switch(state) {
        case .dirty:
            UIView.animate(withDuration: 0.5, delay: 0, options: [.transitionFlipFromBottom], animations: {
                self.layoutForDirtyState()
                self.stackView.layoutIfNeeded()
            }, completion: nil)
        default:
            UIView.animate(withDuration: 0.5, delay: 0, options: [.transitionFlipFromBottom], animations: {
                self.layoutForInitialState()
                self.stackView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func layoutForDirtyState() {
        sendButton.show()
        micButton.hide()
        cameraButton.hide()
    }
    
    func layoutForInitialState() {
        sendButton.hide()
        micButton.show()
        cameraButton.show()
    }
    
    func setup() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(leftButton)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(cameraButton)
        stackView.addArrangedSubview(sendButton)
        stackView.addArrangedSubview(micButton)

        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor, constant: -10)
        ])
        
        if (textViewHeightConstraint == nil) {
            textViewHeightConstraint = textField.heightAnchor.constraint(greaterThanOrEqualToConstant: minTextHeight)
        }

        NSLayoutConstraint.activate([
            textViewHeightConstraint!,
            leftButton.heightAnchor.constraint(equalToConstant: minTextHeight),
            cameraButton.heightAnchor.constraint(equalToConstant:minTextHeight),
            micButton.heightAnchor.constraint(equalToConstant: minTextHeight),
            sendButton.heightAnchor.constraint(equalToConstant: minTextHeight),
        ])
        
        NSLayoutConstraint.activate([
            leftButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.1),
            cameraButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.1),
            micButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.1),
            sendButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.1)
        ])
        
        layoutForInitialState()

    }
    
    var state: JMessageInputState = .initial {
        didSet {
            if (oldValue != state) {
                processState()
            }
        }
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.alignment = .bottom
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var textField: JMessageInputTextView = {
        let field = JMessageInputTextView()
        
        field.delegate = self
    
        
        return field
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)

        } else {
            // Fallback on earlier versions
        }

        return button
    }()
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        
//                    button.contentHorizontalAlignment = .left
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "plus"), for: .normal)
//            button.contentHorizontalAlignment = .fill
//            button.contentVerticalAlignment = .fill
        } else {
            // Fallback on earlier versions
        }
        
//        button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        return button
    }()
    
    
    lazy var micButton: UIButton = {
        let button = UIButton()
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "mic"), for: .normal)
        } else {
            // Fallback on earlier versions
        }

        return button
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton()
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "camera"), for: .normal)
//            button.contentHorizontalAlignment = .fill
//            button.contentVerticalAlignment = .fill
        } else {
            // Fallback on earlier versions
        }
        return button
    }()
    
    convenience init() {
        let frame = CGRect(origin: .zero, size: .init(width: 200, height: 40))
        self.init(frame: frame)
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
      
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
