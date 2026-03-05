  import 'dart:typed_data';
import 'package:connectme_app/config/logger.dart';
import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

  class ReorderableImageGrid extends StatelessWidget {
    final  List<MapEntry<String, Uint8List>> orderedImages;
    final void Function(List<MapEntry<String, Uint8List>>) onReorder;
    final void Function(String) onRemove;

    const ReorderableImageGrid({
      super.key,
      required this.orderedImages,
      required this.onReorder,
      required this.onRemove,
    });

    @override
    Widget build(BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;
      const spacing = 8.0;
      final itemWidth = (screenWidth - (2 * spacing) - (2 * spacing)) / 3;

      return
        // Padding(
        // padding: const EdgeInsets.all(spacing),
        // child:
        ReorderableGridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orderedImages.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: 1,
          ),
          dragEnabled: true,
          itemBuilder: (context, index) {
            final entry = orderedImages[index];

            return GestureDetector(
                key: ValueKey(entry.key),
                onDoubleTap: (){
                  lg.t("[ReorderableImageGrid] double tap");
                  onRemove(entry.key);
                },
                child:Card(

              elevation: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  entry.value,
                  fit: BoxFit.cover,
                  width: itemWidth,
                  height: itemWidth,
                ),
              ),
            ));
          },
          onReorder: (oldIndex, newIndex) {
            final newList = [...orderedImages];
            final item = newList.removeAt(oldIndex);
            newList.insert(newIndex, item);
            onReorder(newList);
          },
        // ),
      );
    }
  }


// import 'dart:typed_data';
// import 'package:flutter/material.dart';
//
// class ReorderableImageGrid extends StatefulWidget {
//   final Map<String, Uint8List> imagesMap;
//
//   const ReorderableImageGrid({super.key, required this.imagesMap});
//
//   @override
//   State<ReorderableImageGrid> createState() => _ReorderableImageGridState();
// }
//
// class _ReorderableImageGridState extends State<ReorderableImageGrid> {
//   // late List<MapEntry<String, Uint8List>> _images;
//   //
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _images = widget.imagesMap.entries.toList();
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     const spacing = 8.0;
//
//     return Wrap(
//       spacing: spacing,
//       runSpacing: spacing,
//       children: List.generate(widget.imagesMap  .entries.toList().length, (index) {
//         return _buildDragTarget(index);
//       }),
//     );
//   }
//
//   Widget _buildDragTarget(int index) {
//     return DragTarget<int>(
//       onWillAccept: (fromIndex) => fromIndex != index,
//       onAccept: (fromIndex) {
//         setState(() {
//           if (fromIndex < 0 || fromIndex >= widget.imagesMap.entries.toList().length) return;
//           final item = widget.imagesMap.entries.toList().removeAt(fromIndex);
//           final insertIndex = fromIndex < index ? index - 1 : index;
//           widget.imagesMap.entries.toList().insert(insertIndex, item);
//         });
//       },
//       builder: (context, candidateData, rejectedData) {
//         return LongPressDraggable<int>(
//           data: index,
//           feedback: _dragPreview(index),
//           childWhenDragging: Opacity(opacity: 0.4, child: _imageCard(index)),
//           child: _imageCard(index),
//         );
//       },
//     );
//   }
//
//   Widget _imageCard(int index) {
//     return SizedBox(
//       width: 100,
//       height: 100,
//       child: Card(
//         elevation: 2,
//         clipBehavior: Clip.antiAlias,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         child: Image.memory(
//           widget.imagesMap.entries.toList()[index].value,
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
//
//   Widget _dragPreview(int index) {
//     return Material(
//       color: Colors.transparent,
//       child: SizedBox(
//         width: 100,
//         height: 100,
//         child: Image.memory(
//           widget.imagesMap.entries.toList()[index].value,
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }
