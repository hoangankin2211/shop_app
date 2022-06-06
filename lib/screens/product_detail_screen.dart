import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/detail_screen.dart';
import '../widgets/related_screen.dart';
import '../widgets/reviews_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail-screen';
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context)!.settings.arguments as String;
    final productData = Provider.of<ProductProvider>(context, listen: false)
        .findById(productID);

    return Scaffold(
      appBar: AppBar(
        title: Text(productData.title),
        toolbarHeight: 40,
      ),
      body: Column(
        children: [
          Container(
            height: 20,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.black26),
            ),
            child: TabBar(
              tabs: const [
                Tab(child: Text('Detail')),
                Tab(child: Text('Reviews')),
                Tab(child: Text('Related')),
              ],
              indicator: const BoxDecoration(
                color: Color.fromARGB(255, 76, 111, 128),
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              controller: tabController,
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                DetailScreen(product: productData),
                const ReviewsScreen(),
                const RelatedScreen()
              ],
              controller: tabController,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
