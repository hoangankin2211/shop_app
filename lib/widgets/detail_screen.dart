import 'package:flutter/material.dart';
import '../models/product.dart';

class DetailScreen extends StatelessWidget {
  final Product product;
  const DetailScreen({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: constraints.maxHeight * 0.45,
                alignment: Alignment.center,
                child: Image.network(product.imageUrl),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15, bottom: 10),
                width: constraints.maxWidth * 0.9,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        width: 1, color: Color.fromARGB(255, 202, 199, 199)),
                    bottom: BorderSide(
                        width: 1, color: Color.fromARGB(255, 202, 199, 199)),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Option',
                            style: TextStyle(color: Colors.black54),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_drop_down),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 20),
                      width: 1,
                      height: 30,
                      color: Colors.grey[350],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Size',
                            style: TextStyle(color: Colors.black54),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_drop_down),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                product.title,
                style: const TextStyle(fontFamily: 'Raleway', fontSize: 13),
              ),
              SizedBox(
                width: constraints.maxWidth * 0.9,
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$' +
                                (((product.price - 5) * 100).round() / 100)
                                    .toString(),
                            style: const TextStyle(
                                fontSize: 22,
                                color: Colors.red,
                                fontWeight: FontWeight.w100),
                          ),
                          Text(
                            '\$' + product.price.toString(),
                            style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 20,
                            child: IconButton(
                              onPressed: () {},
                              iconSize: 17,
                              icon:
                                  const Icon(Icons.star, color: Colors.yellow),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            child: IconButton(
                              onPressed: () {},
                              iconSize: 17,
                              icon:
                                  const Icon(Icons.star, color: Colors.yellow),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            child: IconButton(
                              onPressed: () {},
                              iconSize: 17,
                              icon:
                                  const Icon(Icons.star, color: Colors.yellow),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            child: IconButton(
                              onPressed: () {},
                              iconSize: 17,
                              icon:
                                  const Icon(Icons.star, color: Colors.yellow),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            '(32)',
                            style: TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: constraints.maxWidth * 0.7,
                height: constraints.maxHeight * 0.06,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(fontFamily: 'Raleway'),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15, bottom: 10),
                width: constraints.maxWidth * 0.9,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        width: 1, color: Color.fromARGB(255, 228, 227, 227)),
                    bottom: BorderSide(
                        width: 1, color: Color.fromARGB(255, 228, 227, 227)),
                  ),
                ),
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: const Text(
                  'Product Information',
                  style: TextStyle(fontFamily: 'Raleway', fontSize: 15),
                ),
              ),
              Container(
                width: constraints.maxWidth * 0.9,
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Delivery Options ',
                  style: TextStyle(fontFamily: 'Raleway', fontSize: 15),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 4),
                width: constraints.maxWidth * 0.9,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        width: 1, color: Color.fromARGB(255, 228, 227, 227)),
                    bottom: BorderSide(
                        width: 1, color: Color.fromARGB(255, 228, 227, 227)),
                  ),
                ),
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: const Text(
                  'Product Information',
                  style: TextStyle(fontFamily: 'Raleway', fontSize: 15),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: Container(
                  alignment: Alignment.center,
                  width: constraints.maxWidth * 0.8,
                  child: const Text('Terms and Conditions',
                      style: TextStyle(fontSize: 10, color: Colors.black54)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
