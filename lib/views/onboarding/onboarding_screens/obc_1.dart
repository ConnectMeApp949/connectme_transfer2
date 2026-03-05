import 'package:connectme_app/models/user/etc.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key,
  required this.userType,
    required this.onboardingCompletedFn
  });
  final UserType userType;
  final Function onboardingCompletedFn;

  @override
  ConsumerState<OnboardingScreen> createState() => OnboardingScreenState();
}

class OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Example onboarding data
   List<OnboardingPageData>? pages;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < pages!.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    } else {

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
          widget.onboardingCompletedFn(ref);
    }
  }

  @override
  Widget build(BuildContext context) {

    if (widget.userType == UserType.client){
    pages = [
    OnboardingPageData(
    svgPath: 'assets/images/onboarding/undraw_sentiment-analysis_rke9.svg',
    title: 'Discover',
    description: 'Find music, catering, home services, and more — all in one place',
    ),
    OnboardingPageData(
    svgPath: 'assets/images/onboarding/undraw_smartphone_9zbj.svg',
    title: 'Schedule',
    description: 'Find and book available services easily with a few taps',
    ),
    OnboardingPageData(
    svgPath: 'assets/images/onboarding/undraw_testimonials_4c7y.svg',
    title: 'Feedback',
    description: 'Ratings and reviews help the best services stand out',
    ),
    ];
    }

    if (widget.userType == UserType.vendor){
      pages = [
        OnboardingPageData(
          svgPath: 'assets/images/onboarding/undraw_sentiment-analysis_rke9.svg',
          title: 'Network',
          description: 'Connect with clients looking for services that you offer',
        ),
        OnboardingPageData(
          svgPath: 'assets/images/onboarding/undraw_github-profile_abde.svg',
          title: 'Schedule',
          description: 'Allow clients to book according to your schedule',
        ),
        OnboardingPageData(
          svgPath: 'assets/images/onboarding/undraw_stripe-payments_jxnn.svg',
          title: 'Payments',
          description: 'Federated payment processing on platform that clients can trust',
        ),
        OnboardingPageData(
          svgPath: 'assets/images/onboarding/undraw_online-review_08y6.svg',
          title: 'Reviews',
          description: 'Build your reputation by gaining positive ratings and reviews',
        ),
      ];
    }

    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        itemCount: pages!.length,
        itemBuilder: (context, index) {
          return OnboardingPage(
            data: pages![index],
            pagesLen: pages!.length,
            index: index,
            isCurrentPage: index == _currentPage,
            onNext: _nextPage,
          );
        },
      ),
    );
  }
}

class OnboardingPageData {
  final String svgPath;
  final String title;
  final String description;

  const OnboardingPageData({
    required this.svgPath,
    required this.title,
    required this.description,
  });
}

class OnboardingPage extends StatefulWidget {
  final OnboardingPageData data;
  final int pagesLen;
  final bool isCurrentPage;
  final int index;
  final VoidCallback onNext;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.pagesLen,
    required this.index,
    required this.isCurrentPage,
    required this.onNext,
  });

  @override
  State<OnboardingPage> createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  late AnimationController _svgController;
  late AnimationController _textController;
  late AnimationController _buttonController;

  late Animation<Offset> _svgSlide;
  late Animation<double> _svgOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _textOpacity;
  late Animation<Offset> _buttonSlide;
  late Animation<double> _buttonOpacity;

  @override
  void initState() {
    super.initState();

    _svgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _svgSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _svgController, curve: Curves.easeOut));
    _svgOpacity = Tween<double>(begin: 0, end: 1).animate(_svgController);

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(_textController);

    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _buttonController, curve: Curves.easeOut));
    _buttonOpacity = Tween<double>(begin: 0, end: 1).animate(_buttonController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playAnimations();
    });
  }

  @override
  void didUpdateWidget(covariant OnboardingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCurrentPage) {
      _playAnimations();
    } else {
      _resetAnimations();
    }
  }

  void _playAnimations() async {
    await _svgController.forward();
    await _textController.forward();
    await _buttonController.forward();
  }

  void _resetAnimations() {
    _svgController.reset();
    _textController.reset();
    _buttonController.reset();
  }

  @override
  void dispose() {
    _svgController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SlideTransition(
            position: _svgSlide,
            child: FadeTransition(
              opacity: _svgOpacity,
              child: SvgPicture.asset(widget.data.svgPath, height: 250),
            ),
          ),
          const SizedBox(height: 40),
          SlideTransition(
            position: _textSlide,
            child: FadeTransition(
              opacity: _textOpacity,
              child: Column(
                children: [
                  Text(
                    widget.data.title,
                    textAlign: TextAlign.center,
                      style:TextStyle(fontSize:16.sr,
                      fontWeight: FontWeight.w600
                      )
                  ),
                  const SizedBox(height: 12),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                  Flexible(child:Text(
                    widget.data.description,
                    textAlign: TextAlign.center,
                    style:TextStyle(fontSize:14.sr)
                  ))]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 60),
          SlideTransition(
            position: _buttonSlide,
            child: FadeTransition(
              opacity: _buttonOpacity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: appPrimarySwatch[600],
                ),
                onPressed: widget.onNext,
                child: Text(
                  widget.index == (widget.pagesLen - 1) ? 'Get Started' : 'Next',
                  style:  TextStyle(fontSize: 13.sr,
                  color: Colors.white
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
