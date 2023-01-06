import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import '../helpers/working_dates.dart';
import '../style/color.dart';

Widget eachproject(var item, int progress, String imageUrl, Function func) {
  return InkWell(
    onTap: () {
      func();
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
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                image: DecorationImage(
                    image: NetworkImage('${CoreUrl.fileServer}$imageUrl'),
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
            item['introduction_text'],
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
              greenInfo(item['amount'].toString().ammountCorrection()),
              littleSpacer(),
              greenInfo('${item['user_cnt']} donations'),
              littleSpacer(),
              greenInfo(
                  '${countRemainingDays(item['end_date'].toString())} хоног үлдсэн'),
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
