import 'package:flutter/material.dart';

import 'package:computology/features/catalog/data/category.dart';
import 'package:computology/features/catalog/data/product.dart';
import 'package:computology/features/profile/data/user_profile.dart';

class MockData {
  static const List<String> bannerImages = [
    'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1516387938699-a93567ec168e?auto=format&fit=crop&w=1200&q=80',
  ];

  static const List<Category> categories = [
    Category(id: 'laptops', name: 'Laptops', icon: Icons.laptop_mac),
    Category(id: 'desktops', name: 'Desktop PCs', icon: Icons.desktop_windows),
    Category(id: 'monitors', name: 'Monitors', icon: Icons.monitor),
    Category(id: 'keyboards', name: 'Keyboards', icon: Icons.keyboard),
    Category(id: 'mouse', name: 'Mouse', icon: Icons.mouse),
    Category(id: 'accessories', name: 'Accessories', icon: Icons.headphones),
  ];

  static const List<Product> featuredProducts = [
    Product(
      id: 'p1',
      name: 'MacBook Pro M1',
      imageUrl:
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80',
      images: [
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1516387938699-a93567ec168e?auto=format&fit=crop&w=1200&q=80',
      ],
      price: 1499.0,
      originalPrice: 1749.0,
      rating: 4.7,
      category: 'Laptops',
      tags: ['NEW GENERATION'],
      description:
          'The ultimate gaming and productivity laptop with a powerful CPU and GPU, advanced cooling, and premium display.',
      specs: {
        'CORES / THREADS': '8c / 16t',
        'BASE / BOOST CLOCK': '3.2 / 5.0 GHz',
        'TOTAL CACHE (L2+L3)': '32 MB',
        'DEFAULT TDP': '95W',
      },
    ),
    Product(
      id: 'p2',
      name: 'Apple MacBook Pro 14',
      imageUrl:
          'https://www.apple.com/newsroom/images/2025/10/apple-unveils-new-14-inch-macbook-pro-powered-by-the-m5-chip/tile/Apple-MacBook-Pro-14-in-hero-251015-lp.jpg.news_app_ed.jpg',
      price: 1999.0,
      rating: 4.9,
      category: 'Laptops',
    ),
    Product(
      id: 'p3',
      name: 'MSI Raider GE78',
      imageUrl:
          'https://images.unsplash.com/photo-1516387938699-a93567ec168e?auto=format&fit=crop&w=800&q=80',
      price: 2199.0,
      rating: 4.6,
      category: 'Laptops',
    ),
    Product(
      id: 'p4',
      name: 'ASUS ROG Zephyrus G16',
      imageUrl:
          'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=800&q=80',
      price: 1799.0,
      rating: 4.8,
      category: 'Laptops',
    ),
  ];

  static const UserProfile defaultProfile = UserProfile(
    fullName: 'Taylor Morgan',
    email: 'taylor.morgan@computology.com',
    photoUrl:
        'https://avatars.githubusercontent.com/u/152673822?v=4',
  );
}
