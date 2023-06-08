//
//  HomeView.swift
//  Jellycuts
//
//  Created by Taylor Lineman on 5/16/23.
//

import SwiftUI
import HydrogenReporter

struct HomeView: View, ErrorHandler {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var appearanceManager: AppearanceManager

    @FetchRequest(sortDescriptors: [ getSortKeyPath() ], animation: .default)
    private var projects: FetchedResults<Project>
    @State private var selectedProject: Project?
    
    @State internal var lastError: Error?
    @State internal var presentErrorView: Bool = false
    @State internal var shouldPresentView: Bool = true
    
    @State private var newJellycutName: String = ""
    @State private var presentCreateJellycut: Bool = false
    @State private var presentCreationConfirmation: Bool = false
    @State private var presentToolsSheet: Bool = false
    @State private var presentSettingsSheet: Bool = false

    var body: some View {
        NavigationSplitView {
            List(projects, selection: $selectedProject) { project in
                NavigationLink(value: project) {
                    Text(project.name ?? "")
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        presentSettingsSheet.toggle()
                    } label: {
                        Label(.settings)
                            .labelStyle(.iconOnly)
                    }

                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        presentToolsSheet.toggle()
                    } label: {
                        Label(.tools)
                            .labelStyle(.iconOnly)
                    }
                    Button {
                        presentCreationConfirmation.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .withToolsSheet(isPresented: $presentToolsSheet)
            .withSettingsSheet(isPresented: $presentSettingsSheet)
            .confirmationDialog("Create a new Jellycut", isPresented: $presentCreationConfirmation, actions: {
                Button("Create Jellycut") {
                    presentCreateJellycut.toggle()
                }
                Button("Add File") {
                    
                }
                Button("Import from an iCloud link") {
                    
                }
                Button("Import from Shortcuts App") {
                    
                }
            }, message: {
                Text("Select an option to create a new Jellycut 🪼")
            })
            .alert("Create a new Jellycut", isPresented: $presentCreateJellycut, actions: {
                TextField("Name", text: $newJellycutName)

                Button("Create", action: {
                    addItem(name: newJellycutName)
                })
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                Text("Please enter the name of the Jellycut.")
            })
            .alert("An Error Occurred", isPresented: $presentErrorView) {
                errorMessageButtons()
            } message: {
                errorMessageContent()
            }
        } detail: {
            if let selectedProject {
                DocumentView(project: selectedProject)
            }
        }
    }
    
    private static func getSortKeyPath() -> NSSortDescriptor {
        switch PreferenceManager.getProjectSort() {
        case .azName:
            return NSSortDescriptor(keyPath: \Project.name, ascending: true)
        case .zaName:
            return NSSortDescriptor(keyPath: \Project.name, ascending: false)
        case .creationOldestNewest:
            return NSSortDescriptor(keyPath: \Project.creationDate, ascending: true)
        case .creationNewestOldest:
            return NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
        case .recentlyOpened:
            return NSSortDescriptor(keyPath: \Project.lastOpened, ascending: false)
        case .leastRecentlyOpened:
            return NSSortDescriptor(keyPath: \Project.lastOpened, ascending: true)
        }
    }
    
    private func addItem(name: String) {
        newJellycutName = ""
        withAnimation {
            do {
                try DocumentHandling.createJellyDocument(name: name, viewContext: viewContext)
            } catch {
                handle(error: error)
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            do {
                try DocumentHandling.deleteProjects(offsets: offsets, viewContext: viewContext, projects: projects)
            } catch {
                handle(error: error)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

