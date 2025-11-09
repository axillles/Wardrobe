import SwiftUI
import PhotosUI

struct AddClothingItemView: View {
    @ObservedObject var viewModel: WardrobeViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var selectedCategory: ClothingItem.ClothingCategory = .tops
    @State private var brand: String = ""
    @State private var selectedSeason: ClothingItem.Season = .allYear
    @State private var showCamera = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Image picker
                    VStack(spacing: 16) {
                        if let imageData = selectedImageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 300)
                                .clipped()
                                .cornerRadius(16)
                        } else {
                            Rectangle()
                                .fill(Color(.systemGray6))
                                .frame(height: 300)
                                .cornerRadius(16)
                                .overlay(
                                    VStack(spacing: 12) {
                                        Image(systemName: "photo")
                                            .font(.system(size: 50))
                                            .foregroundColor(.gray)
                                        Text("Add Photo")
                                            .foregroundColor(.secondary)
                                    }
                                )
                        }
                        
                        HStack(spacing: 12) {
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                Label("Gallery", systemImage: "photo.on.rectangle")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                            }
                            .onChange(of: selectedItem) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        selectedImageData = data
                                    }
                                }
                            }
                            
                            Button(action: { showCamera = true }) {
                                Label("Camera", systemImage: "camera")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Form
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.system(size: 15, weight: .semibold))
                            
                            Picker("Category", selection: $selectedCategory) {
                                ForEach(ClothingItem.ClothingCategory.allCases, id: \.self) { category in
                                    Text(category.rawValue).tag(category)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Brand (Optional)")
                                .font(.system(size: 15, weight: .semibold))
                            
                            CustomTextField(placeholder: "e.g. Nike, Zara", text: $brand)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Season")
                                .font(.system(size: 15, weight: .semibold))
                            
                            Picker("Season", selection: $selectedSeason) {
                                ForEach(ClothingItem.Season.allCases, id: \.self) { season in
                                    Text(season.rawValue).tag(season)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.horizontal)
                    
                    PrimaryButton(title: "Add to Wardrobe") {
                        Task {
                            if let imageData = selectedImageData {
                                await viewModel.addItem(
                                    imageData: imageData,
                                    category: selectedCategory,
                                    brand: brand.isEmpty ? nil : brand,
                                    season: selectedSeason
                                )
                                dismiss()
                            }
                        }
                    }
                    .padding(.horizontal)
                    .disabled(selectedImageData == nil)
                }
                .padding(.vertical)
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showCamera) {
                ImagePicker(imageData: $selectedImageData)
            }
        }
    }
}

// Camera picker wrapper
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageData: Data?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.imageData = image.jpegData(compressionQuality: 0.8)
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
