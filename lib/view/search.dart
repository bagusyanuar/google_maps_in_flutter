import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_in_flutter/component/card-list.dart';
import 'package:google_maps_in_flutter/component/page-loading.dart';
import 'package:google_maps_in_flutter/controller/mapping.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String param = '';
  Timer? _debounce;
  bool isLoading = true;
  List<dynamic> _listODC = [];

  @override
  void initState() {
    // TODO: implement initState
    _getListODC('');
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                onChanged: _handlerOnChange,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    prefixIcon: Icon(Icons.search),
                    hintText: "Cari ODC..."),
              ),
            ),
            Expanded(
              child: isLoading
                  ? PageLoading()
                  : RefreshIndicator(
                      onRefresh: () {
                        return _refresh();
                      },
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: LayoutBuilder(
                          builder: (ctx, constraints) => SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _listODC
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: CardList(
                                          id: e["id"] as int,
                                          name: e["nama"].toString(),
                                          address: e["deskripsi"].toString(),
                                          onTap: () {
                                            int id = e["id"] as int;
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              "/detail",
                                              ModalRoute.withName("/dashboard"),
                                              arguments: id
                                            );
                                            print(id);
                                          },
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _refresh() async {
    _getListODC(param);
  }

  void _getListODC(String text) async {
    setState(() {
      isLoading = true;
    });
    List<dynamic> _list = await getListODC(text);
    print(_list);
    setState(() {
      isLoading = false;
      _listODC = _list;
    });
  }

  void _handlerOnChange(String text) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _getListODC(text);
    });
  }
}
