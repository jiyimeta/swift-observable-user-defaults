import ObservableUserDefaults
import ObservableUserDefaultsMacros

extension ObservableUserDefaults {
    @UserDefaultsEntry var count = 0
    @UserDefaultsEntry("barCount") var fooCount = 0
    @UserDefaultsEntry var title: String?
}
