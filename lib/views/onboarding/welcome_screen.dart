import 'dart:convert';

import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/models/user/etc.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:connectme_app/views/onboarding/onboarding_screens/obc_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:archive/archive.dart';
import 'package:connectme_app/platform_bridge/platform_bridge.dart';


class AnimatedIntroScreen extends ConsumerStatefulWidget {
  const AnimatedIntroScreen({super.key,
  required this.userId,
    required this.userType
  });

  final String userId;
  final UserType userType;

  @override
  ConsumerState<AnimatedIntroScreen> createState() => _AnimatedIntroScreenState();
}

class _AnimatedIntroScreenState extends ConsumerState<AnimatedIntroScreen>
    with TickerProviderStateMixin {
  late AnimationController _lottieController;
  late AnimationController _textImageController;
  late AnimationController _buttonController;

  late Animation<double> _lottieOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _textOpacity;
  late Animation<double> _imageOpacity;
  late Animation<double> _buttonOpacity;


  Uint8List? _lottieJsonBytes;

  Future<void> _loadDotLottie() async {
    // Load the .lottie file from assets
    final dotLottieData = await rootBundle.load('assets/anim/Success_check_confetti.lottie');

    // Decode ZIP
    final archive = ZipDecoder().decodeBytes(dotLottieData.buffer.asUint8List());

    // Find manifest.json to locate animation path
    final manifestFile = archive.firstWhere((f) => f.name == 'manifest.json');
    final manifest = jsonDecode(utf8.decode(manifestFile.content as List<int>));

    final mainAnimPath = manifest['animations'][0]['id']; // e.g., 'animation'
    final animJsonFileName = 'animations/$mainAnimPath.json';

    // Extract the JSON animation
    final animFile = archive.firstWhere((f) => f.name == animJsonFileName);
    final animBytes = Uint8List.fromList(animFile.content as List<int>);

    setState(() {
      _lottieJsonBytes = animBytes;
    });
  }

  @override
  void initState() {
    super.initState();

    _loadDotLottie();

    // 1) Lottie animation fade-in/out controller
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _lottieOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _lottieController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // 2) Text+Image animation controller
    _textImageController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _textImageController,
      curve: Curves.easeOut,
    ));

    _textOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _textImageController,
      curve: const Interval(0, 1, curve: Curves.easeIn),
    ));

    _imageOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _textImageController,
      curve: const Interval(0, 1, curve: Curves.easeIn),
    ));

    // 3) Button animation controller
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _buttonOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeIn,
    ));

    _startSequence();
  }

  Future<void> _startSequence() async {
    // Fade in Lottie
    await _lottieController.forward();
    // Fade out Lottie
    await _lottieController.reverse();
    // Slide+fade text and fade image
    await _textImageController.forward();
    // Fade in button
    await _buttonController.forward();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _textImageController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (_lottieJsonBytes == null) {
      return Container();
    }

    return Scaffold(
      body: SafeArea(
        child:
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
        Expanded(child:Stack(
          alignment: Alignment.center,
          children: [
            // Lottie animation

            Center(child:FadeTransition(
              opacity: _lottieOpacity,
              child:
              Lottie.memory(
                _lottieJsonBytes!,
                repeat: false,
                fit: BoxFit.contain,
              ),
              // Lottie.asset(
              //   'assets/anim/Success_check_confetti.lottie', // replace with your file
              //   width: double.infinity,
              //   fit: BoxFit.contain,
              // ),
            )),

            // Text + Image
            FadeTransition(
              opacity: _textOpacity,
              child: SlideTransition(
                position: _textSlide,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Flexible(child:Text(
                      "Welcome to ConnectMe App",
                      style: TextStyle(
                        fontSize: 27.5,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    )),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _imageOpacity,
                      child: Image.asset(
                        'assets/images/logos/connectMeLogo2_transbg.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Button at bottom
            Positioned(
              bottom: 40,
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
                  onPressed: () async {
                    if (widget.userType == UserType.client){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return  OnboardingScreen(userType: UserType.client,
                        onboardingCompletedFn:  (WidgetRef ref) async {

                            Navigator.pushNamedAndRemoveUntil(
                                context, "/client_home", (route) => false);

                        }
                        );
                      }));
                    }
                    else {

                       /// [CRF]

                      List<bool> vendorEntitled = await checkVendorEntitlement(ref, widget.userId);
                      lg.t("[welcome screen] check entitlement resp ~ " + vendorEntitled.toString());
                      // if ( !vendorEntitled[0] ){
                      //   lg.t("check entitlement resp vendorEntitled false call paywall");
                      //   await allowVendorLoginOrPaywall( context, ref, "testuserid", vendorEntitled[1]);
                      //   return;
                      // }

                      await runOnboardingBeforePaywall(gNavigatorKey.currentContext!, ref, widget.userId, vendorEntitled[1]);
                    }
                  },
                  child: Text("Let's Go!",
                    style:  TextStyle(fontSize: 13.sr,
                        color: Colors.white
                    ),),
                ),
              ),
            ),
          ],
        ))]),
      ),
    );
  }
}
