import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import '../../helpers/working_dates.dart';
import '../../style/color.dart';

Widget eachproject(var item, int progress, String imageUrl, Function func) {
  return InkWell(
    onTap: () {
      func();
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                image: DecorationImage(
                    image: NetworkImage('${CoreUrl.fileServer}$imageUrl'),
                    fit: BoxFit.cover)),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  item['org_name'] ?? '',
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  item['amount'].toString().ammountCorrection(),
                  style: TextStyle(
                      color: CoreColor.mainPurple,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                littleSpacer(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    greenInfo(
                        '${countRemainingDays(item['end_date'].toString())} days',
                        FontAwesomeIcons.stopwatch),
                    const SizedBox(
                      width: 20,
                    ),
                    greenInfo('$progress% (${item['user_cnt']}) ',
                        FontAwesomeIcons.user),
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget greenInfo(String txt, IconData icon) {
  return Row(
    children: [
      Icon(
        icon,
        size: 15,
      ),
      const SizedBox(width: 10),
      Text(
        txt,
        style: const TextStyle(
            fontWeight: FontWeight.w300, color: Colors.grey, fontSize: 14),
      )
    ],
  );
}

Widget littleSpacer() {
  return Container(
    height: 1.5,
    color: Colors.grey.withOpacity(.3),
  );
}


// Row(
//             children: [
//               Expanded(
//                 flex: progress,
//                 child: Container(
//                   height: 2,
//                   color: CoreColor.mainPurple,
//                 ),
//               ),
//               Expanded(
//                 flex: (10 - progress),
//                 child: Container(
//                   height: 2,
//                   color: Colors.grey,
//                 ),
//               )
//             ],
//           ),