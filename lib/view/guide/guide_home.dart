import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:what_was_it_app/core/theme.dart';
import 'package:what_was_it_app/view/component/no_title_frame_view.dart';

class GuideHome extends StatelessWidget {
  const GuideHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoTitleFrameView(
      body: Column(
        children: [
          Text(
            "'기억하다'가 궁금하다",
            style: TextStyle(fontSize: 22, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, decoration: TextDecoration.none, fontFamily: 'GowunDodum'),
          ),
          const SizedBox(height: 20),
          getFirst(context),
          const SizedBox(height: 10),
          const Divider(thickness: 2),
          const SizedBox(height: 10),
          getSecond(context),
          const SizedBox(height: 10),
          const Divider(thickness: 2),
          const SizedBox(height: 10),
          getThird(context),
        ],
      ),
    );
  }

  Widget getFirst(context) {
    final accentStyle = TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(FontAwesomeIcons.one),
            SizedBox(width: 10),
            Expanded(child: Text("'기억하다', 뭐 하는 앱인가요?", style: kLargeTextStyle)),
          ],
        ),
        const SizedBox(height: 10),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: "주요 기능으로 설명하면, 특정 날짜, 특정 시각에 메시지와 함께 알림을 설정할 수 있는 앱입니다.\n"),
              TextSpan(text: "학습 혹은 일상의 루틴을 기억하기 위한 목적", style: accentStyle),
              const TextSpan(text: "으로 사용할 수 있습니다."),
            ],
          ),
        ),
      ],
    );
  }

  Widget getSecond(context) {
    final accentStyle = TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(FontAwesomeIcons.two),
            SizedBox(width: 10),
            Expanded(child: Text("잘 이해 안되는데... 예를 들면요?", style: kLargeTextStyle)),
          ],
        ),
        const SizedBox(height: 10),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: "- "),
              TextSpan(text: "매일 오전 10시", style: accentStyle),
              const TextSpan(text: "마다 마음챙김 명상을 하겠다.\n"),
              const TextSpan(text: "- 오늘 배운 내용을 "),
              TextSpan(text: "1일 후, 7일 후, 14일 후", style: accentStyle),
              const TextSpan(text: "에 복습하겠다.\n"),
              const TextSpan(text: "- "),
              TextSpan(text: "매주 토요일", style: accentStyle),
              const TextSpan(text: "에 카드 사용 내역을 정리하겠다."),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text("위와 같은 상황에 사용하시면 좋습니다."),
        const SizedBox(height: 10),
        const Text("* 알림은 아래와 같이 보입니다."),
        Image.asset("images/noti_image.png"),
        const Text(" - [iOS 16.0 iPhone] 기준"),
      ],
    );
  }

  Widget getThird(context) {
    final accentStyle = TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(FontAwesomeIcons.three),
            SizedBox(width: 10),
            Expanded(child: Text("누가 만들었나요?", style: kLargeTextStyle)),
          ],
        ),
        const SizedBox(height: 10),
        const Text("블로그 링크   [클릭하면 이동합니다]"),
        InkWell(
          onTap: () {
            final url = Uri.http("hi-jin-dev.tistory.com", "/");
            launchUrl(url);
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text("- 앱 개발자 : 안형진 [hi-jin-dev.tistory.com]", style: accentStyle),
          ),
        ),
        InkWell(
          onTap: () {
            final url = Uri.http("jeomxon.tistory.com", "/");
            launchUrl(url);
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text("- 백엔드 개발자 : 유정훈 [jeomxon.tistory.com]", style: accentStyle),
          ),
        ),
        const SizedBox(height: 10),
        const Text("블로그에서 최신 소식을 확인하실 수 있습니다!"),
      ],
    );
  }
}
