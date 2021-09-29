import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:nearby_restaurants/models/site.dart';
import 'package:nearby_restaurants/providers/session_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class FlutPlaceAutocomplete extends StatefulWidget {
  InputDecoration inputDecoration;
  OnItemClickListener onItemClickListener;
  TextStyle textStyle;
  // String googleAPIKey;
  int debounceTime = 500;
  TextEditingController textEditingController = TextEditingController();
  bool isCity;

  FlutPlaceAutocomplete(
      {this.isCity = false,
      required this.textEditingController,
      // @required this.googleAPIKey,
      this.debounceTime: 500,
      this.inputDecoration: const InputDecoration(),
      required this.onItemClickListener,
      this.textStyle: const TextStyle()});

  @override
  _FlutPlaceAutocompleteState createState() => _FlutPlaceAutocompleteState();
}

class _FlutPlaceAutocompleteState extends State<FlutPlaceAutocomplete> {
  String _apikey = 'AIzaSyBDwSMpC5NgxmjW1osXz2pK6z9ob-gnPm0';
  final _sessiontoken = Uuid().v4();
  String _language = 'es';
  String _components = 'country:co';
  bool isCity = false;

  // Restricción : Devuelve direcciones dentro de un area centrada
  // de la ciudad de Cali dentro de los 40km
  /// locality
  /// establishment
  String _types = '(cities)';
  String _location = '3.402785,-76.524148';
  String _radius = '40000';

  final publishSubject = new PublishSubject<String>();
  OverlayEntry? _overlayEntry;
  List<Prediction> predictions = [];
  List<Site> sites = [];
  final LayerLink _layerLink = LayerLink();
  bool isSearched = false;

  SessionProvider? sessionProvider;

  @override
  Widget build(BuildContext context) {
    sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    isCity = widget.isCity;
    _types = (isCity) ? '(cities)' : 'establishment';
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        decoration: widget.inputDecoration,
        style: widget.textStyle,
        controller: widget.textEditingController,
        onChanged: (string) => (publishSubject.add(string)),
      ),
    );
  }

// https://maps.googleapis.com/maps/api/place/autocomplete/json?components=country:co&location=3.404776,-76.521674&radius=40000&strictbounds&input=Ca&types=address&language=es&key=AIzaSyBDwSMpC5NgxmjW1osXz2pK6z9ob-gnPm0
  getAutocomplete(String input) async {
    if (sessionProvider != null) {
      if (sessionProvider!.isLocation) {
        final location = sessionProvider!.currentLocation;
        _location = '${location.latitude},${location.longitude}';
        print('LOCATION :: $_location');
      }
    }

    Uri uri;
    if (isCity) {
      uri = Uri.https(
          'maps.googleapis.com', '/maps/api/place/autocomplete/json', {
        'input': input,
        'types': _types,
        'language': _language,
        'components': _components,
        'key': _apikey,
        //'sessiontoken': _sessiontoken
      });
    } else {
      uri = Uri.https(
          'maps.googleapis.com', '/maps/api/place/autocomplete/json', {
        'input': input,
        'types': 'establishment',
        'location': _location,
        'radius': _radius,
        'language': _language,
        'components': _components,
        'key': _apikey,
        //'sessiontoken': _sessiontoken
      });
    }

    print('URI:   ${uri.toString()}');

    final response = await http.get(uri);
    final data = json.decode(response.body);
    print('RESPUESTA:   $data');

    PlaceAutocompleteResponses placeAutocompleteResponses =
        PlaceAutocompleteResponses.fromJson(data);

    print('RESULTADOS:   ${placeAutocompleteResponses.predictions!.length}');
    print('ESTADO:   ${placeAutocompleteResponses.status}');

    if (input.length == 0) {
      predictions.clear();
      this._overlayEntry?.remove();
      return;
    }

    isSearched = false;
    if (placeAutocompleteResponses.predictions!.length > 0) {
      predictions.clear();
      predictions.addAll(placeAutocompleteResponses.predictions!);
    }

    this._overlayEntry = null;
    this._overlayEntry = this._createOverlayEntry();
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  @override
  void initState() {
    publishSubject.stream
        .distinct()
        .debounceTime(Duration(milliseconds: widget.debounceTime))
        .listen(textChanged);
  }

  textChanged(String text) async {
    getAutocomplete(text);
  }

  OverlayEntry? _createOverlayEntry() {
    if (context != null && context.findRenderObject() != null) {
      RenderBox? renderBox = context.findRenderObject() as RenderBox?;
      var size = renderBox?.size;
      var offset = renderBox?.localToGlobal(Offset.zero);
      return OverlayEntry(
          builder: (context) => Positioned(
                left: offset?.dx,
                top: size!.height + offset!.dy,
                width: size.width,
                child: CompositedTransformFollower(
                  showWhenUnlinked: false,
                  link: this._layerLink,
                  offset: Offset(0.0, size.height + 5.0),
                  child: Material(
                      elevation: 1.0,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: predictions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              if (index < predictions.length) {
                                // Site site = new Site();
                                // site.addressLine = predictions[index].description;
                                // site.placeId = predictions[index].placeId;
                                // final addresLine = predictions[index].description.split(',');
                                // site.address = addresLine[0] ?? null;
                                // site.locality = addresLine[1] ?? null;
                                // site.adminArea = addresLine[2] ?? null;
                                // site.countryName = addresLine[3] ?? null;
                                //widget.onItemClickListener(predictions[index]);
                                widget.onItemClickListener(
                                    predictions[index].site!);
                                removeOverlay();
                              }
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                child: ListTile(
                                    //leading: Icon(Icons.place),
                                    title: Text(
                                      predictions[index].site!.address,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Icon(Icons.place,
                                            size: 16.0, color: Colors.indigo),
                                        SizedBox(width: 2.0),
                                        Expanded(
                                          child: Text(
                                              '${predictions[index].site?.locality}, ${predictions[index].site?.adminArea}'),
                                        )
                                      ],
                                    ))),
                          );
                        },
                      )),
                ),
              ));
    }
  }

  removeOverlay() {
    predictions.clear();
    this._overlayEntry = this._createOverlayEntry();
    if (context != null) {
      Overlay.of(context)?.insert(_overlayEntry!);
      this._overlayEntry?.markNeedsBuild();
    }
  }
}

class PlaceAutocompleteResponses {
  List<Prediction>? predictions;
  String? status;

  PlaceAutocompleteResponses({this.predictions, this.status});

  PlaceAutocompleteResponses.fromJson(Map<String, dynamic> json) {
    if (json['predictions'] != null) {
      predictions = <Prediction>[];
      json['predictions'].forEach((v) {
        predictions!.add(new Prediction.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.predictions != null) {
      data['predictions'] = this.predictions!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Prediction {
  String? description;
  String? id;
  List<MatchedSubstrings>? matchedSubstrings;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;
  List<Terms>? terms;
  List<String>? types;
  Site? site;

  Prediction(
      {this.description,
      this.id,
      this.matchedSubstrings,
      this.placeId,
      this.reference,
      this.structuredFormatting,
      this.terms,
      this.types});

  Prediction.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    id = json['id'];
    if (json['matched_substrings'] != null) {
      matchedSubstrings = <MatchedSubstrings>[];
      json['matched_substrings'].forEach((v) {
        matchedSubstrings!.add(new MatchedSubstrings.fromJson(v));
      });
    }
    placeId = json['place_id'];
    reference = json['reference'];
    structuredFormatting = json['structured_formatting'] != null
        ? new StructuredFormatting.fromJson(json['structured_formatting'])
        : null;
    if (json['terms'] != null) {
      terms = <Terms>[];
      json['terms'].forEach((v) {
        terms!.add(new Terms.fromJson(v));
      });
    }
    types = json['types'].cast<String>();

    if (description != null) {
      site = new Site();
      site!.addressLine = description ?? '';
      site!.placeId = placeId ?? '';
      final addresLine = description!.split(',');
      for (int i = 0; i < addresLine.length; i++) {
        if (i == 0) {
          site!.address = addresLine[0].trim();
        }
        if (i == 1) {
          site!.locality = addresLine[1].trim();
        }
        if (i == 2) {
          site!.adminArea = addresLine[2].trim();
        }
        if (i == 3) {
          site!.countryName = addresLine[3].trim();
        }
      }
      // site!.address =  addresLine.[0].trim();
      // site!.locality = addresLine.contains(1) ? addresLine[1].trim() : '';
      // site!.adminArea = addresLine.contains(2) ? addresLine[2].trim() : '';
      // site!.countryName = addresLine.contains(3) ? addresLine[3].trim() : '';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['id'] = this.id;
    if (this.matchedSubstrings != null) {
      data['matched_substrings'] =
          this.matchedSubstrings?.map((v) => v.toJson()).toList();
    }
    data['place_id'] = this.placeId;
    data['reference'] = this.reference;
    if (this.structuredFormatting != null) {
      data['structured_formatting'] = this.structuredFormatting?.toJson();
    }
    if (this.terms != null) {
      data['terms'] = this.terms?.map((v) => v.toJson()).toList();
    }
    data['types'] = this.types;
    return data;
  }
}

class MatchedSubstrings {
  int? length;
  int? offset;

  MatchedSubstrings({this.length, this.offset});

  MatchedSubstrings.fromJson(Map<String, dynamic> json) {
    length = json['length'];
    offset = json['offset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['length'] = this.length;
    data['offset'] = this.offset;
    return data;
  }
}

class StructuredFormatting {
  String? mainText;

  String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  StructuredFormatting.fromJson(Map<String, dynamic> json) {
    mainText = json['main_text'];

    secondaryText = json['secondary_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main_text'] = this.mainText;
    data['secondary_text'] = this.secondaryText;
    return data;
  }
}

class Terms {
  int? offset;
  String? value;

  Terms({this.offset, this.value});

  Terms.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offset'] = this.offset;
    data['value'] = this.value;
    return data;
  }
}

typedef OnItemClickListener = void Function(Site prediction);
//typedef OnItemClickListener = void Function(Prediction prediction);
