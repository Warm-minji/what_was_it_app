import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/view/home/home_screen.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final indicator = [
      Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor),
      SizedBox(width: 10),
      Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor),
      SizedBox(width: 10),
      Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor),
      SizedBox(width: 10),
      Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor),
      SizedBox(width: 10),
      Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor),
    ];

    indicator[(currentPage - 1) * 2] = Icon(Icons.circle, color: Theme.of(context).primaryColor);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  onPageChanged: (idx) {
                    setState(() {
                      currentPage = idx + 1;
                    });
                  },
                  children: [
                    Stack(
                      children: [
                        Align(
                          child: Column(
                            children: [
                              const Text("공부한 내용을 원하는 날짜에 복습할 수 있습니다."),
                              const SizedBox(height: 20),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.6,
                                    child: Image.asset("images/onboarding/1.gif"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          child: Text("슬라이드하여 넘기기"),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("루틴(ex. 운동)을 쉽게 기억할 수 있습니다."),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: Image.asset("images/onboarding/2.gif"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("카테고리별로 쉽게 확인할 수 있습니다."),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: Image.asset("images/onboarding/3.gif"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("손쉽게 삭제하고 수정할 수 있습니다."),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: Image.asset("images/onboarding/4.gif"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("예정된 알림 목록을 확인할 수 있습니다."),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: Image.asset("images/onboarding/5.gif"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: indicator,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: (currentPage == 5)
          ? FloatingActionButton(
              child: const Icon(FontAwesomeIcons.check),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => route.isFirst);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("상단의 '?'를 클릭하여 가이드를 다시 확인할 수 있습니다.")));
              },
            )
          : null,
    );
  }
}
