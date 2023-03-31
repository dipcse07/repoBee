//
//  ContentView.swift
//  repoWatcher
//
//  Created by MD SAZID HASAN DIP on 2023/02/27.
//

import SwiftUI

struct ContentView: View {
    @State private var newRepo = ""
    @State private var repos: [String] = []

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Ex. sallen0400/swift-news", text: $newRepo)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)

                    Button {
                        if !repos.contains(newRepo) && !newRepo.isEmpty{
                            repos.append(newRepo)
                            UserDefaults.shared.set(repos, forKey: UserDefaults.repoKey)
                            print(UserDefaults.shared.value(forKey: UserDefaults.repoKey)!)
                        }else {
                            print("repo already exists or name is empty")
                        }

                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.green)
                    }
                }
                .padding()

                VStack(alignment: .leading) {
                    Text("Saved Repos")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.leading)

                    List(repos, id: \.self) { repo in
                        Text(repo)
                            .swipeActions {
                                Button("Delete") {
                                    if repos.count > 1 {
                                        repos.removeAll{$0 == repo}
                                        UserDefaults.shared.set(repos, forKey: UserDefaults.repoKey)
                                    }
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .navigationTitle("Repo List")
            .onAppear{
                guard let retrivedRepos = UserDefaults.shared.value(forKey: UserDefaults.repoKey) as? [String] else {let defaultValue = ["sallen0400/swift-news"]
                    UserDefaults.shared.set(defaultValue, forKey: UserDefaults.repoKey)
                    repos = defaultValue
                    return
                    
                }
                repos = retrivedRepos
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
