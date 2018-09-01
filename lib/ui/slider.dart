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
        title: "ERASER",
        description:
            "Allow miles wound place the leave had. To sitting subject no improve studied limited",
        pathImage: "assets/images/list.jpg",
        backgroundColor: 0xfff5a623,
      ),
    );
    slides.add(
      new Slide(
        title: "PENCIL",
        description:
            "Ye indulgence unreserved connection alteration appearance",
        pathImage: "assets/images/list.jpg",
        backgroundColor: 0xff203152,
      ),
    );
    slides.add(
      new Slide(
        title: "RULER",
        description:
            "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of",
        pathImage: "assets/images/list.jpg",
        backgroundColor: 0xff9932CC,
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
