// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:ascoop/web_ui/constants.dart';
import 'package:flutter/material.dart';

ButtonStyle ForTealButton = ElevatedButton.styleFrom(
  backgroundColor: Colors.teal[800],
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
  ),
);
ButtonStyle ForTealButton1 = ElevatedButton.styleFrom(
  backgroundColor: Colors.teal[800],
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50.0),
  ),
);
ButtonStyle ForRedButton = ElevatedButton.styleFrom(
  backgroundColor: Colors.red[800],
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
  ),
);
ButtonStyle ForYellowButton = ElevatedButton.styleFrom(
  backgroundColor: Colors.yellow[800],
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
  ),
);

ButtonStyle ForBorderTeal = ElevatedButton.styleFrom(
  elevation: 3,
  backgroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50.0),
    side: const BorderSide(
      width: 2,
      color: Color.fromARGB(255, 1, 95, 84),
    ),
  ),
);
ButtonStyle ForBorderOrange = ElevatedButton.styleFrom(
  elevation: 3,
  backgroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50.0),
    side: BorderSide(
      width: 2,
      color: orange8,
    ),
  ),
);
