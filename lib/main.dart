import 'dart:developer';
import 'dart:io';

import 'package:billingsphere/auth/providers/category_provider.dart';
import 'package:billingsphere/auth/providers/itemSearch_provider.dart';
import 'package:billingsphere/core/routes.dart';
import 'package:billingsphere/logic/cubits/itemBrand_cubit/itemBrand_cubit.dart';
import 'package:billingsphere/logic/cubits/itemGroup_cubit/itemGroup_cubit.dart';
import 'package:billingsphere/logic/cubits/item_cubit/item_cubit.dart';
import 'package:billingsphere/logic/cubits/user_cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'auth/providers/amount_provider.dart';

import 'auth/providers/onchange_item_provider.dart';
import 'auth/providers/onchange_ledger_provider.dart';
import 'logic/cubits/hsn_cubit/hsn_cubit.dart';
import 'logic/cubits/measurement_cubit/measurement_limit_cubit.dart';
import 'logic/cubits/secondary_unit_cubit/secondary_unit_cubit.dart';
import 'logic/cubits/store_cubit/store_cubit.dart';
import 'logic/cubits/taxCategory_cubit/taxCategory_cubit.dart';
import 'screens/splash/splashScreen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
  Bloc.observer = MyBlocObserver();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => ItemCubit()),
        BlocProvider(create: (context) => ItemGroupCubit()),
        BlocProvider(create: (context) => ItemBrandCubit()),
        BlocProvider(create: (context) => TaxCategoryCubit()),
        BlocProvider(create: (context) => HSNCodeCubit()),
        BlocProvider(create: (context) => CubitStore()),
        BlocProvider(create: (context) => MeasurementLimitCubit()),
        BlocProvider(create: (context) => SecondaryUnitCubit()),
        ChangeNotifierProvider(create: (_) => AmountProvider()),
        ChangeNotifierProvider(create: (_) => OnChangeItenProvider()),
        ChangeNotifierProvider(create: (_) => OnChangeLedgerProvider()),
        ChangeNotifierProvider(create: (_) => CategoryItemProvider()),
        ChangeNotifierProvider(create: (_) => ItemSearchProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Routes.onGenerateRoute,
        initialRoute: SplashScreen.routeName,
        // showPerformanceOverlay: true,
        // home: VoucherSetupScreen(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    log("Created: $bloc");
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    log("Change in $bloc: $change");
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log("Change in $bloc:$transition");
    super.onTransition(bloc, transition);
  }

  @override
  void onClose(BlocBase bloc) {
    log("Closed: $bloc");
    super.onClose(bloc);
  }
}
