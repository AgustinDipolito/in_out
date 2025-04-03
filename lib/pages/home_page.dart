import 'package:flutter/material.dart';
import 'package:in_out/models/users.dart';
import 'package:in_out/pages/login_page.dart';
import 'package:in_out/pages/recomendations.dart';
import 'package:in_out/servicies/config_service.dart';
import 'package:in_out/servicies/login_service.dart';
import 'package:in_out/utils/constants.dart';
import 'package:in_out/widgets/circular_chart.dart';
import 'package:in_out/widgets/date_filter.dart';
import 'package:in_out/widgets/months_resumes.dart';
import 'package:in_out/widgets/my_button.dart';
import 'package:in_out/widgets/my_divider.dart';
import 'package:in_out/widgets/my_search_bar.dart';
import 'package:in_out/widgets/outs_details.dart';
import 'package:in_out/widgets/type_filter.dart';
import 'package:in_out/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigService>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: kblack,
        floatingActionButton: const ActionButtons(),
        appBar: AppBar(backgroundColor: kblack, title: const MySearchBar()),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black12,
                    Colors.black38,
                    Colors.black54,
                    Colors.black54,
                    Colors.black38,
                    Colors.black12,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: kLittleSpace + 4, bottom: kLittleSpace, top: kLittleSpace),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: kLittleSpace),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Tittle(text: 'History'), DateFilter()],
                    ),
                    const SizedBox(height: kLittleSpace / 3),
                    const History(),
                    const SizedBox(height: kSpace),
                    const MyDivider(),
                    const SizedBox(height: kSpace),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Tittle(text: 'This month'), TypeFilter()],
                    ),
                    const SizedBox(height: kLittleSpace / 3),
                    const LineGraph(),
                    const SizedBox(height: kSpace),
                    const MainTotals(),
                    const SizedBox(height: kLittleSpace),
                    const TotalResult(),
                    const SizedBox(height: kSpace),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(child: Tittle(text: 'This year')),
                        IconButton(
                            iconSize: kLittleSpace,
                            color: kBlueGrey,
                            onPressed: () => config.changeYear(config.year - 1),
                            icon: const Icon(Icons.arrow_back_ios)),
                        Text(
                          '${config.year}',
                          style: const TextStyle(
                            color: kBlueGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          iconSize: kLittleSpace,
                          color: kBlueGrey,
                          onPressed: () => config.changeYear(config.year + 1),
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                    const SizedBox(height: kLittleSpace / 3),
                    const MonthsResumes(),
                    const SizedBox(height: kSpace),
                    const MyDivider(),
                    const SizedBox(height: kSpace),
                    const Tittle(text: 'Groups %'),
                    const SizedBox(height: kLittleSpace / 3),
                    const PieChartSample3(),
                    const SizedBox(height: kSpace),
                    const Tittle(text: 'Sections'),
                    const SizedBox(height: kLittleSpace / 3),
                    const OutsDetails(),
                    const SizedBox(height: kSpace),
                    const MyDivider(),
                    const SizedBox(height: kSpace),
                    const Recomendations(),
                    const SizedBox(height: kSpace),
                    Center(child: Tittle(text: User().email)),
                    const SizedBox(height: kLittleSpace),
                    MyButton(
                      tittle: 'Log out',
                      onTap: () => _logOut(context),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logOut(BuildContext context) {
    Provider.of<LoginService>(
      context,
      listen: false,
    ).logOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
