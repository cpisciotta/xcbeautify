#if compiler(>=6.0)
public import ArgumentParser
#else
import ArgumentParser
#endif
import XcbeautifyLib

extension XcbeautifyLib.Renderer: ExpressibleByArgument { }
