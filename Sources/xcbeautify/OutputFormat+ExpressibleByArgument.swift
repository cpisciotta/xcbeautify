//
// OutputFormat+ExpressibleByArgument.swift
//
// Copyright (c) 2025 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

#if compiler(>=6.0)
public import ArgumentParser
#else
import ArgumentParser
#endif
import XcbeautifyLib

extension XcbeautifyLib.Renderer: ExpressibleByArgument { }
