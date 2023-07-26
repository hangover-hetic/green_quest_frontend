import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/api/event_service.dart';
import 'package:green_quest_frontend/api/models/event.dart';
import 'package:green_quest_frontend/screens/map/widgets/event_list_scroll.dart';
import 'package:green_quest_frontend/screens/map/widgets/home_menu.dart';
import 'package:green_quest_frontend/screens/map/widgets/map.dart';
import 'package:green_quest_frontend/style/colors.dart';
import 'package:green_quest_frontend/widgets/loading_view.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LocationData? _currentLocation;
  late final MapController _mapController;
  bool _liveUpdate = false;
  int interActiveFlags = InteractiveFlag.all;

  final double _initFabHeight = 120;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  final double _panelHeightClosed = 95;
  bool _isPanelOpen = false;

  late Future<List<Event>> events = Future.value([]);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _fabHeight = _initFabHeight;
    initLocationService();
    events = getEventList();
  }

  Future<void> initLocationService() async {
    final locationService = Location();
    LocationData? location;
    PermissionStatus permissionGranted;
    bool serviceEnabled;

    try {
      serviceEnabled = await locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await locationService.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted = await locationService.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await locationService.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      location = await locationService.getLocation();
      _currentLocation = location;
      locationService.onLocationChanged.listen((LocationData result) async {
        if (mounted) {
          setState(() {
            _currentLocation = result;

            // If Live Update is enabled, move map center
            if (_liveUpdate) {
              _mapController.move(
                LatLng(
                  _currentLocation!.latitude!,
                  _currentLocation!.longitude!,
                ),
                _mapController.zoom,
              );
            }
          });
        }
      });
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        await Fluttertoast.showToast(
          msg: e.message ?? 'Permission denied',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16,
        );
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        await Fluttertoast.showToast(
          msg: e.message ?? 'Location service disabled',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16,
        );
      }
      location = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .90;

    if (_currentLocation == null) {
      print("current location is null");
      return const LoadingViewWidget();
    }

    return Material(
      child: Stack(
        alignment: Alignment.topCenter,
        children: map(),
      ),
    );
  }

  List<Widget> map() {
    LatLng currentLatLng;

    currentLatLng =
        LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);

    return [
      SlidingUpPanel(
        maxHeight: _panelHeightOpen,
        minHeight: _panelHeightClosed,
        parallaxEnabled: true,
        parallaxOffset: .5,
        backdropEnabled: true,
        isDraggable: !_isPanelOpen,
        body: MapWithEventMarkers(
          currentLatLng: currentLatLng,
          events: events,
          mapController: _mapController,
        ),
        panelBuilder: () => EventListScrollWidget(
          scrollController: ScrollController(),
          canScroll: _isPanelOpen,
          events: events,
          currentLatLng: currentLatLng,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        onPanelSlide: (double pos) => setState(() {
          _fabHeight =
              pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
        }),
        onPanelOpened: () => setState(() {
          _isPanelOpen = true;
        }),
        onPanelClosed: () => setState(() {
          _isPanelOpen = false;
        }),
      ),
      // the fab
      Positioned(
          right: 20,
          bottom: _fabHeight,
          child: Column(children: [
            FloatingActionButton(
              heroTag: 'createEvent',
              onPressed: () => context.go('/create_event'),
              backgroundColor: green,
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'liveUpdate',
              backgroundColor: green,
              onPressed: () {
                if (context.mounted) {
                  setState(() {
                    _liveUpdate = !_liveUpdate;

                    if (_liveUpdate) {
                      interActiveFlags = InteractiveFlag.rotate |
                          InteractiveFlag.pinchZoom |
                          InteractiveFlag.doubleTapZoom;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'In live update mode only zoom and rotation are enable',
                          ),
                        ),
                      );
                    } else {
                      interActiveFlags = InteractiveFlag.all;
                    }
                  });
                }
              },
              child: _liveUpdate
                  ? const Icon(Icons.gps_fixed)
                  : const Icon(Icons.gps_not_fixed),
            ),
          ])),
      const Positioned(
        left: 20,
        top: 40,
        child: MenuButtonWidget(),
      )
    ];
  }
}
