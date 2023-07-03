//
//  ActivityView.swift
//  Mist
//
//  Created by Nindi Gill on 29/6/2022.
//

import Combine
import SwiftUI

struct ActivityView: View {
    // swiftlint:disable:next weak_delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate: AppDelegate
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    @AppStorage("enableNotifications")
    private var enableNotifications: Bool = false
    @AppStorage("showInFinder")
    private var showInFinder: Bool = false
    var downloadType: DownloadType
    var imageName: String
    var name: String
    var version: String
    var build: String
    var beta: Bool
    var destinationURL: URL?
    @ObservedObject var taskManager: TaskManager
    @State private var currentTaskId: String?
    @State private var value: Double = 0
    @State private var showAlert: Bool = false
    @State private var alertType: ProgressAlertType = .cancel
    @State private var error: MistError?
    @State private var degrees: CGFloat = 0
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher> = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    private let width: CGFloat = 420
    private let height: CGFloat = 640
    private var bootableInstaller: Bool {
        taskManager.taskGroups.map { $0.section }.contains(.bootableInstaller)
    }
    private var venturaOrOlder: Bool {
        !ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 14, minorVersion: 0, patchVersion: 0))
    }
    private var buttonText: String {
        switch taskManager.currentState {
        case .pending, .inProgress:
            return "Cancel"
        case .complete, .error:
            return "Close"
        }
    }

    var body: some View {
        // swiftlint:disable:next closure_body_length
        VStack(spacing: 0) {
            ActivityHeaderView(imageName: imageName, name: name, version: version, build: build, beta: beta)
            Divider()
            ScrollViewReader { proxy in
                List {
                    ForEach(taskManager.taskGroups, id: \.section) { taskGroup in
                        Section(header: ActivitySectionHeaderView(section: taskGroup.section)) {
                            ForEach(taskGroup.tasks.indices, id: \.self) { index in
                                VStack {
                                    ActivityRowView(state: taskGroup.tasks[index].state, description: taskGroup.tasks[index].currentDescription, degrees: degrees)
                                    if taskGroup.tasks[index].type == .download && taskGroup.tasks[index].state != .pending,
                                        let size: UInt64 = taskGroup.tasks[index].downloadSize {
                                        ActivityProgressView(state: taskGroup.tasks[index].state, value: value, size: size)
                                    }
                                    if venturaOrOlder && index != taskGroup.tasks.count {
                                        Divider()
                                    }
                                }
                                .id("\(taskGroup.section.id).\(index)")
                            }
                        }
                    }
                }
                .onChange(of: currentTaskId) { id in
                    withAnimation(.easeOut(duration: 1)) {
                        proxy.scrollTo(id, anchor: .center)
                    }
                }
            }
            Divider()
            HStack {
                Toggle("Show in Finder upon completion", isOn: $showInFinder)
                Spacer()
                Button(buttonText) {
                    stop()
                }
                .keyboardShortcut(.escape, modifiers: [])
            }
            .padding()
        }
        .interactiveDismissDisabled()
        .frame(width: width, height: height)
        .onAppear {
            Task {
                await performTasks()
            }
        }
        .onReceive(timer) { _ in
            value = DownloadManager.shared.currentValue

            if degrees == 0 {
                degrees = 360
            }
        }
        .alert(isPresented: $showAlert) {
            switch alertType {
            case .cancel:
                return Alert(
                    title: Text("Are you sure you want to cancel?"),
                    message: Text("This process cannot be resumed once it has been cancelled."),
                    primaryButton: .default(Text("Resume")),
                    secondaryButton: .destructive(Text("Cancel"), action: { cancel() })
                )
            case .error:
                return Alert(
                    title: Text("An error has occurred!"),
                    message: Text(error?.description ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    private func performTasks() async {

        for taskGroupIndex in taskManager.taskGroups.indices {
            for taskIndex in taskManager.taskGroups[taskGroupIndex].tasks.indices {
                currentTaskId = "\(taskManager.taskGroups[taskGroupIndex].section.id).\(taskIndex)"
                degrees = 0
                taskManager.taskGroups[taskGroupIndex].tasks[taskIndex].state = .inProgress
                timer = timer.upstream.autoconnect()
                taskManager.task = Task(operation: taskManager.taskGroups[taskGroupIndex].tasks[taskIndex].operation)
                let result: Result<Any, Error> = await taskManager.task.result
                timer.upstream.connect().cancel()
                degrees = 0

                switch result {
                case .success:
                    taskManager.taskGroups[taskGroupIndex].tasks[taskIndex].state = .complete
                case .failure(let failure):
                    if checkForUserCancellation(failure) {
                        return
                    }

                    taskManager.taskGroups[taskGroupIndex].tasks[taskIndex].state = .error
                    self.error = failure as? MistError ?? MistError.generalError(failure.localizedDescription)
                    alertType = .error
                    showAlert = true

                    if enableNotifications {
                        sendNotification(for: downloadType, name: name, version: version, build: build, success: false)
                    }

                    return
                }
            }
        }

        if enableNotifications {
            sendNotification(for: downloadType, name: name, version: version, build: build, success: true)
        }

        if showInFinder {

            guard let url: URL = destinationURL else {
                return
            }

            NSWorkspace.shared.selectFile(url.path, inFileViewerRootedAtPath: "")
        }
    }

    private func checkForUserCancellation(_ failure: Error) -> Bool {

        if failure as? CancellationError != nil {
            return true
        }

        guard let error: MistError = failure as? MistError else {
            return false
        }

        switch error {
        case .userCancelled:
            return true
        case .invalidTerminationStatus(let status, _, _):

            // SIGTERM triggered via Privileged Helper Tool due to user cancellation
            guard status == 15 else {
                return false
            }

            return true
        default:
            return false
        }
    }

    private func sendNotification(for type: DownloadType, name: String, version: String, build: String, success: Bool) {
        let title: String

        if bootableInstaller {
            title = "Bootable Installer \(success ? "created" : "failed")"
        } else {
            title = "\(type.description) \(success ? "downloaded" : "failed")"
        }

        let body: String = "\(name) \(version) (\(build))"
        appDelegate.sendUpdateNotification(title: title, body: body, success: success, url: destinationURL)
    }

    private func stop() {

        switch taskManager.currentState {
        case .pending, .inProgress:
            alertType = .cancel
            showAlert.toggle()
        case .complete, .error:
            presentationMode.wrappedValue.dismiss()
        }
    }

    private func cancel() {
        timer.upstream.connect().cancel()
        DownloadManager.shared.cancelTask()
        taskManager.cancelTask()
        ShellExecutor.shared.terminate()
        Task { try await ProcessKiller.kill() }
        presentationMode.wrappedValue.dismiss()
    }
}

struct ActivityView_Previews: PreviewProvider {
    static let firmware: Firmware = .example
    static let installer: Installer = .example

    static var previews: some View {
        ActivityView(downloadType: .firmware, imageName: firmware.imageName, name: firmware.name, version: firmware.version, build: firmware.build, beta: false, taskManager: .shared)
        ActivityView(downloadType: .installer, imageName: installer.imageName, name: installer.name, version: installer.version, build: installer.build, beta: false, taskManager: .shared)
    }
}
