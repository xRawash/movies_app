import 'package:flutter/material.dart';

abstract class ProfileRepo {
  Future<bool> signOut(BuildContext context);
}
