class Parser {
    var summary: TestSummary? = nil

    func parse(line: String) -> String? {
        switch line {
        case Matcher.analyzeMatcher:
            return line.beautify(pattern: .analyze)
        case Matcher.buildTargetMatcher:
            return line.beautify(pattern: .buildTarget)
        case Matcher.aggregateTargetMatcher:
            return line.beautify(pattern: .aggregateTarget)
        case Matcher.analyzeTargetMatcher:
            return line.beautify(pattern: .analyzeTarget)
        case Matcher.checkDependenciesMatcher:
            return line.beautify(pattern: .checkDependencies)
        case Matcher.shellCommandMatcher:
            return line.beautify(pattern: .shellCommand)
        case Matcher.cleanRemoveMatcher:
            return line.beautify(pattern: .cleanRemove)
        case Matcher.cleanTargetMatcher:
            return line.beautify(pattern: .cleanTarget)
        case Matcher.codesignMatcher:
            return line.beautify(pattern: .codesign)
        case Matcher.codesignFrameworkMatcher:
            return line.beautify(pattern: .codesignFramework)
        case Matcher.compileMatcher:
            return line.beautify(pattern: .compile)
        case Matcher.compileSwiftMatcher:
            return line.beautify(pattern: .compileSwift)
        case Matcher.compileCommandMatcher:
            return line.beautify(pattern: .compileCommand)
        case Matcher.compileXibMatcher:
            return line.beautify(pattern: .compileXib)
        case Matcher.compileStoryboardMatcher:
            return line.beautify(pattern: .compileStoryboard)
        case Matcher.copyHeaderMatcher:
            return line.beautify(pattern: .copyHeader)
        case Matcher.copyPlistMatcher:
            return line.beautify(pattern: .copyPlist)
        case Matcher.copyStringsMatcher:
            return line.beautify(pattern: .copyStrings)
        case Matcher.cpresourceMatcher:
            return line.beautify(pattern: .cpresource)
        case Matcher.executedMatcher:
            parseSummary(line: line)
            return nil
        case Matcher.failingTestMatcher:
            return line.beautify(pattern: .failingTest)
        case Matcher.uiFailingTestMatcher:
            return line.beautify(pattern: .uiFailingTest)
        case Matcher.restartingTestsMatcher:
            return line.beautify(pattern: .restartingTests)
        case Matcher.generateDsymMatcher:
            return line.beautify(pattern: .generateDsym)
        case Matcher.libtoolMatcher:
            return line.beautify(pattern: .libtool)
        case Matcher.linkingMatcher:
            return line.beautify(pattern: .linking)
        case Matcher.testCasePassedMatcher:
            return line.beautify(pattern: .testCasePassed)
        case Matcher.testCaseStartedMatcher:
            return line.beautify(pattern: .testCaseStarted)
        case Matcher.testCasePendingMatcher:
            return line.beautify(pattern: .testCasePending)
        case Matcher.testCaseMeasuredMatcher:
            return line.beautify(pattern: .testCaseMeasured)
        case Matcher.phaseSuccessMatcher:
            return line.beautify(pattern: .phaseSuccess)
        case Matcher.phaseScriptExecutionMatcher:
            return line.beautify(pattern: .phaseScriptExecution)
        case Matcher.processPchMatcher:
            return line.beautify(pattern: .processPch)
        case Matcher.processPchCommandMatcher:
            return line.beautify(pattern: .processPchCommand)
        case Matcher.preprocessMatcher:
            return line.beautify(pattern: .preprocess)
        case Matcher.pbxcpMatcher:
            return line.beautify(pattern: .pbxcp)
        case Matcher.processInfoPlistMatcher:
            return line.beautify(pattern: .processInfoPlist)
        case Matcher.testsRunCompletionMatcher:
            return line.beautify(pattern: .testsRunCompletion)
        case Matcher.testSuiteStartedMatcher:
            return line.beautify(pattern: .testSuiteStarted)
        case Matcher.testSuiteStartMatcher:
            return line.beautify(pattern: .testSuiteStart)
        case Matcher.tiffutilMatcher:
            return line.beautify(pattern: .tiffutil)
        case Matcher.touchMatcher:
            return line.beautify(pattern: .touch)
        case Matcher.writeFileMatcher:
            return line.beautify(pattern: .writeFile)
        case Matcher.writeAuxiliaryFilesMatcher:
            return line.beautify(pattern: .writeAuxiliaryFiles)
        case Matcher.compileWarningMatcher:
            return line.beautify(pattern: .compileWarning)
        case Matcher.ldWarningMatcher:
            return line.beautify(pattern: .ldWarning)
        case Matcher.genericWarningMatcher:
            return line.beautify(pattern: .genericWarning)
        case Matcher.willNotBeCodeSignedMatcher:
            return line.beautify(pattern: .willNotBeCodeSigned)
        case Matcher.clangErrorMatcher:
            return line.beautify(pattern: .clangError)
        case Matcher.checkDependenciesErrorsMatcher:
            return line.beautify(pattern: .checkDependenciesErrors)
        case Matcher.provisioningProfileRequiredMatcher:
            return line.beautify(pattern: .provisioningProfileRequired)
        case Matcher.noCertificateMatcher:
            return line.beautify(pattern: .noCertificate)
        case Matcher.compileErrorMatcher:
            return line.beautify(pattern: .compileError)
        case Matcher.cursorMatcher:
            return line.beautify(pattern: .cursor)
        case Matcher.fatalErrorMatcher:
            return line.beautify(pattern: .fatalError)
        case Matcher.fileMissingErrorMatcher:
            return line.beautify(pattern: .fileMissingError)
        case Matcher.ldErrorMatcher:
            return line.beautify(pattern: .ldError)
        case Matcher.linkerDuplicateSymbolsLocationMatcher:
            return line.beautify(pattern: .linkerDuplicateSymbolsLocation)
        case Matcher.linkerDuplicateSymbolsMatcher:
            return line.beautify(pattern: .linkerDuplicateSymbols)
        case Matcher.linkerUndefinedSymbolLocationMatcher:
            return line.beautify(pattern: .linkerUndefinedSymbolLocation)
        case Matcher.linkerUndefinedSymbolsMatcher:
            return line.beautify(pattern: .linkerUndefinedSymbols)
        case Matcher.podsErrorMatcher:
            return line.beautify(pattern: .podsError)
        case Matcher.symbolReferencedFromMatcher:
            return line.beautify(pattern: .symbolReferencedFrom)
        case Matcher.moduleIncludesErrorMatcher:
            return line.beautify(pattern: .moduleIncludesError)
        case Matcher.parallelTestCasePassedMatcher:
            return line.beautify(pattern: .parallelTestCasePassed)
        case Matcher.parallelTestCaseFailedMatcher:
            return line.beautify(pattern: .parallelTestCaseFailed)
        case Matcher.parallelTestingStartedMatcher:
            return line.beautify(pattern: .parallelTestingStarted)
        default:
            return nil
        }
    }

    func parseSummary(line: String) {
        let groups = line.capturedGroups(with: .executed)
        summary = TestSummary(
            testsCount: groups[0],
            failuresCount: groups[1],
            unexpectedCount: groups[2],
            time: groups[3])
    }
}
