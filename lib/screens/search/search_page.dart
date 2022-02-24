import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';

import 'package:uy/screens/search/randomList.dart';
import 'package:uy/screens/search/search_textBox.dart';
import 'package:uy/services/provider/search_field_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key key,
  }) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> search;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  String _searchTextAsUserIsTyping = '';
  String _currentSearch = '';

  Future<bool> subcribe(String userId, String currenUser) async {
    bool subscribeTrue = false;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currenUser)
        .collection("Subscriptions")
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          subscribeTrue = true;
        });
      } else {
        setState(() {
          subscribeTrue = false;
        });
      }
    });
    return subscribeTrue;
  }

  Widget _mainBody() {
    return XSearchTextbox(
      key: Key(_currentSearch),
      suggestCallbackFunc: (freeSearchTextAsUserIsTyping) {
        setState(() {
          this._searchTextAsUserIsTyping = freeSearchTextAsUserIsTyping;
        });
        Provider.of<SearchFieldProvider>(context, listen: false)
            .changeSearchField(_searchTextAsUserIsTyping.toString());
      },
      searchHintText: S.of(context).searchTelltrue,
      initialvalue: _currentSearch,
      searchCallback: (freeSearchValue) => setState(() {
        _currentSearch = freeSearchValue;
        _searchTextAsUserIsTyping = _currentSearch;
      }),
      suggestListInOverlay: _suggestListWdiget(),
    );
  }

  ///suggest list widget
  Widget _suggestListWdiget() => RandomList(
        searchTextTyping: _currentSearch,
      );

  @override
  Widget build(BuildContext context) {
    return _mainBody();
  }
}
