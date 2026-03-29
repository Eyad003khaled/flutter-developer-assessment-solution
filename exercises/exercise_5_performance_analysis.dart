// =============================================================================
// EXERCISE 5: Performance Analysis — "Widget Rebuild Audit"
// Time: 30 minutes
// =============================================================================
//
// SCENARIO:
// You've been asked to audit the main layout of a live-streaming app for
// performance issues. The widget tree below is causing dropped frames and
// excessive rebuilds on mid-range devices.
//
// TASKS:
// 1. [All Levels] Identify all performance issues in the code below
// 2. [All Levels] Rank each issue by impact: HIGH / MEDIUM / LOW
// 3. [All Levels] Write the fix for each issue (inline code)
// 4. [Senior Bonus] Propose migration from static routes map to onGenerateRoute
// 5. [Senior Bonus] How would you split HomeState (50+ fields) into sub-states?
//
// FORMAT:
// For each issue found, write:
//   ISSUE #N: [Description]
//   IMPACT: HIGH / MEDIUM / LOW
//   WHY: [1-line explanation]
//   FIX: [Code snippet]
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ---------------------------------------------------------------------------
// MOCK TYPES (do not modify)
// ---------------------------------------------------------------------------

final di = _MockDI();
class _MockDI { T call<T>() => throw UnimplementedError(); }

// Mock BLoCs
class FetchUserDataState extends Equatable {
  final Map<String, dynamic>? bannerData;
  final dynamic userEntity;
  final bool isOnline;
  final int unreadCount;
  final String? walletBalance;

  const FetchUserDataState({
    this.bannerData,
    this.userEntity,
    this.isOnline = false,
    this.unreadCount = 0,
    this.walletBalance,
  });

  @override
  List<Object?> get props =>
      [bannerData, userEntity, isOnline, unreadCount, walletBalance];
}

class FetchUserDataEvent {}
class FetchUserDataBloc extends Bloc<FetchUserDataEvent, FetchUserDataState> {
  FetchUserDataBloc() : super(const FetchUserDataState());
}

class LayoutState extends Equatable {
  final int currentIndex;
  final bool showBanner;
  const LayoutState({this.currentIndex = 0, this.showBanner = false});
  @override
  List<Object?> get props => [currentIndex, showBanner];
}

class LayoutEvent {}
class LayoutBloc extends Bloc<LayoutEvent, LayoutState> {
  LayoutBloc() : super(const LayoutState());
}

class HomeState extends Equatable {
  // This state has 50+ fields in the real codebase
  final int currentTabIndex;
  final List<dynamic> popularRooms;
  final List<dynamic> liveRooms;
  final List<dynamic> followRooms;
  final List<dynamic> friendsRooms;
  final List<dynamic> lastCreateRooms;
  final List<dynamic> filteredRooms;
  final List<dynamic> globalRooms;
  final int popularCurrentPage;
  final int liveCurrentPage;
  final int globalCurrentPage;
  final int followCurrentPage;
  final int friendsCurrentPage;
  // ... imagine 35+ more fields

  const HomeState({
    this.currentTabIndex = 0,
    this.popularRooms = const [],
    this.liveRooms = const [],
    this.followRooms = const [],
    this.friendsRooms = const [],
    this.lastCreateRooms = const [],
    this.filteredRooms = const [],
    this.globalRooms = const [],
    this.popularCurrentPage = 1,
    this.liveCurrentPage = 1,
    this.globalCurrentPage = 1,
    this.followCurrentPage = 1,
    this.friendsCurrentPage = 1,
  });

  @override
  List<Object?> get props => [
        currentTabIndex, popularRooms, liveRooms, followRooms,
        friendsRooms, lastCreateRooms, filteredRooms, globalRooms,
        popularCurrentPage, liveCurrentPage, globalCurrentPage,
        followCurrentPage, friendsCurrentPage,
      ];
}

class HomeEvent {}
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState());
}

// Mock pages
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class RoomPage extends StatelessWidget {
  const RoomPage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class ReelsPage extends StatelessWidget {
  const ReelsPage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class SplashBloc extends Bloc<dynamic, dynamic> { SplashBloc() : super(null); }
class ConfigAppBloc extends Bloc<dynamic, dynamic> { ConfigAppBloc() : super(null); }
class ColorsBloc extends Bloc<dynamic, dynamic> { ColorsBloc() : super(null); }
class LoginBloc extends Bloc<dynamic, dynamic> { LoginBloc() : super(null); }
class RegisterBloc extends Bloc<dynamic, dynamic> { RegisterBloc() : super(null); }
class SearchBloc extends Bloc<dynamic, dynamic> { SearchBloc() : super(null); }
class ReelsBloc extends Bloc<dynamic, dynamic> { ReelsBloc() : super(null); }
class ChatBloc extends Bloc<dynamic, dynamic> { ChatBloc() : super(null); }
class RoomBloc extends Bloc<dynamic, dynamic> { RoomBloc() : super(null); }
class ProfileBloc extends Bloc<dynamic, dynamic> { ProfileBloc() : super(null); }

// Mock SVGA widget (heavy animation renderer)
class ShowSVGA extends StatelessWidget {
  final String svgaAssetPath;
  final bool isNeedToRepeat;
  final double height;
  final double width;

  const ShowSVGA({
    super.key,
    required this.svgaAssetPath,
    this.isNeedToRepeat = false,
    this.height = 35,
    this.width = 35,
  });

  @override
  Widget build(BuildContext context) {
    // In real app: loads SVGA binary, creates custom painter,
    // renders animation frames using a ticker
    return SizedBox(height: height, width: width, child: const Placeholder());
  }
}

// ---------------------------------------------------------------------------
// PERFORMANCE ISSUES TO FIND (audit this code)
// ---------------------------------------------------------------------------

/// ════════════════════════════════════════════════════════════════════════════
/// AREA 1: Main Layout — Widget Rebuild Hotspot
/// ════════════════════════════════════════════════════════════════════════════

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // StreamBuilder at root — rebuilds everything on stream events
    //!Solution
    // =============================================================================
    // ISSUE #1: StreamBuilder at root rebuilds entire UI every 30s
    // IMPACT: HIGH
    // WHY: Forces full widget tree rebuild even if nothing changed
    // FIX: Move logic to Bloc or isolate rebuild area
    // =============================================================================
    return Stack(
      children: [
        // --- Banner Layer 1: Gift Banner ---
        // ISSUE: BlocBuilder without buildWhen
        //! Solution
        // =============================================================================
        // ISSUE #2 + #3: Multiple BlocBuilders on same bloc + no buildWhen
        // IMPACT: HIGH
        // WHY: Causes redundant rebuilds for same state changes
        // FIX: Merge into ONE BlocBuilder + add buildWhen
        // =============================================================================

        BlocBuilder<FetchUserDataBloc, FetchUserDataState>(
          bloc: di<FetchUserDataBloc>(),
          buildWhen: (prev, curr) => prev.bannerData != curr.bannerData,
          builder: (_, state) {
            final bannerData = state.bannerData;
            return Stack(children: [
              if (bannerData?["gift"] != null)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    color: Colors.amber.withOpacity(0.9),
                    child: Center(child: Text('Gift Banner')),
                  ),
                ),
              if (bannerData?["gift"] != null)
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    color: Colors.blue.withOpacity(0.9),
                    child: Center(child: Text('Game Banner')),
                  ),
                ),
              if (bannerData?["lucky"] != null)
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    color: Colors.green.withOpacity(0.9),
                    child: Center(child: Text('Lucky Banner')),
                  ),
                )
            ]);
          },
        ),
        // BlocBuilder<FetchUserDataBloc, FetchUserDataState>(
        //   bloc: di<FetchUserDataBloc>(),
        //   builder: (_, state) {
        //     final data = state.bannerData?["gift"];
        //     if (data == null) return SizedBox();
        //     return Positioned(
        //       top: 0,
        //       left: 0,
        //       right: 0,
        //       child: Container(
        //         height: 80,
        //         color: Colors.amber.withOpacity(0.9),
        //         child: Center(child: Text('Gift Banner')),
        //       ),
        //     );
        //   },
        // ),

        // --- Banner Layer 2: Game Banner ---
        // ISSUE: ANOTHER BlocBuilder on same BLoC, no buildWhen
        // BlocBuilder<FetchUserDataBloc, FetchUserDataState>(
        //   bloc: di<FetchUserDataBloc>(),
        //   builder: (_, state) {
        //     final data = state.bannerData?["game"];
        //     if (data == null) return SizedBox();
        //     return Positioned(
        //       top: 80,
        //       left: 0,
        //       right: 0,
        //       child: Container(
        //         height: 60,
        //         color: Colors.blue.withOpacity(0.9),
        //         child: Center(child: Text('Game Banner')),
        //       ),
        //     );
        //   },
        // ),

        // --- Banner Layer 3: Lucky Banner ---
        // ISSUE: Yet another BlocBuilder on same BLoC
        // BlocBuilder<FetchUserDataBloc, FetchUserDataState>(
        //   bloc: di<FetchUserDataBloc>(),
        //   builder: (_, state) {
        //     final data = state.bannerData?["lucky"];
        //     if (data == null) return SizedBox();
        //     return Positioned(
        //       bottom: 100,
        //       left: 0,
        //       right: 0,
        //       child: Container(
        //         height: 60,
        //         color: Colors.green.withOpacity(0.9),
        //         child: Center(child: Text('Lucky Banner')),
        //       ),
        //     );
        //   },
        // ),

        // --- Online Badge ---
        // ISSUE: BlocBuilder for single boolean, no buildWhen
        // =============================================================================
        // ISSUE #4: Online badge rebuilds on every state change
        // IMPACT: MEDIUM
        // WHY: Only depends on isOnline
        // FIX: Use BlocSelector
        // =============================================================================
        BlocSelector<FetchUserDataBloc, FetchUserDataState, bool>(
          selector: (state) => state.isOnline,
          builder: (_, isOnline) {
            if (!isOnline) return const SizedBox();
            return Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
        // BlocBuilder<FetchUserDataBloc, FetchUserDataState>(
        //   bloc: di<FetchUserDataBloc>(),
        //   builder: (_, state) {
        //     if (!state.isOnline) return SizedBox();
        //     return Positioned(
        //       top: 10,
        //       right: 10,
        //       child: Container(
        //         width: 12,
        //         height: 12,
        //         decoration: BoxDecoration(
        //           color: Colors.green,
        //           shape: BoxShape.circle,
        //         ),
        //       ),
        //     );
        //   },
        // ),

        // --- Layout Body ---
        BlocBuilder<LayoutBloc, LayoutState>(
          bloc: di<LayoutBloc>(),
          // ISSUE: No buildWhen
          //! Solution
          // =============================================================================
          // ISSUE #5: LayoutBloc rebuilds whole IndexedStack
          // IMPACT: HIGH
          // WHY: No filtering on currentIndex
          // FIX: buildWhen
          // =============================================================================
          buildWhen: (prev, curr) => prev.currentIndex != curr.currentIndex,
          builder: (context, layoutState) {
            return IndexedStack(
              index: layoutState.currentIndex,
              children: [
                _buildHomePage(),
                ChatPage(),
                ProfilePage(),
                SettingsPage(),
              ],
            );
          },
        ),

        // --- Unread Counter ---
        // ISSUE: Two nested BlocBuilders, no buildWhen on either
        //!Solution :
        // =============================================================================
        // ISSUE #6: Nested BlocBuilders → rebuild explosion
        // IMPACT: HIGH
        // WHY: Both blocs trigger rebuilds independently
        // FIX: Use BlocSelector for each
        // =============================================================================

        BlocSelector<FetchUserDataBloc, FetchUserDataState, int>(
          selector: (state) => state.unreadCount,
          builder: (_, unread) {
            return BlocSelector<LayoutBloc, LayoutState, int>(
              selector: (state) => state.currentIndex,
              builder: (_, index) {
                if (index != 1) return const SizedBox();
                return Positioned(
                  bottom: 70,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unread',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                );
              },
            );
          },
        ),
        // BlocBuilder<FetchUserDataBloc, FetchUserDataState>(
        //   bloc: di<FetchUserDataBloc>(),
        //   builder: (_, userState) {
        //     return BlocBuilder<LayoutBloc, LayoutState>(
        //       bloc: di<LayoutBloc>(),
        //       builder: (_, layoutState) {
        //         if (layoutState.currentIndex != 1) return SizedBox();
        //         return Positioned(
        //           bottom: 70,
        //           right: 20,
        //           child: Container(
        //             padding: EdgeInsets.all(6),
        //             decoration: BoxDecoration(
        //               color: Colors.red,
        //               shape: BoxShape.circle,
        //             ),
        //             child: Text(
        //               '${userState.unreadCount}',
        //               style: TextStyle(color: Colors.white, fontSize: 10),
        //             ),
        //           ),
        //         );
        //       },
        //     );
        //   },
        // ),

        // --- Wallet Display ---
        // =============================================================================
        // ISSUE #7: ValueNotifier created inside build
        // IMPACT: HIGH
        // WHY: New instance every rebuild → memory leak + lost state
        // FIX: Move to class level
        // =============================================================================

        _WalletWidget(),
        // ValueListenableBuilder<String>(
        //   valueListenable: ValueNotifier<String>('0'),
        //   builder: (_, value, __) {
        //     return Positioned(
        //       top: 50,
        //       right: 10,
        //       child: Text('💰 $value'),
        //     );
        //   },
        // ),
      ],
    );
  }

  Widget _buildHomePage() {
    // ISSUE: BlocBuilder wraps ENTIRE TabBarView
    // return BlocBuilder<HomeBloc, HomeState>(
    //   bloc: di<HomeBloc>(),
    // No buildWhen — rebuilds ALL tabs when ANY HomeState field changes
    // builder: (context, state) {
    //!Solution:
    // =============================================================================
    // ISSUE #8: Whole Home rebuilt on any state change
    // IMPACT: HIGH
    // WHY: 50+ fields trigger full rebuild
    // FIX: Split using BlocSelector
    // =============================================================================

    return Column(children: [
      // Tab bar
      BlocSelector<HomeBloc, HomeState, int>(
        selector: (state) => state.currentTabIndex,
        builder: (_, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {},
                child: Text('Popular',
                    style: TextStyle(
                      fontWeight:
                          index == 0 ? FontWeight.bold : FontWeight.normal,
                    )),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Live'),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Following'),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Friends'),
              ),
            ],
          );
        },
      ),
      // Tab content — ALL tabs rebuild when any state changes
      //! Solution :
      // =============================================================================
      // ISSUE #9: All lists rebuild unnecessarily
      // IMPACT: HIGH
      // WHY: Each list depends on specific data only
      // FIX: BlocSelector per tab
      // =============================================================================
      Expanded(
        child: BlocSelector<HomeBloc, HomeState, int>(
          selector: (state) => state.currentTabIndex,
          builder: (_, index) {
            return IndexedStack(
              index: index,
              children: [
                // Popular Tab
                BlocSelector<HomeBloc, HomeState, List<dynamic>>(
                  selector: (state) => state.popularRooms,
                  builder: (_, rooms) {
                    return ListView.builder(
                      itemCount: rooms.length,
                      itemBuilder: (_, i) =>
                          ListTile(title: Text('Popular $i')),
                    );
                  },
                ),

                // Live Tab
                BlocSelector<HomeBloc, HomeState, List<dynamic>>(
                  selector: (state) => state.liveRooms,
                  builder: (_, rooms) {
                    return ListView.builder(
                      itemCount: rooms.length,
                      itemBuilder: (_, i) => ListTile(title: Text('Live $i')),
                    );
                  },
                ),

                // Following Tab
                BlocSelector<HomeBloc, HomeState, List<dynamic>>(
                  selector: (state) => state.followRooms,
                  builder: (_, rooms) {
                    return ListView.builder(
                      itemCount: rooms.length,
                      itemBuilder: (_, i) =>
                          ListTile(title: Text('Following $i')),
                    );
                  },
                ),

                // Friends Tab
                BlocSelector<HomeBloc, HomeState, List<dynamic>>(
                  selector: (state) => state.friendsRooms,
                  builder: (_, rooms) {
                    return ListView.builder(
                      itemCount: rooms.length,
                      itemBuilder: (_, i) =>
                          ListTile(title: Text('Friends $i')),
                    );
                  },
                ),
              ],
            );
          },
        ),
      )
      // Expanded(
      //         child: IndexedStack(
      //           index: state.currentTabIndex,
      //           children: [
      //             // Each of these rebuilds even when only popularRooms changed
      //             ListView.builder(
      //               itemCount: state.popularRooms.length,
      //               itemBuilder: (_, i) => ListTile(title: Text('Popular $i')),
      //             ),
      //             ListView.builder(
      //               itemCount: state.liveRooms.length,
      //               itemBuilder: (_, i) => ListTile(title: Text('Live $i')),
      //             ),
      //             ListView.builder(
      //               itemCount: state.followRooms.length,
      //               itemBuilder: (_, i) => ListTile(title: Text('Following $i')),
      //             ),
      //             ListView.builder(
      //               itemCount: state.friendsRooms.length,
      //               itemBuilder: (_, i) => ListTile(title: Text('Friends $i')),
      //             ),
      //           ],
      //         ),
      //       ),
    ]);
  }
}

class _WalletWidget extends StatelessWidget {
  final ValueNotifier<String> walletNotifier = ValueNotifier('0');

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: walletNotifier,
      builder: (_, value, __) {
        return Positioned(
          top: 50,
          right: 10,
          child: Text('💰 $value'),
        );
      },
    );
  }
}

/// ════════════════════════════════════════════════════════════════════════════
/// AREA 2: Bottom Navigation — Heavy Animation Usage
/// ════════════════════════════════════════════════════════════════════════════

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          // ISSUE: SVGA animation for simple tab icon — heavy CPU/memory
          //!Solution:
          // =============================================================================
          // ISSUE #10: Heavy SVGA animations
          // IMPACT: HIGH
          // WHY: Overkill for simple icons
          // FIX: Use Icon instead
          // =============================================================================

          icon: const Icon(Icons.home),
          activeIcon: const Icon(Icons.home_filled),
          label: 'Home',

          // icon: Image.asset('assets/icons/home.png', height: 28, width: 28),
          // activeIcon: ShowSVGA(
          //   svgaAssetPath: 'assets/svga/home_active.svga',
          //   isNeedToRepeat: false,
          //   height: 35,
          //   width: 35,
          // ),
          // label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.chat_outlined),
          activeIcon: const Icon(Icons.chat),
          // icon: Image.asset('assets/icons/chat.png', height: 28, width: 28),
          // activeIcon: ShowSVGA(
          //   svgaAssetPath: 'assets/svga/chat_active.svga',
          //   isNeedToRepeat: false,
          //   height: 35,
          //   width: 35,
          // ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_2_outlined),
          activeIcon: const Icon(Icons.person_2),
          // icon: Image.asset('assets/icons/profile.png', height: 28, width: 28),
          // activeIcon: ShowSVGA(
          //   svgaAssetPath: 'assets/svga/profile_active.svga',
          //   isNeedToRepeat: false,
          //   height: 35,
          //   width: 35,
          // ),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings_outlined),
          activeIcon: const Icon(Icons.settings),
          // icon: Image.asset('assets/icons/settings.png', height: 28, width: 28),
          // activeIcon: ShowSVGA(
          //   svgaAssetPath: 'assets/svga/settings_active.svga',
          //   isNeedToRepeat: false,
          //   height: 35,
          //   width: 35,
          // ),
          label: 'Settings',
        ),
      ],
    );
  }
}

/// ════════════════════════════════════════════════════════════════════════════
/// AREA 3: Static Routes Map
/// ════════════════════════════════════════════════════════════════════════════

class Routes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const profile = '/profile';
  static const settings = '/settings';
  static const room = '/room';
  static const chat = '/chat';
  static const search = '/search';
  static const reels = '/reels';

  // ISSUE: Static map holds all route closures in memory permanently.
  // Each closure captures the DI container and BlocProvider creation.
  //! Solution :
  // =============================================================================
// ISSUE #11: Static routes map memory leak
// IMPACT: HIGH
// FIX: onGenerateRoute
// =============================================================================
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ───────────────── Splash ─────────────────
      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => di<SplashBloc>()),
              BlocProvider(create: (_) => di<ConfigAppBloc>()),
              BlocProvider(create: (_) => di<ColorsBloc>()),
            ],
            child: const SplashPage(),
          ),
        );

      // ───────────────── Auth ─────────────────
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di<LoginBloc>(),
            child: const LoginPage(),
          ),
        );

      case Routes.register:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di<RegisterBloc>(),
            child: const RegisterPage(),
          ),
        );

      // ───────────────── Home ─────────────────
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => di<HomeBloc>()),
              BlocProvider(create: (_) => di<FetchUserDataBloc>()),
            ],
            child: const HomePage(),
          ),
        );

      // ───────────────── Profile ─────────────────
      case Routes.profile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di<ProfileBloc>(),
            child: const ProfilePage(),
          ),
        );

      // ───────────────── Settings ─────────────────
      case Routes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
        );

      // ───────────────── Room ─────────────────
      case Routes.room:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => di<RoomBloc>()),
              BlocProvider(create: (_) => di<FetchUserDataBloc>()),
            ],
            child: const RoomPage(),
          ),
        );

      // ───────────────── Chat ─────────────────
      case Routes.chat:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di<ChatBloc>(),
            child: const ChatPage(),
          ),
        );

      // ───────────────── Search ─────────────────
      case Routes.search:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di<SearchBloc>(),
            child: const SearchPage(),
          ),
        );

      // ───────────────── Reels ─────────────────
      case Routes.reels:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di<ReelsBloc>(),
            child: const ReelsPage(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}

//   static Map<String, Widget Function(BuildContext)> routes = {
//     splash: (context) {
//       return MultiBlocProvider(
//         providers: [
//           BlocProvider.value(value: di<SplashBloc>()),
//           BlocProvider.value(value: di<ConfigAppBloc>()),
//           BlocProvider.value(value: di<ColorsBloc>()),
//         ],
//         child: SplashPage(),
//       );
//     },
//     login: (context) {
//       return BlocProvider.value(
//         value: di<LoginBloc>(),
//         child: LoginPage(),
//       );
//     },
//     register: (context) {
//       return BlocProvider.value(
//         value: di<RegisterBloc>(),
//         child: RegisterPage(),
//       );
//     },
//     home: (context) {
//       return MultiBlocProvider(
//         providers: [
//           BlocProvider.value(value: di<HomeBloc>()),
//           BlocProvider.value(value: di<FetchUserDataBloc>()),
//         ],
//         child: HomePage(),
//       );
//     },
//     profile: (context) {
//       return BlocProvider.value(
//         value: di<ProfileBloc>(),
//         child: ProfilePage(),
//       );
//     },
//     settings: (context) {
//       return SettingsPage();
//     },
//     room: (context) {
//       return MultiBlocProvider(
//         providers: [
//           BlocProvider.value(value: di<RoomBloc>()),
//           BlocProvider.value(value: di<FetchUserDataBloc>()),
//         ],
//         child: RoomPage(),
//       );
//     },
//     chat: (context) {
//       return BlocProvider.value(
//         value: di<ChatBloc>(),
//         child: ChatPage(),
//       );
//     },
//     search: (context) {
//       return BlocProvider.value(
//         value: di<SearchBloc>(),
//         child: SearchPage(),
//       );
//     },
//     reels: (context) {
//       return BlocProvider.value(
//         value: di<ReelsBloc>(),
//         child: ReelsPage(),
//       );
//     },
//     // In the real app, there are 100+ more routes here...
//   };
// }

/// ════════════════════════════════════════════════════════════════════════════
/// AREA 4: Miscellaneous Anti-patterns
/// ════════════════════════════════════════════════════════════════════════════

class MiscIssues {
  // ISSUE: ValueNotifier set twice in immediate succession — first value is wasted
  //!Solution
  // =============================================================================
// ISSUE #12: ValueNotifier overwritten
// IMPACT: LOW
// FIX:
// =============================================================================
  static ValueNotifier<bool> isKeepInRoom = ValueNotifier<bool>(false);

  static void onExitRoom() {
    isKeepInRoom.value = true;
    //  isKeepInRoom.value = false; // Immediately overwrites previous assignment
  }

  // ISSUE: Missing const on widgets that could be const
  //! Solution
  // =============================================================================
// ISSUE #13: Missing const
// IMPACT: MEDIUM
// FIX:
// =============================================================================
  static Widget buildDivider() {
    return const SizedBox(height: 1); // Should be: const SizedBox(height: 1)
  }

  static Widget buildSpacer() {
    return const Spacer(); // Should be: const Spacer()
  }

  static Widget buildEmpty() {
    return const SizedBox.shrink(); // Should be: const SizedBox.shrink()
  }
}

// =============================================================================
// YOUR ANALYSIS
// =============================================================================

// List all issues found below:
//
// ISSUE #1: StreamBuilder at root rebuilds entire UI every 30s
// IMPACT: HIGH
// WHY: Forces full widget tree rebuild regardless of what actually changed.
// FIX:
// Remove StreamBuilder from root and move periodic logic into Bloc/Cubit
// OR isolate it to the smallest widget that needs it.

// ISSUE #2: Multiple BlocBuilders on same FetchUserDataBloc (gift/game/lucky banners)
// IMPACT: HIGH
// WHY: Each BlocBuilder listens to same stream → redundant rebuilds.
// FIX:
// Merge into a single BlocBuilder and render conditionally.

// ISSUE #3: Missing buildWhen on FetchUserDataBloc
// IMPACT: HIGH
// WHY: Rebuilds on ANY state change even if unrelated to UI part.
// FIX:
// buildWhen: (prev, curr) => prev.bannerData != curr.bannerData

// ISSUE #4: Online badge uses BlocBuilder for single boolean
// IMPACT: MEDIUM
// WHY: Rebuilds on all state changes instead of only isOnline.
// FIX:
// Use BlocSelector<bool> to isolate rebuilds.

// ISSUE #5: LayoutBloc rebuilds entire IndexedStack
// IMPACT: HIGH
// WHY: Missing buildWhen → all navigation rebuilds unnecessarily.
// FIX:
// buildWhen: (prev, curr) => prev.currentIndex != curr.currentIndex

// ISSUE #6: Nested BlocBuilders (FetchUserDataBloc + LayoutBloc)
// IMPACT: HIGH
// WHY: Causes combinational rebuild explosion (N × M rebuilds).
// FIX:
// Replace with BlocSelector for each dependency independently.

// ISSUE #7: ValueNotifier created inside build()
// IMPACT: HIGH
// WHY: New instance created on every rebuild → memory waste + state reset.
// FIX:
// Move ValueNotifier to a persistent widget (StatefulWidget or external layer).

// ISSUE #8: HomeBloc rebuilds entire Home UI (50+ fields)
// IMPACT: HIGH
// WHY: Any change in large state triggers full rebuild.
// FIX:
// Use BlocSelector to listen only to required slices (e.g., currentTabIndex).

// ISSUE #9: All tab ListViews rebuild on any HomeState change
// IMPACT: HIGH
// WHY: Lists depend on independent data but are rebuilt together.
// FIX:
// Use separate BlocSelector per tab (popularRooms, liveRooms, etc).

// ISSUE #10: Heavy SVGA animations in BottomNavigationBar
// IMPACT: HIGH
// WHY: SVGA rendering uses CPU/GPU → unnecessary for simple icons.
// FIX:
// Replace with lightweight Icon widgets.

// ISSUE #11: Static routes map keeps all routes in memory
// IMPACT: HIGH
// WHY: All route closures + BlocProviders initialized upfront → memory overhead.
// FIX:
// Replace with onGenerateRoute to lazily build routes.

// ISSUE #12: ValueNotifier overwritten immediately
// IMPACT: LOW
// WHY: First assignment has no effect → redundant operation.
// FIX:
// Set a single meaningful value OR redesign state handling.

// ISSUE #13: Missing const constructors
// IMPACT: MEDIUM
// WHY: Prevents Flutter from optimizing widget rebuilds.
// FIX:
// Use const constructors where possible (SizedBox, Spacer, etc).
//
//
//
//
// SENIOR BONUS #1: onGenerateRoute migration
// -------------------------------------------
// Write the onGenerateRoute method that replaces the static routes map:

// class Routes {
//   static const splash = '/';
//   static const login = '/login';
//   static const register = '/register';
//   static const home = '/home';
//   static const profile = '/profile';
//   static const settings = '/settings';
//   static const room = '/room';
//   static const chat = '/chat';
//   static const search = '/search';
//   static const reels = '/reels';

//   Route<dynamic>? onGenerateRoute(RouteSettings settings) {
//     switch (settings.name) {
// ───────────────── Splash ─────────────────
//       case Routes.splash:
//         return MaterialPageRoute(
//           builder: (_) => MultiBlocProvider(
//             providers: [
//               BlocProvider(create: (_) => di<SplashBloc>()),
//               BlocProvider(create: (_) => di<ConfigAppBloc>()),
//               BlocProvider(create: (_) => di<ColorsBloc>()),
//             ],
//             child: const SplashPage(),
//           ),
//         );

// ───────────────── Auth ─────────────────
//       case Routes.login:
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//             create: (_) => di<LoginBloc>(),
//             child: const LoginPage(),
//           ),
//         );

//       case Routes.register:
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//             create: (_) => di<RegisterBloc>(),
//             child: const RegisterPage(),
//           ),
//         );

// ───────────────── Home ─────────────────
//       case Routes.home:
//         return MaterialPageRoute(
//           builder: (_) => MultiBlocProvider(
//             providers: [
//               BlocProvider(create: (_) => di<HomeBloc>()),
//               BlocProvider(create: (_) => di<FetchUserDataBloc>()),
//             ],
//             child: const HomePage(),
//           ),
//         );

// ───────────────── Profile ─────────────────
//       case Routes.profile:
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//             create: (_) => di<ProfileBloc>(),
//             child: const ProfilePage(),
//           ),
//         );

// ───────────────── Settings ─────────────────
//       case Routes.settings:
//         return MaterialPageRoute(
//           builder: (_) => const SettingsPage(),
//         );

// ───────────────── Room ─────────────────
//       case Routes.room:
//         return MaterialPageRoute(
//           builder: (_) => MultiBlocProvider(
//             providers: [
//               BlocProvider(create: (_) => di<RoomBloc>()),
//               BlocProvider(create: (_) => di<FetchUserDataBloc>()),
//             ],
//             child: const RoomPage(),
//           ),
//         );

// ───────────────── Chat ─────────────────
//       case Routes.chat:
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//             create: (_) => di<ChatBloc>(),
//             child: const ChatPage(),
//           ),
//         );

// ───────────────── Search ─────────────────
//       case Routes.search:
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//             create: (_) => di<SearchBloc>(),
//             child: const SearchPage(),
//           ),
//         );

// ───────────────── Reels ─────────────────
//       case Routes.reels:
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//             create: (_) => di<ReelsBloc>(),
//             child: const ReelsPage(),
//           ),
//         );

//       default:
//         return MaterialPageRoute(
//           builder: (_) => const Scaffold(
//             body: Center(child: Text('Route not found')),
//           ),
//         );
//     }
//   }
// }

//
//
//
// SENIOR BONUS #2: HomeState split proposal
// -------------------------------------------
// How would you split the 50+ field HomeState into focused sub-states?
// List the new states and what fields each would contain:
//
//
// 1. HomeTabsState → UI navigation only
// class HomeTabsState {
//   final int currentTabIndex;
//   const HomeTabsState({this.currentTabIndex = 0});
// }

// 2. PopularRoomsState → handles only popular rooms
// class PopularRoomsState {
//   final List<dynamic> rooms;
//   final int page;
//   const PopularRoomsState({this.rooms = const [], this.page = 1});
// }

// 3. LiveRoomsState
// class LiveRoomsState {
//   final List<dynamic> rooms;
//   final int page;
//   const LiveRoomsState({this.rooms = const [], this.page = 1});
// }

// 4. FollowRoomsState
// class FollowRoomsState {
//   final List<dynamic> rooms;
//   final int page;
//   const FollowRoomsState({this.rooms = const [], this.page = 1});
// }

// 5. FriendsRoomsState
// class FriendsRoomsState {
//   final List<dynamic> rooms;
//   final int page;
//   const FriendsRoomsState({this.rooms = const [], this.page = 1});
// }
