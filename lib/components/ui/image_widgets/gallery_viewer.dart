

import 'dart:typed_data';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:flutter/material.dart';

class ImageGalleryViewer extends StatefulWidget {
  const ImageGalleryViewer({super.key, required this.images,
  this.height,
  this.width
  });
  final List<Uint8List?> images;
  final double? height;
  final double? width;
  @override
  State<ImageGalleryViewer> createState() => _ImageGalleryViewerState();
}

class _ImageGalleryViewerState extends State<ImageGalleryViewer> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    lg.t("[ImageGalleryViewer] initState called images ln ~ " + widget.images.length.toString());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container();
    }

    return
      Container(
        height:widget.height,
      width: widget.width,
      // color: Colors.blue,
      child:Stack(children:[
        Column(
      children: [
        Container(
          height:widget.height,
          width: widget.width,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return
              widget.images[index] != null?
               Image.memory(
                height:widget.height,
                width: widget.width,
                widget.images[index]!,
                fit: BoxFit.contain,
              ):
              Container(
                  width: widget.width,
                  height: widget.height,
                  child: Icon(Icons.broken_image_outlined)
              );

            },
          ),
        ),

      ],
    ),
    widget.images.length > 1?
        Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: Gss.width * .01),
          child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.images.length, (index) {
          final isActive = index == _currentPage;
          return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 12 : 8,
          height: isActive ? 12 : 8,
          decoration: BoxDecoration(
          color: isActive ? appPrimarySwatch[700] : Colors.grey,
          shape: BoxShape.circle,
          ),
          );
          }),
          )),
          ]):Container()

    ]));
  }
}
