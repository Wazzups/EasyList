import 'package:intro_slider/intro_slider.dart';
import 'package:flutter/material.dart';
import 'home/home_page.dart';

class SliderPage extends StatefulWidget {
  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "EasyList",
        description:
            "EasyList Allow people to share discount products and plan your day. Make To-Do's Whether it’s for work, school or home!",
        pathImage: "assets/images/assignment.png",
        widthImage: 150.0,
        heightImage: 150.0,
        marginDescription: EdgeInsets.only(top: 100.0),
        backgroundColor: 0xFFE53935,
      ),
    );
    slides.add(
      new Slide(
        title: "Barcode",
        description:
            "Barcode Scanner is the fastest and most user-friendly way to share discount products with the community",
        pathImage: "assets/images/barcodescan.png",
        backgroundColor: 0xFFE53935,
      ),
    );
    slides.add(
      new Slide(
        title: "To-Do List",
        description:
            "Very simple To-Do List. You can add, edit and delete ToDos.",
        pathImage: "assets/images/list.jpg",
        backgroundColor: 0xFFE53935,
      ),
    );
  }

  void onDonePress() {
    var router = MaterialPageRoute(
      builder: (BuildContext context) => HomePage(),
    );
    Navigator.of(context).push(router);
  }

  void onSkipPress() {
    var router = MaterialPageRoute(
      builder: (BuildContext context) => HomePage(),
    );
    Navigator.of(context).push(router);
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      onSkipPress: this.onSkipPress,
    );
  }
}
