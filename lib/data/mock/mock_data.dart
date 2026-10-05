/// Mock data for PlantHub Bangladesh UI prototyping
/// All data is static/dummy — replace with real API calls in production.

import '../../features/marketplace/models/plant_model.dart';
import '../../features/nursery/models/nursery_model.dart';
import '../../features/consultation/models/expert_model.dart';
import '../../features/orders/models/order_model.dart';
import '../../features/knowledge_hub/models/article_model.dart';

export '../../features/marketplace/models/plant_model.dart';
export '../../features/nursery/models/nursery_model.dart';
export '../../features/consultation/models/expert_model.dart';
export '../../features/orders/models/order_model.dart';
export '../../features/knowledge_hub/models/article_model.dart';





abstract class MockData {
  // ── Unsplash plant image URLs ─────────────────────────────────────────────────
  static const List<String> _plantImages = [
    'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?w=400&q=80',
    'https://images.unsplash.com/photo-1518335935020-cfd6580c1ab4?w=400&q=80',
    'https://images.unsplash.com/photo-1509423350716-97f9360b4e09?w=400&q=80',
    'https://images.unsplash.com/photo-1463154545680-d59320fd685d?w=400&q=80',
    'https://images.unsplash.com/photo-1537944434965-cf4679d1a598?w=400&q=80',
    'https://images.unsplash.com/photo-1592150621744-aca64f48394a?w=400&q=80',
    'https://images.unsplash.com/photo-1494891848038-7bd202a2afeb?w=400&q=80',
    'https://images.unsplash.com/photo-1569880153113-76e33fc52d5f?w=400&q=80',
    'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400&q=80',
    'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?w=400&q=80',
  ];

  static const List<String> _nurseryCovers = [
    'https://images.unsplash.com/photo-1585320806297-9794b3e4aaae?w=800&q=80',
    'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
    'https://images.unsplash.com/photo-1465146344425-f00d5f5c8f07?w=800&q=80',
  ];

  // ── Plants ────────────────────────────────────────────────────────────────────
  static final List<MockPlant> plants = [
    MockPlant(
      id: 'p1',
      name: 'Monstera Deliciosa',
      nameBn: 'মনস্টেরা',
      imageUrl: _plantImages[0],
      price: 850,
      originalPrice: 1200,
      nurseryName: 'Green Valley Nursery',
      nurseryVerified: true,
      nurseryPremium: true,
      rating: 4.8,
      reviewCount: 234,
      sold: 1250,
      category: 'ইনডোর',
      inWishlist: true,
      careLevel: 'সহজ',
      sunlight: 'পরোক্ষ আলো',
      water: 'সপ্তাহে একবার',
    ),
    MockPlant(
      id: 'p2',
      name: 'Peace Lily',
      nameBn: 'পিস লিলি',
      imageUrl: _plantImages[1],
      price: 450,
      nurseryName: 'Dhaka Plant House',
      nurseryVerified: true,
      rating: 4.6,
      reviewCount: 178,
      sold: 890,
      category: 'ইনডোর',
      careLevel: 'সহজ',
      sunlight: 'কম আলো',
      water: 'সপ্তাহে দুইবার',
    ),
    MockPlant(
      id: 'p3',
      name: 'Fiddle Leaf Fig',
      nameBn: 'ফিডেল লিফ',
      imageUrl: _plantImages[2],
      price: 1800,
      originalPrice: 2200,
      nurseryName: 'Urban Greens BD',
      nurseryVerified: true,
      nurseryPremium: false,
      rating: 4.5,
      reviewCount: 96,
      sold: 430,
      category: 'ইনডোর',
      careLevel: 'মাঝারি',
      sunlight: 'উজ্জ্বল আলো',
      water: 'সপ্তাহে একবার',
    ),
    MockPlant(
      id: 'p4',
      name: 'Bougainvillea',
      nameBn: 'বোগেনভিলা',
      imageUrl: _plantImages[3],
      price: 320,
      nurseryName: 'Chittagong Florals',
      nurseryVerified: false,
      rating: 4.3,
      reviewCount: 55,
      sold: 215,
      category: 'আউটডোর',
      careLevel: 'মাঝারি',
      sunlight: 'পূর্ণ রোদ',
      water: 'নিয়মিত',
    ),
    MockPlant(
      id: 'p5',
      name: 'Cactus Mix',
      nameBn: 'ক্যাকটাস মিক্স',
      imageUrl: _plantImages[4],
      price: 180,
      nurseryName: 'Green Valley Nursery',
      nurseryVerified: true,
      nurseryPremium: true,
      rating: 4.7,
      reviewCount: 312,
      sold: 2100,
      category: 'ক্যাকটাস',
      careLevel: 'সহজ',
      sunlight: 'পূর্ণ রোদ',
      water: 'মাসে একবার',
    ),
    MockPlant(
      id: 'p6',
      name: 'Rose Bush',
      nameBn: 'গোলাপ',
      imageUrl: _plantImages[5],
      price: 650,
      originalPrice: 800,
      nurseryName: 'Rajshahi Flower Garden',
      nurseryVerified: true,
      rating: 4.9,
      reviewCount: 567,
      sold: 3400,
      category: 'ফুল গাছ',
      inWishlist: true,
      careLevel: 'কঠিন',
      sunlight: 'পূর্ণ রোদ',
      water: 'প্রতিদিন',
    ),
    MockPlant(
      id: 'p7',
      name: 'Snake Plant',
      nameBn: 'স্নেক প্ল্যান্ট',
      imageUrl: _plantImages[6],
      price: 290,
      nurseryName: 'Dhaka Plant House',
      nurseryVerified: true,
      rating: 4.7,
      reviewCount: 445,
      sold: 1800,
      category: 'ইনডোর',
      careLevel: 'সহজ',
      sunlight: 'যেকোনো আলো',
      water: 'দুই সপ্তাহে একবার',
    ),
    MockPlant(
      id: 'p8',
      name: 'Bamboo Palm',
      nameBn: 'বাঁশ পাম',
      imageUrl: _plantImages[7],
      price: 2400,
      nurseryName: 'Urban Greens BD',
      nurseryVerified: true,
      nurseryPremium: false,
      rating: 4.4,
      reviewCount: 88,
      sold: 240,
      category: 'ইনডোর',
      careLevel: 'মাঝারি',
      sunlight: 'উজ্জ্বল পরোক্ষ',
      water: 'সপ্তাহে দুইবার',
    ),
  ];

  // ── Nurseries ──────────────────────────────────────────────────────────────────
  static final List<MockNursery> nurseries = [
    MockNursery(
      id: 'n1',
      name: 'Green Valley Nursery',
      location: 'মিরপুর, ঢাকা',
      imageUrl: 'https://images.unsplash.com/photo-1520412099551-62b6bafeb5bb?w=200&q=80',
      coverUrl: _nurseryCovers[0],
      rating: 4.8,
      reviewCount: 1234,
      productCount: 245,
      verified: true,
      premium: true,
      description: 'ঢাকার সেরা নার্সারিগুলোর একটি। ১৫+ বছরের অভিজ্ঞতায় আমরা আপনার বাড়িকে সবুজ করে তুলি।',
    ),
    MockNursery(
      id: 'n2',
      name: 'Dhaka Plant House',
      location: 'ধানমন্ডি, ঢাকা',
      imageUrl: 'https://images.unsplash.com/photo-1553361371-9b22f78e8b1d?w=200&q=80',
      coverUrl: _nurseryCovers[1],
      rating: 4.6,
      reviewCount: 856,
      productCount: 180,
      verified: true,
      premium: false,
      description: 'ইনডোর প্ল্যান্টের বিশাল কালেকশন। বাড়ি ও অফিস ডেকোর প্যাকেজ পাওয়া যায়।',
    ),
    MockNursery(
      id: 'n3',
      name: 'Urban Greens BD',
      location: 'গুলশান, ঢাকা',
      imageUrl: 'https://images.unsplash.com/photo-1503789146722-cf137a3c0fea?w=200&q=80',
      coverUrl: _nurseryCovers[2],
      rating: 4.5,
      reviewCount: 623,
      productCount: 120,
      verified: true,
      premium: false,
      description: 'আধুনিক ও ট্রেন্ডি প্ল্যান্ট কালেকশন। প্রতি সপ্তাহে নতুন স্টক আসে।',
    ),
  ];

  // ── Experts ───────────────────────────────────────────────────────────────────
  static final List<MockExpert> experts = [
    MockExpert(
      id: 'e1',
      name: 'ড. সাদিয়া ইসলাম',
      title: 'Botanist & Plant Pathologist',
      imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80',
      rating: 4.9,
      consultations: 1456,
      specialty: 'রোগ সনাক্তকরণ',
      pricePerSession: 500,
      available: true,
      skills: ['রোগ নির্ণয়', 'কীটপতঙ্গ ব্যবস্থাপনা', 'জৈব সার'],
    ),
    MockExpert(
      id: 'e2',
      name: 'রাহেলা খানম',
      title: 'Horticulture Expert',
      imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&q=80',
      rating: 4.7,
      consultations: 987,
      specialty: 'ইনডোর প্ল্যান্ট কেয়ার',
      pricePerSession: 350,
      available: true,
      skills: ['ইনডোর গার্ডেনিং', 'মাটি প্রস্তুতি', 'বায়ু বিশুদ্ধকারী গাছ'],
    ),
    MockExpert(
      id: 'e3',
      name: 'আরিফ হোসেন',
      title: 'Landscape Designer',
      imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&q=80',
      rating: 4.6,
      consultations: 654,
      specialty: 'ল্যান্ডস্কেপ ডিজাইন',
      pricePerSession: 800,
      available: false,
      skills: ['গার্ডেন ডিজাইন', 'বনসাই', 'ছাদ বাগান'],
    ),
    MockExpert(
      id: 'e4',
      name: 'নাফিসা আক্তার',
      title: 'Organic Farming Specialist',
      imageUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=200&q=80',
      rating: 4.8,
      consultations: 1102,
      specialty: 'জৈব চাষ',
      pricePerSession: 450,
      available: true,
      skills: ['জৈব সার', 'কম্পোস্ট', 'পোকামাকড় প্রতিরোধ'],
    ),
  ];

  // ── Orders ────────────────────────────────────────────────────────────────────
  static final List<MockOrder> orders = [
    MockOrder(
      id: 'ORD-2026-001',
      plantName: 'Monstera Deliciosa',
      plantImage: _plantImages[0],
      quantity: 2,
      total: 1700,
      status: 'Shipped',
      nurseryName: 'Green Valley Nursery',
      date: DateTime(2026, 8, 15),
    ),
    MockOrder(
      id: 'ORD-2026-002',
      plantName: 'Peace Lily',
      plantImage: _plantImages[1],
      quantity: 1,
      total: 450,
      status: 'Delivered',
      nurseryName: 'Dhaka Plant House',
      date: DateTime(2026, 8, 10),
    ),
    MockOrder(
      id: 'ORD-2026-003',
      plantName: 'Cactus Mix',
      plantImage: _plantImages[4],
      quantity: 3,
      total: 540,
      status: 'Pending',
      nurseryName: 'Green Valley Nursery',
      date: DateTime(2026, 8, 18),
    ),
    MockOrder(
      id: 'ORD-2026-004',
      plantName: 'Rose Bush',
      plantImage: _plantImages[5],
      quantity: 1,
      total: 650,
      status: 'Confirmed',
      nurseryName: 'Rajshahi Flower Garden',
      date: DateTime(2026, 8, 17),
    ),
  ];

  // ── Articles / Knowledge Hub ──────────────────────────────────────────────────
  static final List<MockArticle> articles = [
    MockArticle(
      id: 'a1',
      title: 'Top 10 Indoor Plants for Bangladesh',
      titleBn: 'বাংলাদেশের জন্য সেরা ১০টি ইনডোর গাছ',
      imageUrl: 'https://images.unsplash.com/photo-1463154545680-d59320fd685d?w=600&q=80',
      category: 'গাইড',
      author: 'ড. সাদিয়া ইসলাম',
      readTime: '5 মিনিট',
      date: DateTime(2026, 8, 12),
      views: 12400,
    ),
    MockArticle(
      id: 'a2',
      title: 'How to Detect Root Rot Early',
      titleBn: 'শিকড় পচন সময়মতো চেনার উপায়',
      imageUrl: 'https://images.unsplash.com/photo-1509423350716-97f9360b4e09?w=600&q=80',
      category: 'রোগ গাইড',
      author: 'রাহেলা খানম',
      readTime: '4 মিনিট',
      date: DateTime(2026, 8, 8),
      views: 8900,
    ),
    MockArticle(
      id: 'a3',
      title: 'Monsoon Care Tips for Your Garden',
      titleBn: 'বর্ষায় গাছের যত্নের টিপস',
      imageUrl: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=600&q=80',
      category: 'মৌসুমী টিপস',
      author: 'আরিফ হোসেন',
      readTime: '6 মিনিট',
      date: DateTime(2026, 8, 1),
      views: 15600,
    ),
    MockArticle(
      id: 'a4',
      title: 'Making Compost at Home',
      titleBn: 'বাড়িতে কম্পোস্ট সার তৈরির সহজ পদ্ধতি',
      imageUrl: 'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?w=600&q=80',
      category: 'সার গাইড',
      author: 'নাফিসা আক্তার',
      readTime: '7 মিনিট',
      date: DateTime(2026, 7, 28),
      views: 21000,
    ),
  ];

  // ── Nursery Dashboard Mock Stats ─────────────────────────────────────────────
  static Map<String, dynamic> get nurseryDashboardStats => {
    'todaySales': 12450.0,
    'pendingOrders': 8,
    'lowStockCount': 5,
    'totalProducts': 245,
    'monthlyRevenue': 185000.0,
    'totalCustomers': 1248,
    'weeklyOrders': [12, 19, 8, 24, 18, 32, 27],
    'monthlyRevenueSeries': [85000.0, 120000.0, 95000.0, 140000.0, 110000.0, 185000.0],
    'topProducts': [
      {'name': 'Monstera', 'sold': 124, 'revenue': 105400.0},
      {'name': 'Peace Lily', 'sold': 98, 'revenue': 44100.0},
      {'name': 'Snake Plant', 'sold': 87, 'revenue': 25230.0},
    ],
  };

  // ── Banner Data ───────────────────────────────────────────────────────────────
  static final List<Map<String, String>> banners = [
    {
      'title': 'বর্ষার বিশেষ অফার',
      'subtitle': 'সব ইনডোর গাছে ২০% ছাড়',
      'image': 'https://images.unsplash.com/photo-1465146344425-f00d5f5c8f07?w=800&q=80',
      'cta': 'এখনই কিনুন',
    },
    {
      'title': 'নতুন কালেকশন এসেছে',
      'subtitle': 'এক্সক্লুসিভ সুকুলেন্ট প্যাক',
      'image': 'https://images.unsplash.com/photo-1535395098941-4f22e4d14e5c?w=800&q=80',
      'cta': 'দেখুন',
    },
    {
      'title': 'এক্সপার্ট পরামর্শ',
      'subtitle': 'প্রথম সেশন ৫০% ছাড়ে',
      'image': 'https://images.unsplash.com/photo-1585320806297-9794b3e4aaae?w=800&q=80',
      'cta': 'বুকিং করুন',
    },
  ];
}
