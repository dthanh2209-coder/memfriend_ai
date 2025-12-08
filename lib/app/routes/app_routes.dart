part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const home = _Paths.home;
  static const personDetail = _Paths.personDetail;
  static const recognition = _Paths.recognition;
  static const settings = _Paths.settings;
  static const addPerson = _Paths.addPerson;
  static const editPerson = _Paths.editPerson;
  static const addFace = _Paths.addFace;
  static const addMemory = _Paths.addMemory;
  static const editMemory = _Paths.editMemory;
}

abstract class _Paths {
  _Paths._();
  static const home = '/home';
  static const personDetail = '/person-detail';
  static const recognition = '/recognition';
  static const settings = '/settings';
  static const addPerson = '/add-person';
  static const editPerson = '/edit-person';
  static const addFace = '/add-face';
  static const addMemory = '/add-memory';
  static const editMemory = '/edit-memory';
}
