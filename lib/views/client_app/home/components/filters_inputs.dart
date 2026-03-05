

import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/constants/lists.dart';
import 'package:connectme_app/providers/services.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:connectme_app/views/client_app/home/client_home_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ControlPanel extends ConsumerStatefulWidget {
  const ControlPanel({super.key});
  @override
  ControlPanelState createState() => ControlPanelState();
}

class ControlPanelState extends ConsumerState<ControlPanel> {

  String? _selectedCategory = 'Any';
  // double _rating = 0;
  final TextEditingController _keywordController = TextEditingController();
  List<String> _keywords = [];



  final List<String> _distanceOptions = ['Any', '5', '25', '100', '750'];


  void _addKeyword(String keyword) {
    if (keyword.trim().isNotEmpty && !_keywords.contains(keyword.trim())) {
      setState(() {
        _keywords.addAll(keyword.trim().split(" "));
        _keywordController.clear();
      });
      ref.read(keywordFilterProvider.notifier).state = _keywords;
    }
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  Widget _buildDropdownRow(String label,
      String? selectedValue,
      List<String> options,
      ValueChanged<String?> onChanged) {
    lg.t("_buildDropdownRow build");
    return Row(
      children: [
        Text('$label:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              // color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                isExpanded: true,
                items: options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildRemoteCheckboxRow(
      ValueChanged<List<bool>> onChanged) {
    return Wrap(
      children: [
     Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              // color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: SelectablePills(onChangedCallback: onChanged,),
        ),
      ],
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        Text('Rating:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 16),
        // Expanded(
        //   child:
          RatingBar.builder(
            initialRating: ref.watch(ratingFilterProvider)??0,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30,
            unratedColor: Colors.grey[300],
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) {
              // setState(() {
              //   _rating = rating;
              // });
              ref.read(ratingFilterProvider.notifier).state = rating;
            },
        ),
      ],
    );
  }

  Widget _buildKeywordInput() {
    return TextField(
      controller: _keywordController,
      decoration: InputDecoration(
        hintText: 'Enter keyword',
        filled: true,
        // fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      onSubmitted: _addKeyword, /// takes the input as the arg here
    );
  }

  Widget _buildKeywordChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: _keywords.map((word) {
        return Chip(
          label: Text(word),
          deleteIcon: Icon(Icons.close),
          onDeleted: () {
            setState(() {
              _keywords.remove(word);
            });
            ref.read(keywordFilterProvider.notifier).state = _keywords;
          },
        );
      }).toList(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 16.sr, vertical: 4.sr),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            // boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child:
          ListView(children:[
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [


              Container(
                // color:Colors.blue,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width:Gss.width*.5,
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                Text('Search', style: TextStyle(fontSize: 17.sr, fontWeight: FontWeight.bold))])),

                    Expanded(child:Row(
                            mainAxisAlignment: MainAxisAlignment.end,
            children:[
            Container(
        // color:Colors.green,
        child:
        Row(
        mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(onPressed: (){
                ref.read(focusSearchBar.notifier).state = false;
                ref.read(focusSearchFilters.notifier).state = false;
              },
                  icon: Icon(Icons.clear, size: 16.sr)
              )
            ])
            )]))
                  ])),



              SizedBox(height: 16),

              // Category Dropdown
              _buildDropdownRow("Category", _selectedCategory, serviceCategories, (value) {
                setState(() {
                  _selectedCategory = value;
                });

                if (value?.toLowerCase() == "any"){
                  ref.read(categoryFilterProvider.notifier).state = null;
                }else {
                  ref.read(categoryFilterProvider.notifier).state = value;
                }
              }),

              SizedBox(height: 16),

              // Distance Dropdown
              _buildDropdownRow("Distance (miles)",
                   ref.watch(distanceStandardProvider)??"Any",
                  _distanceOptions,
                      (value) {
                ref.read(distanceStandardProvider.notifier).state = value;
              }),

              SizedBox(height: 16),

              Row(children:[
              Text('Site:', style: TextStyle(fontWeight: FontWeight.bold))]),
              SizedBox(width: 16),

              _buildRemoteCheckboxRow((value){
                // lg.t("remote checkbox value ~ " + value.toString());
                // ref.read(serviceSiteFilterProvider.notifier).state = value;
              }),

              SizedBox(height: 24.sr),
              // Rating Bar
              _buildRatingRow(),

              SizedBox(height: 24.sr),

              // // Category Dropdown
              // _buildDropdownRow("Category", _selectedCategory, serviceCategories, (value) {
              //   setState(() {
              //     _selectedCategory = value;
              //   });
              //
              //   if (value?.toLowerCase() == "any"){
              //     ref.read(categoryFilterProvider.notifier).state = null;
              //   }else {
              //     ref.read(categoryFilterProvider.notifier).state = value;
              //   }
              // }),
              //
              // SizedBox(height: 16),

              // Keyword Input
              _buildKeywordInput(),
              SizedBox(height: 10),
              _buildKeywordChips(),

              SizedBox(height: 16),

              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:[

                // RoundedOutlineButton(
                //   width: Gss.width*.3,
                //   onTap: (){
                //     ref.read(categoryFilterProvider.notifier).state = null;
                //       _selectedCategory = 'Any';
                //     ref.read(distanceStandardProvider.notifier).state = null;
                //     ref.read(serviceSiteFilterProvider.notifier).state = [true, true, true, true];
                //     ref.read(keywordFilterProvider.notifier).state = null;
                //     _keywords = [];
                //     ref.read(ratingFilterProvider.notifier).state = null;
                //
                //     ref.read(searchBarInputFilterProvider.notifier).state = [];
                //     setState(() {});
                //     // ref.read(focusSearchBar.notifier).state = false;
                //     // ref.read(focusSearchFilters.notifier).state = false;
                //   },
                //   label: 'Clear',
                // ),

                    TextButton(
                        onPressed: () {
                              ref.read(categoryFilterProvider.notifier).state = null;
                                _selectedCategory = 'Any';
                              ref.read(distanceStandardProvider.notifier).state = null;
                              ref.read(serviceSiteFilterProvider.notifier).state = [true, true, true, true];
                              ref.read(keywordFilterProvider.notifier).state = null;
                              _keywords = [];
                              ref.read(ratingFilterProvider.notifier).state = null;

                              ref.read(searchBarInputFilterProvider.notifier).state = [];
                              setState(() {});
                              // ref.read(focusSearchBar.notifier).state = false;
                              // ref.read(focusSearchFilters.notifier).state = false;
                        },
                        child: Text("Cancel")),

                    ElevatedButton(
                      // width: Gss.width*.3,
                onPressed: (){
                  ref.read(servicesProvider.notifier).resetForSearch();
                  ref.read(servicesProvider.notifier).loadMore();
                  ref.read(focusSearchBar.notifier).state = false;
                  ref.read(focusSearchFilters.notifier).state = false;

                },
                child: Text('Search'),
              ),


                ]),

              SizedBox(height: Gss.height * .13,)

            ],
          )]),
        ),
      ),
    );
  }


}


class SelectablePills extends ConsumerStatefulWidget {
  const SelectablePills({super.key,
  required this.onChangedCallback
  });

  final ValueChanged<List<bool>> onChangedCallback;

  @override
  ConsumerState<SelectablePills> createState() => _SelectablePillsState();
}

class _SelectablePillsState extends ConsumerState<SelectablePills> {
  final List<String> _options = [
    'On Site',
    'Client Site',
    'Remote',
    'Delivery',
  ];

  // late List<bool> _selected;

  // @override
  // void initState() {
  //   super.initState();
  //   // Initially all selected (you can adjust this if you prefer)
  //   _selected = List.generate(_options.length, (index) => index == 0);
  // }

  void _toggle(int index) {
    // setState(() {
    final selected = ref.read(serviceSiteFilterProvider);
    List<bool> newSelected = selected.toList();
    final selectedCount = newSelected.where((s) => s).length;

      if (newSelected[index] && selectedCount == 1) {
        // Don't allow deselecting the last one, so pick next one
        final int next = (_options.length > 1)
            ? newSelected.indexWhere((i) => (i != index) )
            : index;
        newSelected[next] = true;
      }

      newSelected[index] = !newSelected[index];

      // If all became false, force at least one true
      if (newSelected.where((s) => s).isEmpty) {
        newSelected[index] = true;
      }

      ref.read(serviceSiteFilterProvider.notifier).state = newSelected;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme.primary;

    final selected = ref.watch(serviceSiteFilterProvider);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(_options.length, (index) {
        final isSelected = selected[index];
        return ChoiceChip(
          label: Text(_options[index]),
          selected: isSelected,
          onSelected: (_){
            _toggle(index);
            // widget.onChangedCallback(_selected);
            },
          selectedColor: themeColor.withValues(alpha:0.2),
          labelStyle: TextStyle(
            color: isSelected ? themeColor : null,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(
              color: isSelected ? themeColor : Colors.grey.shade400,
            ),
          ),
          backgroundColor: Colors.transparent,
        );
      }),
    );
  }
}