import Foundation

public enum SystemActionHeading {
    case section
    case phase
}

/// `SystemAction` provides some common system-level actions typically needed of command-line utilities.  It is a protocol that abstracts the intent of the action from the implementation of the action.
///
/// It is particularly well suited to supporting verbose and dry-run modes for command-line utilities.  This can be accomplished with code like this:
///
/// ```
///        let actions: SystemAction
///        if enableDryRun {
///            actions = CompositeAction([SystemActionPrint()])
///        } else if verbose {
///            actions = CompositeAction([SystemActionPrint(), SystemActionReal()])
///        } else {
///            actions = CompositeAction([SystemActionReal()])
///        }
/// ```
///
public protocol SystemAction {
    /// Declare a heading for the next set of actions
    func heading(_ type: SystemActionHeading, _ string: String)

    /// Attempt to create a directory
    func createDirectory(url: URL) throws

    /// Attempt to create a file containing the given string
    func createFile(fileUrl: URL, content: String) throws

    /// Execute a program and print the results to stdout
    func runAndPrint(path: String?, command: [String]) throws
}

public extension SystemAction {
    /// Print the title of a section
    /// - Parameter string: title to print
    func section(_ string: String) {
        self.heading(.section, string)
    }

    /// Print the title of a phase
    /// - Parameter string: title to print
    func phase(_ string: String) {
        self.heading(.phase, string)
    }

    /// Create a file at a given path.
    ///
    /// This will overwrite existing files.
    /// - Parameters:
    ///   - file: fileURL to create
    ///   - contentBuilder: A closure that returns the content to write into the file.
    /// - Throws: any problems in creating file.
    func createFile(fileUrl: URL, _ contentBuilder: ()->String) throws {
        let content = contentBuilder()
        try self.createFile(fileUrl: fileUrl, content: content)
    }

    /// Execute the given command and show the results
    /// - Parameters:
    ///   - path: If not-nil, this will be the current working directory when the command is exectued.
    ///   - command: Command to execute
    /// - Throws: any problems in executing the command or if the command has a non-0 return code
    func runAndPrint(path: String?=nil, command: String...) throws {
        try self.runAndPrint(path: path, command: command)
    }
}
