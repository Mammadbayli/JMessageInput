@objc public final class JMessageInput: UIView {
    
    @objc public weak var delegate: JMessageInputDelegate?
    
    let gestureRecognizer = UITapGestureRecognizer()
    @objc public weak var gestureRecognizerToFail: UIGestureRecognizer?
    
    @objc public var maxTextHeight = 100.0
    @objc public var minTextHeight = 35.0
    
    @objc public var animationDuration = 0.3
    @objc public var state: JMessageInputState = .initial {
        didSet {
            if (oldValue != state) {
                processState()
            }
            
            if self.delegate?.stateDidChange != nil {
                self.delegate?.stateDidChange!(input: self, oldState: oldValue)
            }

        }
        
        willSet {
            if self.delegate?.stateWillChange != nil {
                self.delegate?.stateWillChange!(input: self, newState: newValue)
            }

        }
    }
    
    @objc public var text: String? {
        get {
            self.textView.text
        }
        
        set(val) {
            self.textView.text = val
            self.textViewDidChange(self.textView)
        }
    }
    
    var isPlusButtonPressed = false
    var isMicButtonPressed = false
    var isCameraButtonPressed = false
    var isSendButtonPressed = false
    
    var temporaryConstraints = [NSLayoutConstraint]()
    var textViewHeightConstraint: NSLayoutConstraint?
    var initialTouchLocation: CGPoint?
    
    var shouldAnimateRedMic = false
    
    func setup() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(plusButton)
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(recordingIndicatorImageView)
        stackView.addArrangedSubview(recordingDurationLabel)
        stackView.addArrangedSubview(cameraButton)
        stackView.addArrangedSubview(sendButton)
        stackView.addArrangedSubview(slideToCancelLabel)
        stackView.addArrangedSubview(micButton)
        
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor, constant: 0),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor, constant: -14)
        ])
        
        if (textViewHeightConstraint == nil) {
            textViewHeightConstraint = textView.heightAnchor.constraint(greaterThanOrEqualToConstant: minTextHeight)
        }
        
        NSLayoutConstraint.activate([
            textViewHeightConstraint!,
            recordingIndicatorImageView.heightAnchor.constraint(equalToConstant: minTextHeight),
            recordingDurationLabel.heightAnchor.constraint(equalToConstant: minTextHeight),
            plusButton.heightAnchor.constraint(equalToConstant: minTextHeight),
            cameraButton.heightAnchor.constraint(equalToConstant:minTextHeight),
            micButton.heightAnchor.constraint(equalToConstant: minTextHeight),
            sendButton.heightAnchor.constraint(equalToConstant: minTextHeight),
            slideToCancelLabel.heightAnchor.constraint(equalToConstant: minTextHeight),
        ])
        
        NSLayoutConstraint.activate([
            recordingIndicatorImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.1),
            recordingDurationLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.25),
            plusButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.1),
            cameraButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.1),
            micButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.1),
            sendButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.1)
        ])
        
        layoutForInitialState()
    }
    
    
    func animateRedMic() {
        shouldAnimateRedMic = true
        UIView.animate(withDuration: 0.5) {
            self.recordingIndicatorImageView.alpha = self.recordingIndicatorImageView.alpha == 1 ? 0 : 1
        } completion: { _ in
            if (self.shouldAnimateRedMic) {
                self.animateRedMic()
            }
            
        }
    }
    
    func stopAnimatingRedMic() {
        shouldAnimateRedMic = false
    }
    
    lazy var slideToCancelLabel: UILabel = {
        let label = UILabel()
        label.text = "slide to cancel ‹"
        
        return label
    }()
    
    @objc public lazy var recordingDurationLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        return label
    }()
    
    lazy var recordingIndicatorImageView: UIImageView = {
        let view = UIImageView()
        if #available(iOS 13.0, *) {
            view.image =  UIImage.init(systemName: "mic")?.withRenderingMode(.alwaysTemplate)//.withTintColor(.red)
        } else {
            // Fallback on earlier versions
        }
        view.contentMode = .center
        view.isHidden = true
        view.tintColor = .red
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.alignment = .bottom
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    @objc public lazy var textView: JMessageInputTextView = {
        let view = JMessageInputTextView()
        
        view.delegate = self
        view.inputAccessoryView = nil
        
        return view
    }()
    
    @objc public lazy var sendButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
            
        } else {
            // Fallback on earlier versions
        }
        
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    @objc public lazy var plusButton: UIButton = {
        let button = UIButton()
        
        //                    button.contentHorizontalAlignment = .left
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "plus"), for: .normal)
            //            button.contentHorizontalAlignment = .fill
            //            button.contentVerticalAlignment = .fill
        } else {
            // Fallback on earlier versions
        }
        
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    
    @objc public lazy var micButton: UIButton = {
        let button = UIButton()
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "mic"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    @objc public lazy var cameraButton: UIButton = {
        let button = UIButton()
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "camera"), for: .normal)
            //            button.contentHorizontalAlignment = .fill
            //            button.contentVerticalAlignment = .fill
        } else {
            // Fallback on earlier versions
        }
        
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    @objc public convenience init() {
        //        let frame = CGRect(origin: .zero, size: .init(width: 200, height: 40))
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        
        setup()
        
        gestureRecognizer.delegate = self
        gestureRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(gestureRecognizer)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
