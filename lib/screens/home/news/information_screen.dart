import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/services/get_service.dart';
import 'package:gerege_app_v2/style/color.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];
  @override
  void initState() {
    super.initState();
    getNews();
  }

  // GET https://go-backend.gerege.mn/template/news?title&page_size&page_number

  getNews() {
    String url = '${CoreUrl.serviceUrl}news?page_size=10&page_number=1';
    print(url);
    Services().getRequest(url, true, '').then((data) {
      print('getNews getNews getNews');
      print(data.body);
      // if (data.statusCode == 200) {
      //   setState(() {
      //     print(data.body['result']['items']);
      //     countryList.value = data.body['result']['items'];
      //   });
      // } else {
      //   Get.snackbar(
      //     'warning_tr'.translationWord(),`
      //     data.body['message'],
      //     colorText: Colors.white,
      //     backgroundColor: Colors.red.withOpacity(0.2),
      //   );
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            width: GlobalVariables.gWidth,
            child: topCarousel(),
          )
        ],
      ),
    );
  }

  Widget topCarousel() {
    return CarouselSlider.builder(
      itemCount: imgList.length,
      options: CarouselOptions(
        aspectRatio: 2.5,
        enlargeCenterPage: true,
        autoPlay: true,
        viewportFraction: 0.8,
      ),
      itemBuilder: (context, index, realIdx) {
        return InkWell(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: index % 3 == 0
                    ? CoreColor().backgroundBlue
                    : index % 2 == 0
                        ? CoreColor().backgroundGreen
                        : CoreColor().backgroundYellow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  // SizedBox(
                  //   width: GlobalVariables.gWidth - 100,
                  //   child: Image.network(
                  //     imgList[index],
                  //     fit: BoxFit.fill,
                  //     height: GlobalVariables.gHeight,
                  //     width: GlobalVariables.gWidth,
                  //   ),
                  // ),
                  Expanded(
                    child: Column(
                      children: const [
                        SizedBox(height: 20),
                        Text(
                          "Мэдээ",
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.white,
                            // fontWeight: FontWeight.bold,
                            fontSize: 50,
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          child: Text(
                            "Тайлбар",
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
