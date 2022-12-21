import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/content_home/content.dart';
import '../style/color.dart';

Widget eachproject(var item, int progress) {
  return InkWell(
    onTap: () {
      Get.to(() => const Content());
    },
    child: Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                image: DecorationImage(
                    image: NetworkImage(
                        'https://i.pinimg.com/564x/66/1e/3c/661e3c81c896137ea8b88f54dfebf55c.jpg'),
                    fit: BoxFit.cover)),
          ),
          Row(
            children: [
              Expanded(
                flex: progress,
                child: Container(
                  height: 5,
                  color: const Color(0xFF00AB44),
                ),
              ),
              Expanded(
                flex: (10 - progress),
                child: Container(
                  height: 5,
                  color: Colors.grey,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            item['name'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            item['description'],
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
              greenInfo(item['amount'].toString()),
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
}

Widget greenInfo(String txt) {
  return Text(
    txt,
    style: TextStyle(
        fontWeight: FontWeight.bold, color: CoreColor.mainGreen, fontSize: 11),
  );
}

Widget littleSpacer() {
  return Container(
    margin: const EdgeInsets.only(left: 15, right: 15),
    height: 10,
    width: 0.5,
    color: Colors.black,
  );
}
