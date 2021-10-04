import Foundation

/// Allow actions to be composited and performed one after another.
/// Actions will be performed in the order they are specified in the initializer
public class SystemActionComposite: SystemAction {
    var actions: [SystemAction]

    public init(_ actions: [SystemAction] = []) {
        self.actions = actions
    }

    public func heading(_ type: SystemActionHeading, _ string: String) {
        self.actions.forEach {
            $0.heading(type, string)
        }
    }
    public func createDirectory(url: URL) throws {
        try self.actions.forEach {
            try $0.createDirectory(url: url)
        }
    }

    public func createFile(fileUrl: URL, content: String) throws {
        try self.actions.forEach {
            try $0.createFile(fileUrl: fileUrl, content: content)
        }
    }

    public func runAndPrint(path: String?, command: [String]) throws {
        try self.actions.forEach {
            try $0.runAndPrint(path: path, command: command)
        }
    }
}
