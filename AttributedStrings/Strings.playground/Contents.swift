import UIKit

let alex = "Alexey"

for letter in alex {
    print("\(letter)")
}

let letters = alex[alex.index(alex.startIndex, offsetBy: 3)]

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let letter2 = alex[2]

let password = "12345"
password.hasPrefix("123")
password.hasSuffix("543")

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasPrefix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}

password.deletingPrefix("123")

let weather = "It's great sunny day!"
print(weather.capitalized)

extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

let swiftCheck = "Swift is like Objective-C without C"
swiftCheck.contains("Swift")

let programmingLanguages = ["Swift", "Java", "C++"]
programmingLanguages.contains("Swift")

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}

swiftCheck.containsAny(of: programmingLanguages)
programmingLanguages.contains(where: swiftCheck.contains)

let string = "Test string rich"
let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .backgroundColor: UIColor.red, .font: UIFont.boldSystemFont(ofSize: 36)]

//let attributedString = NSAttributedString(string: string, attributes: attributes)
let mutableAttributes = NSMutableAttributedString(string: string)
mutableAttributes.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
mutableAttributes.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 6))
mutableAttributes.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 12, length: 4))

