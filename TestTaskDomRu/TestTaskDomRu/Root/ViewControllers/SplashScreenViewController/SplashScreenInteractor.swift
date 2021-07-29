import Foundation

final class SplashScreenInteractor {
    
    private let updater = Updater.shared
    
    weak var delegate: StatusLabelDelegate?
    
    private let queue = DispatchQueue(label: "com.interactor.queue")
    private let delegateQueue = DispatchQueue(label: "com.interactor.delegate")
    
    init() {
        updater.delegate = self
    }
}

// MARK: - Interactor Interface -

extension SplashScreenInteractor: SplashScreenInteractorInterface {
    func session(_ completion: @escaping ((Bool)->())) {
        queue.async { [self] in
            switch updater.lastDataNotNil {
            case true:
                updater.restore()
            default:
                updater.startSession(ofType: .detailed)
            }
        }
    }
}

// MARK: - Updater Delegate -

extension SplashScreenInteractor: UpdaterDelegate {
    func notify(with status: UpdaterStatus) {
        switch status {
        case let .request(state):
            let delay: TimeInterval = 0.25
            switch state {
            case .accepted:
                msg("Подключаюсь к синоптикам 👋")
            case .received:
                msg("Бип-боп, узнаю прогноз 🌍", delay)
            case .processed:
                msg("Формирую данные ⛅️", delay)
            case .completed:
                msg("Обновление завершено! 🎉", delay, {
                    Thread.sleep(forTimeInterval: delay / 2)
                    self.delegate?.completed(true)
                })
            }
        case .error(let error):
            switch error {
            default:
                msg("Ошибка: \(error.localizedDescription)")
            }
        }
        func msg(_ text: String, _ delay: TimeInterval = 0, _ completion: (()->())? = nil) {
            delegateQueue.asyncAfter(deadline: .now() + delay, execute: {
                Thread.sleep(forTimeInterval: delay / 2)
                self.delegate?.status(with: text)
                completion?()
            })
        }
    }
}
