import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/content.dart';
import '../../widget/appbar_squeare.dart';
import 'content.dart';

class ContentHome extends StatefulWidget {
  const ContentHome({super.key});

  @override
  State<ContentHome> createState() => _ContentHomeState();
}

class _ContentHomeState extends State<ContentHome> {
  static final ContentCont _contentCont = Get.put(ContentCont());
  String option = '1';
  List<DropdownMenuItem<String>> dropitems(List<dynamic> optionList) {
    return optionList.map((item) {
      return DropdownMenuItem(
        value: item.toString(),
        child: Text(
          item.toString(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        onTap: () {},
      );
    }).toList();
  }

  void getProjectList() async {
    await _contentCont.getListData(context).then(
      (data) {
        if (data.statusCode == 200) {}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getProjectList();
    return Scaffold(
      appBar: AppbarSquare(
        title: 'CrowdfundingMN',
        menuAction: () {
          setState(() {
            print('fdf');
          });
        },
        color: const Color(0xFF00AB44),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Expanded(
              flex: 1,
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 5, top: 2, bottom: 2),
                      width: 150,
                      margin: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: DropdownButton<String>(
                          hint: Text('ds'),
                          value: option,
                          onChanged: (String? newValue) {
                            setState(() {
                              option = newValue.toString();
                            });
                          },
                          underline: const SizedBox(),
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(5),
                          items: dropitems(['dsds', '1', 'sdd']))))),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(left: 0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed: () {}, child: tabtext('All')),
                  TextButton(onPressed: () {}, child: tabtext('Popular')),
                  TextButton(onPressed: () {}, child: tabtext('Newest')),
                  TextButton(onPressed: () {}, child: tabtext('Ending soon')),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 15,
            child: PageView(
              children: [
                ListView.builder(
                    itemCount: 3,
                    itemBuilder: (c, i) {
                      return InkWell(
                        onTap: () {
                          Get.to(() => const Content());
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Column(
                            children: [
                              Container(
                                height: 150,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            'https://i.pinimg.com/564x/66/1e/3c/661e3c81c896137ea8b88f54dfebf55c.jpg'),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                height: 8,
                                color: const Color(0xFF00AB44),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Hicarix Badge : LED Bulletin Board using B&W technology',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                ' An elegant LED badge that draws images using B&W technology from a phone screen. Express your creativity with this badge, made in Japan',
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  greenInfo('₮231,850 raised'),
                                  littleSpacer(),
                                  greenInfo('32 donations'),
                                  littleSpacer(),
                                  greenInfo('18 хоног үлдсэн'),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                Container(
                  color: Colors.grey,
                ),
                Container(
                  color: Colors.white,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabtext(String txt) {
    return Text(
      txt,
      maxLines: 4,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.sourceSansPro(
          height: 1,
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Colors.black54),
    );
  }

  Widget greenInfo(String txt) {
    return Text(
      'fdfdf',
      style: TextStyle(
          fontWeight: FontWeight.bold, color: const Color(0xFF00AB44)),
    );
  }

  Widget littleSpacer() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      height: 10,
      width: 1,
      color: Colors.black,
    );
  }
}
