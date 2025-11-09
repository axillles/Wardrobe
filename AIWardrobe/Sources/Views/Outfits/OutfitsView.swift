import SwiftUI

struct OutfitsView: View {
    @ObservedObject var coordinator: AppCoordinator
    @StateObject private var viewModel = OutfitViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.outfits.isEmpty && !viewModel.isLoading {
                    EmptyOutfitsView {
                        Task {
                            await viewModel.generateSuggestions()
                        }
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.outfits) { outfit in
                                OutfitCard(outfit: outfit)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            Task {
                                                await viewModel.deleteOutfit(outfit)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Outfits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await viewModel.generateSuggestions()
                        }
                    }) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 22))
                            .foregroundColor(.black)
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .task {
                await viewModel.fetchOutfits()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
        }
    }
}

struct EmptyOutfitsView: View {
    let onGenerate: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "sparkles")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No outfits yet")
                    .font(.system(size: 24, weight: .semibold))
                
                Text("Generate AI-powered outfit suggestions based on your wardrobe")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            PrimaryButton(title: "Generate Outfit") {
                onGenerate()
            }
            .frame(width: 220)
        }
    }
}

struct OutfitCard: View {
    let outfit: Outfit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Outfit items preview
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                
                VStack(spacing: 8) {
                    Text("\(outfit.items.count) items")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                }
                .padding(8)
            }
            .frame(height: 180)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(outfit.occasion ?? "Casual Outfit")
                    .font(.system(size: 16, weight: .semibold))
                
                Text("\(outfit.items.count) items")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
    }
}
