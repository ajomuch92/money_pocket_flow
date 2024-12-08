import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:money_pocket_flow/views/home/home.controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gastos Totales',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SignalBuilder<int>(
            signal: controller.totalExpends,
            builder: (context, value, child) {
              return Text(
                '$value',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 32,
                ),
              );
            },
          ),
          const SizedBox(
            height: 200.0,
            child: Placeholder(),
          ),
          const ListTile(
            title: Text('Gastos'),
            trailing: Text('\$0'),
          ),
          const ListTile(
            title: Text('Ingresos'),
            trailing: Text('\$0'),
          ),
          ListTile(
            title: const Text(
              'Detalles',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text('\$0'),
          ),
        ],
      ),
    );
  }
}
