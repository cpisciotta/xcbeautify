#if compiler(>=6.0)
public import ArgumentParser
#else
import ArgumentParser
#endif
import XcbeautifyLib

#if compiler(>=6.0)
extension XcbeautifyLib.Renderer: @retroactive ExpressibleByArgument { }
#else
extension XcbeautifyLib.Renderer: ExpressibleByArgument { }
#endif
