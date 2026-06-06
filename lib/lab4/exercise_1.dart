import 'package:flutter/material.dart';

/// Exercise 1 - Core Widgets: Text, Image, Icon, Card, ListTile
/// This widget demonstrates how to display information using Flutter's essential display widgets.
class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 1: Core Widgets'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Headline Text (Tiêu đề chính)
              // Demonstrates standard text styling, weight, letter spacing, and size
              const Text(
                'Classic Leather Camera Bag',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              
              // Sub-headline for context
              Text(
                'Premium vintage protective case for DSLR and mirrorless cameras.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Image.network (Hình ảnh từ Internet)
              // Renders an image from a URL, wrapped in a ClipRDoc for rounded corners
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=800&q=80',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // Fallback when image loading fails
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, size: 50, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Failed to load image'),
                        ],
                      ),
                    );
                  },
                  // Loading placeholder
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 250,
                      color: Colors.grey[100],
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Headline for the specs section
              const Text(
                'Key Specifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              // 3. Card & ListTile (Thẻ chứa danh sách thông tin)
              // Using Card for elevated container design and ListTile to organize icon, title, and subtitle
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Item 1: Material (Chất liệu)
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.indigoAccent,
                        child: Icon(Icons.layers, color: Colors.white), // Icon widget
                      ),
                      title: const Text('Material'),
                      subtitle: const Text('Genuine Top Grain Leather'),
                      trailing: Icon(Icons.check_circle, color: Colors.green[600]),
                    ),
                    const Divider(height: 1), // Thin separator line
                    
                    // Item 2: Waterproofing (Chống nước)
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.indigoAccent,
                        child: Icon(Icons.water_drop, color: Colors.white), // Icon widget
                      ),
                      title: const Text('Weatherproof'),
                      subtitle: const Text('Water-resistant wax coating'),
                      trailing: Icon(Icons.check_circle, color: Colors.green[600]),
                    ),
                    const Divider(height: 1),
                    
                    // Item 3: Warranty (Bảo hành)
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.indigoAccent,
                        child: Icon(Icons.verified, color: Colors.white), // Icon widget
                      ),
                      title: const Text('Warranty'),
                      subtitle: const Text('5-Year International Manufacturer Warranty'),
                      trailing: Icon(Icons.info_outline, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Quick action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to Wishlist!')),
                    );
                  },
                  icon: const Icon(Icons.favorite),
                  label: const Text('Add to Wishlist'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
