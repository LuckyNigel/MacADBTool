//
//  ContentView.swift
//  MacADBTool
//
//  Created by Wensly on 2023/9/1.
//

import SwiftUI

struct ContentView: View {
    @State private var terminalOutput: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // Terminal Output View
            TextEditor(text: $terminalOutput)
                .font(.system(size: 14))
                .border(Color.white, width: 1)
                .padding()

            // Buttons
            HStack {
                Button("扫描") {
                    executeTerminalCommand("adb devices")
                }
                .padding()

                Button("投屏") {
                    executeTerminalCommand("scrcpy")
                }
                .padding()

                Button("退出") {
                    executeTerminalCommand("exit")
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
    }

    private func executeTerminalCommand(_ command: String) {
        let task = Process()
        task.launchPath = "/opt/homebrew/bin/adb"
        task.arguments = ["-c", command]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        let fileHandle = pipe.fileHandleForReading
        task.launch()

        let data = fileHandle.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            terminalOutput = output
        }
        task.waitUntilExit()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
