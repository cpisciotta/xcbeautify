enum Pattern: String {
    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename
    case analyze = "Analyze(?:Shallow)?\\s(.*\\/(.*\\.(?:m|mm|cc|cpp|c|cxx)))\\s.*\\(in target: (.*)\\)"

    /// Regular expression captured groups:
    /// $1 = target
    /// $2 = project
    /// $3 = configuration
    case buildTarget = "=== BUILD TARGET\\s(.*)\\sOF PROJECT\\s(.*)\\sWITH.*CONFIGURATION\\s(.*)\\s==="

    /// Regular expression captured groups:
    /// $1 = target
    /// $2 = project
    /// $3 = configuration
    case aggregateTarget = "=== BUILD AGGREGATE TARGET\\s(.*)\\sOF PROJECT\\s(.*)\\sWITH.*CONFIGURATION\\s(.*)\\s==="

    /// Regular expression captured groups:
    /// $1 = target
    /// $2 = project
    /// $3 = configuration
    case analyzeTarget = "=== ANALYZE TARGET\\s(.*)\\sOF PROJECT\\s(.*)\\sWITH.*CONFIGURATION\\s(.*)\\s==="

    /// Nothing returned here for now
    case checkDependencies = "Check dependencies"

    /// Regular expression captured groups:
    /// $1 = command path
    /// $2 = arguments
    case shellCommand = "\\s{4}(cd|setenv|(?:[\\w\\/:\\\\\\s\\-.]+?\\/)?[\\w\\-]+)\\s(.*)$"

    /// Nothing returned here for now
    case cleanRemove = "Clean.Remove"

    /// Regular expression captured groups:
    /// $1 = target
    /// $2 = project
    /// $3 = configuration
    case cleanTarget = "=== CLEAN TARGET\\s(.*)\\sOF PROJECT\\s(.*)\\sWITH CONFIGURATION\\s(.*)\\s==="

    /// Regular expression captured groups:
    /// $1 = file
    case codesign = "CodeSign\\s((?:\\\\ |[^ ])*)$"

    /// Regular expression captured groups:
    /// $1 = file
    case codesignFramework = "CodeSign\\s((?:\\\\ |[^ ])*.framework)\\/Versions"

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename (e.g. KWNull.m)
    /// $3 = target
    case compile = "Compile[\\w]+\\s.+?\\s((?:\\\\.|[^ ])+\\/((?:\\\\.|[^ ])+\\.(?:m|mm|c|cc|cpp|cxx|swift)))\\s.*\\(in target: (.*)\\)"

    /// Regular expression captured groups:
    /// $1 = compiler command
    /// $2 = file path
    case compileCommand = "\\s*(.*clang\\s.*\\s\\-c\\s(.*\\.(?:m|mm|c|cc|cpp|cxx))\\s.*\\.o)$"

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename (e.g. MainMenu.xib)
    /// $3 = target
    case compileXib = "CompileXIB\\s(.*\\/(.*\\.xib))\\s.*\\(in target: (.*)\\)"

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename (e.g. Main.storyboard)
    /// $3 = target
    case compileStoryboard = "CompileStoryboard\\s(.*\\/([^\\/].*\\.storyboard))\\s.*\\(in target: (.*)\\)"

    /// Regular expression captured groups:
    /// $1 = source file
    /// $2 = target file
    /// $3 = target
    case copyHeader = "CpHeader\\s(.*\\.h)\\s(.*\\.h) \\(in target: (.*)\\)"

    /// Regular expression captured groups:
    /// $1 = source file
    /// $2 = target file
    case copyPlist = "CopyPlistFile\\s(.*\\.plist)\\s(.*\\.plist) \\(in target: (.*)\\)"

    /// Regular expression captured groups:
    /// $1 = file
    case copyStrings = "CopyStringsFile\\s(.*\\.strings)\\s(.*\\.strings) \\(in target: (.*)\\)"

    /// Regular expression captured groups:
    /// $1 = resource
    case cpresource = "CpResource\\s(.*)\\s\\/(.*) \\(in target: (.*)\\)"

    /// Regular expression captured groups:
    /// $1 = number of tests
    /// $2 = number of failures
    /// $3 = number of unexpected failures
    /// $4 = wall clock time in seconds (e.g. 0.295)
    case executed = "\\s*Executed\\s(\\d+)\\stest[s]?,\\swith\\s(\\d+)\\sfailure[s]?\\s\\((\\d+)\\sunexpected\\)\\sin\\s\\d+\\.\\d{3}\\s\\((\\d+\\.\\d{3})\\)\\sseconds"

    /// Regular expression captured groups:
    /// $1 = file
    /// $2 = test suite
    /// $3 = test case
    /// $4 = reason
    case failingTest = "\\s*(.+:\\d+):\\serror:\\s[\\+\\-]\\[(.*)\\s(.*)\\]\\s:(?:\\s'.*'\\s\\[FAILED\\],)?\\s(.*)"

    /// Regular expression captured groups:
    /// $1 = file
    /// $2 = reason
    case uiFailingTest = "\\s{4}t = \\s+\\d+\\.\\d+s\\s+Assertion Failure: (.*:\\d+): (.*)$"

    /// Regular expression captured groups:
    case restartingTests = "Restarting after unexpected exit or crash in.+$"

    /// Regular expression captured groups:
    /// $1 = dsym
    /// $2 = target
    case generateDsym = "GenerateDSYMFile \\/.*\\/(.*\\.dSYM) \\/.* \\(in target: (.*)\\)"

    /// Regular expression captured groups:
    /// $1 = library
    /// $2 = target
    case libtool = "Libtool.*\\/(.*) .* .* \\(in target: (.*)\\)"

    /// Regular expression captured groups:
    /// $1 = binary filename
    /// $4 = target
    case linking = "Ld \\/?.*\\/(.*?) normal .* \\(in target: (.*)\\)"

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = time
    case testCasePassed = "\\s*Test Case\\s'-\\[(.*)\\s(.*)\\]'\\spassed\\s\\((\\d*\\.\\d{3})\\sseconds\\)."

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    case testCaseStarted = "Test Case '-\\[(.*) (.*)\\]' started.$"

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    case testCasePending = "Test Case\\s'-\\[(.*)\\s(.*)PENDING\\]'\\spassed"
    /// $1 = suite
    /// $2 = test case
    /// $3 = time
    case testCaseMeasured = "[^:]*:[^:]*:\\sTest Case\\s'-\\[(.*)\\s(.*)\\]'\\smeasured\\s\\[Time,\\sseconds\\]\\saverage:\\s(\\d*\\.\\d{3})(.*){4}"

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = device
    /// $4 = installed app file and ID (e.g. MyApp.app (12345))
    /// $5 = time
    case parallelTestCasePassed = "Test case '(.*)\\.(.*)\\(\\)' passed on '(.*) - (.*)' \\((\\d*\\.(.*){3}) seconds\\)"

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = time
    case parallelTestCaseAppKitPassed = "\\s*Test case\\s'-\\[(.*)\\s(.*)\\]'\\spassed\\son\\s'.*'\\s\\((\\d*\\.\\d{3})\\sseconds\\)"

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = device
    /// $4 = installed app file and ID (e.g. MyApp.app (12345))
    /// $5 = time
    case parallelTestCaseFailed = "Test case '(.*)\\.(.*)\\(\\)' failed on '(.*) - (.*)' \\((\\d*\\.(.*){3}) seconds\\)"

    /// Regular expression captured groups:
    /// $1 = device
    case parallelTestingStarted = "Testing started on '(.*)'"

    /// Nothing returned here for now
    case phaseSuccess = "\\*\\*\\s(.*)\\sSUCCEEDED\\s\\*\\*"

    /// Regular expression captured groups:
    /// $1 = phase name
    /// $2 = target
    case phaseScriptExecution = "PhaseScriptExecution\\s(.*)\\s\\/.*\\.sh\\s\\(in target: (.*)\\)"

    /// Regular expression captured groups:
    /// $1 = file
    /// $2 = build target
    case processPch = "ProcessPCH\\s.*\\s\\/.*\\/(.*.pch) normal .* .* .* \\(in target: (.*)\\)"

    /// Regular expression captured groups:
    /// $1 file path
    case processPchCommand = "\\s*.*\\/usr\\/bin\\/clang\\s.*\\s\\-c\\s(.*)\\s\\-o\\s.*"

    /// Regular expression captured groups:
    /// $1 = file
    case preprocess = "Preprocess\\s(?:(?:\\\\ |[^ ])*)\\s((?:\\\\ |[^ ])*)$"

    /// Regular expression captured groups:
    /// $1 = source file
    /// $2 = target file
    /// $3 = build target
    case pbxcp = "PBXCp\\s(.*)\\s\\/(.*)\\s\\(in target: (.*)\\)"

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename
    /// $4 = target
    case processInfoPlist = "ProcessInfoPlistFile\\s.*\\.plist\\s(.*\\/+(.*\\.plist))( \\(in target: (.*)\\))?"

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = time
    case testsRunCompletion = "\\s*Test Suite '(?:.*\\/)?(.*[ox]ctest.*)' (finished|passed|failed) at (.*)"

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = time
    case testSuiteStarted = "\\s*Test Suite '(?:.*\\/)?(.*[ox]ctest.*)' started at(.*)"

    /// Regular expression captured groups:
    /// $1 = test suite name
    case testSuiteStart = "\\s*Test Suite '(.*)' started at"

    /// Regular expression captured groups:
    /// $1 = filename
    case tiffutil = "TiffUtil\\s(.*)"

    /// Regular expression captured groups:
    /// $1 = filename
    /// $3 = target
    case touch = "Touch\\s(.*\\/(.+))( \\(in target: (.*)\\))"

    /// Regular expression captured groups:
    /// $1 = file path
    case writeFile = "write-file\\s(.*)"

    /// Nothing returned here for now
    case writeAuxiliaryFiles = "Write auxiliary files"

    // MARK: - Warning

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename
    /// $3 = reason
    case compileWarning = "(\\/.+\\/(.*):.*:.*):\\swarning:\\s(.*)$"

    /// Regular expression captured groups:
    /// $1 = ld prefix
    /// $2 = warning message
    case ldWarning = "(ld: )warning: (.*)"

    /// Regular expression captured groups:
    /// $1 = whole warning
    case genericWarning = "warning:\\s(.*)$"

    /// Regular expression captured groups:
    /// $1 = whole warning
    case willNotBeCodeSigned = "(.* will not be code signed because .*)$"

    // MARK: - Error

    /// Regular expression captured groups:
    /// $1 = whole error
    case clangError = "(clang: error:.*)$"

    /// Regular expression captured groups:
    /// $1 = whole error
    case checkDependenciesErrors = "(Code\\s?Sign error:.*|Code signing is required for product type .* in SDK .*|No profile matching .* found:.*|Provisioning profile .* doesn't .*|Swift is unavailable on .*|.?Use Legacy Swift Language Version.*)$"

    /// Regular expression captured groups:
    /// $1 = whole error
    case provisioningProfileRequired = "(.*requires a provisioning profile.*)$"

    /// Regular expression captured groups:
    /// $1 = whole error
    case noCertificate = "(No certificate matching.*)$"

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename
    /// $3 = reason
    case compileError = "(\\/.+\\/(.*):.*:.*):\\s(?:fatal\\s)?error:\\s(.*)$"

    /// Regular expression captured groups:
    /// $1 = cursor (with whitespaces and tildes)
    case cursor = "([\\s~]*\\^[\\s~]*)$"

    /// Regular expression captured groups:
    /// $1 = whole error.
    /// it varies a lot, not sure if it makes sense to catch everything separately
    case fatalError = "(fatal error:.*)$"

    /// Regular expression captured groups:
    /// $1 = whole error.
    /// $2 = file path
    case fileMissingError = "<unknown>:0:\\s(error:\\s.*)\\s'(\\/.+\\/.*\\..*)'$"

    /// Regular expression captured groups:
    /// $1 = whole error
    case ldError = "(ld:.*)"

    /// Regular expression captured groups:
    /// $1 = file path
    case linkerDuplicateSymbolsLocation = "\\s+(\\/.*\\.o[\\)]?)$"

    /// Regular expression captured groups:
    /// $1 = reason
    case linkerDuplicateSymbols = "(duplicate symbol .*):$"

    /// Regular expression captured groups:
    /// $1 = symbol location
    case linkerUndefinedSymbolLocation = "(.* in .*\\.o)$"

    /// Regular expression captured groups:
    /// $1 = reason
    case linkerUndefinedSymbols = "(Undefined symbols for architecture .*):$"

    /// Regular expression captured groups:
    /// $1 = reason
    case podsError = "(error:\\s.*)"

    /// Regular expression captured groups:
    /// $1 = reference
    case symbolReferencedFrom = "\\s+\"(.*)\", referenced from:$"

    /// Regular expression captured groups:
    /// $1 = error reason
    case moduleIncludesError = "\\<module-includes\\>:.*?:.*?:\\s(?:fatal\\s)?(error:\\s.*)$/"
}
