public final class JMessageInput: UIView {
    let maxTextHeight:CGFloat = 100
    let minTextHeight:CGFloat = 35
    
    let animationDuration:Double = 0.3
    
    var temporaryConstraints = [NSLayoutConstraint]()
    var textViewHeightConstraint: NSLayoutConstraint?
    var initialTouchLocation: CGPoint?
//    var textField
    
    func processState() {
        switch(state) {
        case .dirty:
            UIView.animate(withDuration: 0.3, delay: 0, options: [.transitionFlipFromBottom], animations: {
                self.layoutForDirtyState()
                self.stackView.layoutIfNeeded()
                self.slideToCancelLabel.stopShimmering()
            }, completion: nil)
        case .recordingAudio:
            UIView.animate(withDuration: 0.3, delay: 0, options: [.transitionFlipFromBottom], animations: {
                self.layoutForRecordingAudioState()
                self.stackView.layoutIfNeeded()
                self.slideToCancelLabel.startShimmering()
            }, completion: nil)
        default:
            UIView.animate(withDuration: 0.3, delay: 0, options: [.transitionFlipFromBottom], animations: {
                self.layoutForInitialState()
                self.stackView.layoutIfNeeded()
                self.slideToCancelLabel.stopShimmering()
            }, completion: nil)
        }
    }
    
    func layoutForDirtyState() {
        recordingIndicatorImageView.hide()
        recordingDurationLabel.hide()
        slideToCancelLabel.hide()
        leftButton.show()
        textField.show()
        micButton.hide()
        cameraButton.hide()
        sendButton.show()
        
        stopAnimatingRedMic()
    }
    
    func layoutForInitialState() {
        recordingIndicatorImageView.hide()
        recordingDurationLabel.hide()
        slideToCancelLabel.hide()
        leftButton.show()
        textField.show()
        micButton.show()
        cameraButton.show()
        sendButton.hide()
        
        stopAnimatingRedMic()
    }
    
    func layoutForRecordingAudioState() {
        recordingIndicatorImageView.show()
        recordingDurationLabel.show()
        slideToCancelLabel.show()
        leftButton.hide()
        textField.hide()
        micButton.show()
        cameraButton.hide()
        sendButton.hide()
        
        animateRedMic()
    }
    
    
    func setup() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(leftButton)
        stackView.addArrangedSubview(textField)
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
            textViewHeightConstraint = textField.heightAnchor.constraint(greaterThanOrEqualToConstant: minTextHeight)
        }

        NSLayoutConstraint.activate([
            textViewHeightConstraint!,
            recordingIndicatorImageView.heightAnchor.constraint(equalToConstant: minTextHeight),
            recordingDurationLabel.heightAnchor.constraint(equalToConstant: minTextHeight),
            leftButton.heightAnchor.constraint(equalToConstant: minTextHeight),
            cameraButton.heightAnchor.constraint(equalToConstant:minTextHeight),
            micButton.heightAnchor.constraint(equalToConstant: minTextHeight),
            sendButton.heightAnchor.constraint(equalToConstant: minTextHeight),
            slideToCancelLabel.heightAnchor.constraint(equalToConstant: minTextHeight),
        ])
        
        NSLayoutConstraint.activate([
            recordingIndicatorImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.1),
            recordingDurationLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.25),
            leftButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.1),
            cameraButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.1),
            micButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.1),
            sendButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.1)
        ])
        
        layoutForInitialState()

    }
    
    @objc func micButtonPressed() {
        state = .recordingAudio
    }
    
    @objc func micButtonReleased() {
        state = .initial
    }
    
    
    var shouldAnimateRedMic = false
    
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
    
    var state: JMessageInputState = .initial {
        didSet {
            if (oldValue != state) {
                processState()
            }
        }
    }
    
    
    lazy var slideToCancelLabel: UILabel = {
        let label = UILabel()
        label.text = "slide to cancel ‹"
        
        return label
    }()
    
    lazy var recordingDurationLabel: UILabel = {
        let label = UILabel()
        label.text = "0:12"
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
        
        button.isUserInteractionEnabled = false
        
//        button.addTarget(self, action: #selector(micButtonPressed), for: .touchDown)
//        button.addTarget(self, action: #selector(micButtonReleased), for: .touchUpInside)
//        button.addTarget(self, action: #selector(micButtonReleased), for: .touchDragExit)
        
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
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        
        setup()
        
        let recognizer = UITapGestureRecognizer()
        recognizer.delegate = self
        self.addGestureRecognizer(recognizer)
      
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
