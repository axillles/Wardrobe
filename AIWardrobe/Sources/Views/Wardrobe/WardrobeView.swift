import SwiftUI
import PhotosUI

struct WardrobeView: View {
    @ObservedObject var coordinator: AppCoordinator
    @StateObject private var viewModel = WardrobeViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.clothingItems.isEmpty && !viewModel.isLoading {
                    EmptyWardrobeView {
                        viewModel.showingAddItem = true
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Category filter
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    CategoryFilterButton(
                                        title: "All",
                                        isSelected: viewModel.selectedCategory == nil
                                    ) {
                                        viewModel.selectedCategory = nil
                                    }
                                    
                                    ForEach(ClothingItem.ClothingCategory.allCases, id: \.self) { category in
                                        CategoryFilterButton(
                                            title: category.rawValue,
                                            isSelected: viewModel.selectedCategory == category
                                        ) {
                                            viewModel.selectedCategory = category
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Items grid
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(viewModel.filteredItems) { item in
                                    ClothingItemCard(item: item)
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                Task {
                                                    await viewModel.deleteItem(item)
                                                }
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("My Wardrobe")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showingAddItem = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddItem) {
                AddClothingItemView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchItems()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
    }
}

struct EmptyWardrobeView: View {
    let onAddItem: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "tshirt")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("Your wardrobe is empty")
                    .font(.system(size: 24, weight: .semibold))
                
                Text("Start adding your clothing items to get personalized outfit suggestions")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            PrimaryButton(title: "Add First Item") {
                onAddItem()
            }
            .frame(width: 200)
        }
    }
}

struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? Color.black : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}
