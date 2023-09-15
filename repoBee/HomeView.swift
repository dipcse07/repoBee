

//  HomeView.swift

//
//  Created by intel on 2023/06/29.
//

import SwiftUI

struct HomeView: View {
    @State private var newRepo = ""
    @State private var repos: [String] = []
    @State private var showsAlert: Bool = false

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
                            print("Repo already exists or name is empty")
                            self.showsAlert = true
                        }

                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.green)
                    }
                    .alert(isPresented: self.$showsAlert) {
                        Alert(title: Text("Repo already exists or name is empty"))
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
