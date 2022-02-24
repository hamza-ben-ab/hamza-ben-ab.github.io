import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/search/overlay.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/provider/search_details_provider.dart';
import 'package:intl/intl.dart' as intl;

typedef void SearchCallbackText(freeSearchText);
typedef void SuggestCallback(freeSearchTextAsUserIsTyping);

class XSearchTextbox extends StatefulWidget {
  final String searchHintText;
  final String initialvalue;
  final SearchCallbackText searchCallback;
  final SuggestCallback suggestCallbackFunc;
  final Widget suggestListInOverlay;

  const XSearchTextbox({
    @required this.searchHintText,
    @required this.initialvalue,
    @required this.searchCallback,
    @required this.suggestCallbackFunc,
    @required this.suggestListInOverlay,
    Key key,
  }) : super(key: key);

  @override
  _XSearchTextboxState createState() => _XSearchTextboxState();
}

class _XSearchTextboxState extends State<XSearchTextbox> {
  final XOverlayController _xOverlayController = XOverlayController();
  final TextEditingController _searchTextEditingController =
      TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();

  bool _showSuggestOverlay = false;
  String _currentSearchVal;

  @override
  void initState() {
    super.initState();
    _currentSearchVal = widget.initialvalue;
    _searchTextEditingController.text = widget.initialvalue;
    this._showSuggestOverlay = false;
    _searchTextEditingControllerListener();
    _searchTextFocusNodeListener();
  }

  ///as and when there is a change in search textfield
  void _searchTextEditingControllerListener() =>
      _searchTextEditingController.addListener(
        () => setState(
          () {
            if (_currentSearchVal != _searchTextEditingController.text) {
              _currentSearchVal = _searchTextEditingController.text;
              widget.suggestCallbackFunc(_currentSearchVal);
            }

            _showSuggestOverlay = _searchTextFocusNode.hasFocus &&
                _searchTextEditingController.text.isNotEmpty;
          },
        ),
      );

  ///focus listener on textfield
  void _searchTextFocusNodeListener() => _searchTextFocusNode.addListener(() {
        if (_searchTextFocusNode.hasFocus) {
          setState(() {
            _showSuggestOverlay = _searchTextEditingController.text.isNotEmpty;
          });
        }
      });

  ///display either suggest or search options overlay on post frame callback
  void _displayAppropriateOverlay() =>
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (_searchTextFocusNode.hasFocus && _showSuggestOverlay)
          _xOverlayController.showOverlay('suggest');
        else
          _xOverlayController.hideOverlay(false);
      });

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    _displayAppropriateOverlay();
    return XOverlay(
      onHideOverlayFunc: () {
        _showSuggestOverlay = false;
      },
      insideOverlayWidgetMap: {
        'suggest': widget.suggestListInOverlay,
      },
      xOverlayController: _xOverlayController,
      child: Container(
        height: h * .05,
        width: w * .25,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: h * .05,
              width: w * .25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: _searchTextfield(),
            ),
          ],
        ),
      ),
    );
  }

  void _callSearchFunc() {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    String toSearch = this._searchTextEditingController.text;
    _currentSearchVal = widget.initialvalue;
    this._searchTextEditingController.text = widget.initialvalue;
    _showSuggestOverlay = false;
    this.widget.searchCallback(toSearch);
  }

  Widget _searchTextfield() => TextFormField(
        textInputAction: TextInputAction.go,
        autofocus: false,
        cursorColor: Colors.black,
        showCursor: true,
        focusNode: _searchTextFocusNode,
        controller: this._searchTextEditingController,
        onFieldSubmitted: (val) => _callSearchFunc(),
        onEditingComplete: () {
          Provider.of<CenterBoxProvider>(context, listen: false)
              .changeCurrentIndex(8);
          Provider.of<SearchDetailsProvider>(context, listen: false)
              .changeSearch(_searchTextEditingController.value.text);
        },
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          fontFamily: "SPProtext",
        ),
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          hintText: widget.searchHintText,
          hintTextDirection:
              intl.Bidi.detectRtlDirectionality(S.of(context).postViewWrittenBy)
                  ? TextDirection.rtl
                  : TextDirection.ltr,
          hintStyle: TextStyle(
            letterSpacing: 1.2,
            color: Colors.grey[800],
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[200]),
            borderRadius: BorderRadius.circular(15.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.grey[200]),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.grey[200]),
          ),
          hoverColor: Colors.grey[200],
          suffixIcon: IconButton(
            onPressed: () {
              Provider.of<CenterBoxProvider>(context, listen: false)
                  .changeCurrentIndex(8);
              Provider.of<SearchDetailsProvider>(context, listen: false)
                  .changeSearch(_searchTextEditingController.value.text);
            },
            icon: Icon(
              LineAwesomeIcons.search,
              color: Colors.grey[800],
              size: 16.0,
            ),
          ),
        ),
      );

  @override
  void dispose() {
    this._searchTextFocusNode.dispose();
    this._searchTextEditingController.dispose();
    _xOverlayController.dispose();
    super.dispose();
  }
}
