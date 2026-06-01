import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../generated/i18n.g.dart';
import '../styles.dart';

part 'preferences.g.dart';
part 'preferences/locale.dart';
part 'preferences/theme.dart';

@Riverpod(keepAlive: true)
SharedPreferencesAsync preferences(Ref ref) => throw UnimplementedError();
