import 'package:flutter/material.dart';

class MapForm extends StatefulWidget {
  final double formPosition;

  MapForm({this.formPosition});

  @override
  State<MapForm> createState() => _MapFormState();
}

class _MapFormState extends State<MapForm> {
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _notesController = TextEditingController();
  double formPosition = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formPosition = 0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
        bottom: formPosition,
        right: 0,
        left: 0,
        duration: Duration(milliseconds: 400),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.all(20),
            height: 270,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 20,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5))
                ]),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _originController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person_pin_circle),
                      labelText: 'Pick up',
                    ),
                    keyboardType: TextInputType.phone,
                    autovalidate: true,
                    autocorrect: true,
                  ),
                  TextFormField(
                    controller: _destinationController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.pin_drop),
                      labelText: 'Drop off',
                    ),
                    obscureText: true,
                    autovalidate: true,
                    autocorrect: false,
                  ),
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.note_add),
                      labelText: 'Notes',
                    ),
                    obscureText: true,
                    autovalidate: true,
                    autocorrect: false,
                  ),
                  Center(
                    child: RaisedButton(
                        color: Colors.green,
                        onPressed: () => {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text('Request a car',
                            style: TextStyle(color: Colors.white))),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
