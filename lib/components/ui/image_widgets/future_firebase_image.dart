import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectme_app/components/ui/image_widgets/gallery_viewer.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/util/image_util.dart';
import 'package:flutter/material.dart';


class ImageBuilderFromFutureUrl extends StatefulWidget {
  const   ImageBuilderFromFutureUrl({super.key,
    required this.path,
    required this.height,
    required this.width
  });

  final String path;
  final double height;
  final double width;

  @override
  State<ImageBuilderFromFutureUrl> createState() => _ImageBuilderFromFutureUrlState();
}

class _ImageBuilderFromFutureUrlState extends State<ImageBuilderFromFutureUrl> {

  String? getDownloadUrl = "loading";

  @override
  initState() {
    super.initState();
    // lg.t("get  getDownloadUrl for ${widget.path}END");
    scheduleMicrotask(() async {
      getDownloadUrl = await getFBStorageDownloadImageUrlFromPath(widget.path);
      // lg.t("setting getDownloadUrl to ${getDownloadUrl}");
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return
      getDownloadUrl != "loading" && getDownloadUrl != null?
      Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image:
              // AssetImage("assets/images/test/test_house.jpeg"),
              CachedNetworkImageProvider(getDownloadUrl!,
              errorListener: (e){
                lg.e("[ImageBuilderFromFutureUrl] error getting image ~ " + e.toString());
                setState(() {
                  getDownloadUrl = "error";
                });
              }
              ),
              fit: BoxFit.cover,
          ),
        ),
      ):
          getDownloadUrl == "loading"?
      Container(
          width: widget.width,
          height: widget.height,
          child:Center(child:CircularProgressIndicator())):

              getDownloadUrl == null || getDownloadUrl == "error"?
      Container(
        width: widget.width,
        height: widget.height,
        child: Center(child:Icon(Icons.broken_image_outlined))
      ): Container(); /// should never reach



  }
}


class GalleryImageBuilderFromFutureUrl extends StatefulWidget {
  const GalleryImageBuilderFromFutureUrl({super.key,
     this.downloadUrls, /// should be douwnloadUrls or imagePathSlugs no idea why it worked on web
    this.imagePathSlugs,
    required this.height,
    required this.width
  });

  final List? downloadUrls; /// should be douwnloadUrls or imagePathSlugs no idea why it worked on web
  final List? imagePathSlugs;
  final double height;
  final double width;

  @override
  State<GalleryImageBuilderFromFutureUrl> createState() => _GalleryImageBuilderFromFutureUrlState();
}

class _GalleryImageBuilderFromFutureUrlState extends State<GalleryImageBuilderFromFutureUrl> {

  // List<String?> getDownloadUrls = [];

  List<Uint8List?> images = [];


  /// no idea why thiw was working on web and not mobile but times a wasting so refactored and LGTM
  @override
  initState() {
    super.initState();
    lg.t("[GalleryImageBuilderFromFutureUrl] initState called");
    scheduleMicrotask(() async {

      if (widget.imagePathSlugs != null) {
        lg.t("[GalleryImageBuilderFromFutureUrl] build imagePathSlugs");
        for (var path in widget.imagePathSlugs!) {

            var fb_dl_url = await getFBStorageDownloadImageUrlFromPath(path);
            if (fb_dl_url != null) {

              Uint8List? im_bytes = await getDownloadUrlAndReturnFirebaseStorageImageAsBytes(
                  path);
              if (im_bytes != null) {
                images.add(im_bytes);
              }
            }
            else {
              images.add(null);
              /// Image gallery viewer should take null and show broken image
            }
        }
      }

      if (widget.downloadUrls != null) {
        lg.t("[GalleryImageBuilderFromFutureUrl] build downloadUrls");
        for (var dlURL in widget.downloadUrls!) {
          Uint8List? im_bytes = await returnFirebaseStorageImageAsBytes(
              dlURL);
          if (im_bytes != null) {
            images.add(im_bytes);
          }
          else {
            images.add(null);

            /// Image gallery viewer should take null and show broken image
          }
        }
      }

      lg.t("[GalleryImageBuilderFromFutureUrl] downloadUrls ~ " + widget.downloadUrls.toString());
      lg.t("[GalleryImageBuilderFromFutureUrl] imagePathSlugs ~ " + widget.imagePathSlugs.toString());
      lg.t("[GalleryImageBuilderFromFutureUrl] images lng ~ " + images.length.toString());

      setState(() {});
    });


  }
   
  

  @override
  Widget build(BuildContext context) {
    return
      images.isNotEmpty?
      Container(
        width: widget.width,
        height: widget.height,
        child:
        InteractiveViewer(
          // boundary of image
          //   boundaryMargin: const EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 3,
       child: ImageGalleryViewer(images: images,
          width: widget.width,
          height: widget.height,
        ))
      ):

      Container(
          width: Gss.width,
          height: Gss.width * .67,
          child:Center(child:CircularProgressIndicator()));

  }
}