import 'package:flutter/material.dart';
import 'package:in_out/models/pay.dart';
import 'package:in_out/utils/constants.dart';
import 'package:in_out/widgets/my_pay_tile.dart';
import 'package:provider/provider.dart';
import 'package:in_out/servicies/pays_service.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      textInputAction: TextInputAction.search,
      backgroundColor: const MaterialStatePropertyAll(kBlueGrey),
      hintText: 'Buscar',
      onTap: () {
        final paysService = Provider.of<PaysService>(context, listen: false);
        showSearch(
          context: context,
          delegate: CustomSearchDelegate(payments: paysService.history),
        );
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final List<Pay> payments;

  CustomSearchDelegate({required this.payments});

  @override
  String get searchFieldLabel => 'Buscar...';

  @override
  TextStyle? get searchFieldStyle => const TextStyle(color: kBlueGrey);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Pay> results = _getFilteredPayments();

    if (results.isEmpty) {
      return const Center(
        child: Text('No results found'),
      );
    }

    return ColoredBox(
      color: kblack,
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final payment = results[index];
          return MyPayTile(
            item: payment,
            onTap: () {},
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      // Show recent transactions when no query entered
      List<Pay> recentPayments = payments.take(5).toList();

      if (recentPayments.isEmpty) {
        return const Center(
          child: Text('Sin transacciones recientes'),
        );
      }

      return ColoredBox(
        color: kblack,
        child: ListView.builder(
          itemCount: recentPayments.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const ListTile(
                leading: Icon(Icons.history),
                title: Text('Ultimas'),
                titleTextStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: kBlueGrey,
                ),
              );
            }

            final payment = recentPayments[index - 1];
            return MyPayTile(
              item: payment,
              onTap: () {
                query = payment.name;
                showResults(context);
              },
            );
          },
        ),
      );
    }

    // Show filtered suggestions based on query
    List<Pay> suggestions = _getFilteredPayments();

    return ColoredBox(
      color: kblack,
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final payment = suggestions[index];
          return MyPayTile(
            item: payment,
            onTap: () {
              query = payment.name;
              showResults(context);
            },
          );
        },
      ),
    );
  }

  // Helper method to filter payments based on the query
  List<Pay> _getFilteredPayments() {
    return payments
        .where((payment) => payment.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
