import UIKit

final class BounceButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addTarget(
            self,
            action: #selector(scaleIn),
            for: [.touchDown, .touchDragEnter]
        )
        
        addTarget(
            self,
            action: #selector(scaleOut),
            for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Button Animations
    @objc private func scaleIn(_ sender: UIButton) {
  
        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            options: [.allowUserInteraction, .curveEaseIn],
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
                self.alpha = 0.8
            },
            completion: nil
        )
    }

    @objc private func scaleOut(_ sender: UIButton) {
        UIView.animate(
            withDuration: 0.1,
            delay: 0.1,
            options: [.allowUserInteraction, .curveEaseIn],
            animations: {
                self.transform = CGAffineTransform.identity
                self.alpha = 1.0
            },
            completion: nil
        )
    }
}
