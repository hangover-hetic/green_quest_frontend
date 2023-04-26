import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:green_quest_frontend/api/models/event.dart';
import 'package:green_quest_frontend/api/service.dart';
import 'package:green_quest_frontend/widgets/Menu_button.dart';
import 'package:green_quest_frontend/widgets/event_item_slide.dart';
import 'package:green_quest_frontend/widgets/map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';
import 'package:go_router/go_router.dart';

import '../widgets/event_list_scroll.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocationData? _currentLocation;
  late final MapController _mapController;
  bool _liveUpdate = false;
  bool _permission = false;
  String? _serviceError = '';
  int interActiveFlags = InteractiveFlag.all;

  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 95.0;

  late Future<List<Event>> events = Future.value([]);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _fabHeight = _initFabHeight;
    initLocationService();
    events = ApiService.getListEvents();
  }

  void initLocationService() async {
    Location locationService = Location();

    await locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );

    LocationData? location;
    PermissionStatus _permissionGranted;
    bool serviceEnabled;
    bool serviceRequestResult;



    try {
      serviceEnabled = await locationService.serviceEnabled();

      if (serviceEnabled) {
        final permission = await locationService.requestPermission();
        _permission = permission == PermissionStatus.granted;

        if (_permission) {
          location = await locationService.getLocation();
          _currentLocation = location;
          locationService.onLocationChanged.listen((LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;

                // If Live Update is enabled, move map center
                if (_liveUpdate) {
                  _mapController.move(
                      LatLng(_currentLocation!.latitude!,
                          _currentLocation!.longitude!),
                      _mapController.zoom);
                }
              });
            }
          });
        }
      } else {
        serviceRequestResult = await locationService.requestService();
        if (serviceRequestResult) {
          initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        _serviceError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _serviceError = e.message;
      }
      location = null;
    }
  }



  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    LatLng currentLatLng;

    if (_currentLocation != null) {
      currentLatLng =
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
    } else {
      return const CircularProgressIndicator();
    }

    return Material(
      child: Stack(
        alignment: Alignment.topCenter,

        children: <Widget>[
          SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: MapWithEventMarkers(
              currentLatLng: currentLatLng,
              events: events,
              mapController: _mapController,
            ),
            panelBuilder: () => EventListScrollWidget(
              sc: ScrollController(),
              events: events,
              currentLatLng: currentLatLng),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _initFabHeight;
            }),
          ),

          // the fab
          Positioned(
            right: 20.0,
            bottom: _fabHeight,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF0E756E),
              onPressed: () {
                setState(() {
                  _liveUpdate = !_liveUpdate;

                  if (_liveUpdate) {
                    interActiveFlags = InteractiveFlag.rotate |
                        InteractiveFlag.pinchZoom |
                        InteractiveFlag.doubleTapZoom;

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'In live update mode only zoom and rotation are enable'),
                    ));
                  } else {
                    interActiveFlags = InteractiveFlag.all;
                  }
                });
              },
              child: _liveUpdate
                  ? const Icon(Icons.gps_fixed)
                  : const Icon(Icons.gps_not_fixed),
            ),
          ),
          Positioned(
            left: 20.0,
              top: 20,
              child: MenuButtonWidget()
          )




        ],
      ),
    );
  }
}

