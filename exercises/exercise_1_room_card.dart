// =============================================================================
// EXERCISE 1: UI & Layout — "Room Card Widget"
// Time: 30 minutes
// =============================================================================
//
// SCENARIO:
// You're building a social/live-streaming app. The home screen shows a list
// of active rooms. Each room is displayed as a card with the room's cover image,
// name, intro text, visitor count, country flag, and status icons.
//
// The previous developer left a broken implementation. Your job is to fix it
// and improve it.
//
// TASKS:
// 1. [All Levels] Fix the layout bugs (overflow, alignment, null handling)
// 2. [Mid+] Add a shimmer loading state for the image
// 3. [Mid+] Make the card responsive (don't use hardcoded pixel values)
// 4. [Senior] Add const constructors throughout where possible
// 5. [Senior] Create a reusable CachedImage widget with loading/error/success states
// 6. [Senior] Add RepaintBoundary where appropriate
//
// RULES:
// - You may add any Flutter/Dart packages you need (shimmer, cached_network_image, etc.)
// - Focus on code quality, not just making it "work"
// - Consider edge cases (null data, long text, missing images)
// =============================================================================

// ignore_for_file: unused_element

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

// ---------------------------------------------------------------------------
// DATA MODEL (do not modify)
// ---------------------------------------------------------------------------

class RoomEntity {
  final int id;
  final String roomName;
  final String? roomIntro;
  final String? coverUrl;
  final int visitorsCount;
  final String? countryFlag; // emoji flag like "🇺🇸"
  final bool isLive;
  final bool hasPassword;
  final String? ownerName;
  final String? ownerAvatarUrl;

  const RoomEntity({
    required this.id,
    required this.roomName,
    this.roomIntro,
    this.coverUrl,
    this.visitorsCount = 0,
    this.countryFlag,
    this.isLive = false,
    this.hasPassword = false,
    this.ownerName,
    this.ownerAvatarUrl,
  });
}

// ---------------------------------------------------------------------------
// SAMPLE DATA (do not modify)
// ---------------------------------------------------------------------------

final sampleRooms = [
  RoomEntity(
    id: 1,
    roomName: 'Welcome to the Super Amazing Party Room 🎉🎉🎉',
    roomIntro: 'Join us for music and fun! Everyone is welcome.',
    coverUrl: 'https://picsum.photos/200/200',
    visitorsCount: 1234,
    countryFlag: '🇺🇸',
    isLive: true,
    hasPassword: false,
    ownerName: 'DJ_Master',
    ownerAvatarUrl: 'https://picsum.photos/50/50',
  ),
  RoomEntity(
    id: 2,
    roomName: 'Chill Zone',
    roomIntro: null, // No intro set
    coverUrl: null, // No cover image
    visitorsCount: 0,
    countryFlag: '🇹🇷',
    isLive: false,
    hasPassword: true,
    ownerName: 'Relaxer',
  ),
  RoomEntity(
    id: 3,
    roomName: 'Gaming Arena - Competitive Matches Every Hour - Join Now!',
    roomIntro: 'Competitive gaming room with hourly tournaments and prizes for top players',
    coverUrl: 'https://picsum.photos/200/201',
    visitorsCount: 56789,
    countryFlag: null, // No country
    isLive: true,
    hasPassword: false,
  ),
];

// ---------------------------------------------------------------------------
// BROKEN IMPLEMENTATION (fix this)
// ---------------------------------------------------------------------------

class RoomCardList extends StatelessWidget {
  const RoomCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Rooms')),
        body:
            //  ListView(
            // BUG: Should use ListView.builder for performance
            //   children: sampleRooms.map((room) => RoomCard(room: room)).toList(),
            // ),

            //! Solution: Use ListView.builder for better performance with large lists
            ListView.builder(
          itemCount: sampleRooms.length,
          itemBuilder: (context, index) {
            final room = sampleRooms[index];
            return RoomCard(room: room);
          },
        ));
  }
}

class RoomCard extends StatelessWidget {
  final RoomEntity room;

  // BUG: Missing const constructor
  //  RoomCard({required this.room});
  //! Solution: Add const constructor for better performance and immutability
  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    //! Solution: Add RepaintBoundary to isolate repaints for better performance
    return RepaintBoundary(
      child: Container(
        // BUG: Hardcoded margin and dimensions
        //  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        //! Solution: Use responsive sizing with flutter_screenutil
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // --- Cover Image ---
            // BUG: No loading state, no error handling, no placeholder
            // Container(
            // width: 80,
            // height: 80,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(8),
            //   image: DecorationImage(
            //     // BUG: Will crash if coverUrl is null
            //     image: NetworkImage(room.coverUrl!),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            SizedBox(
              // width: 80.w,
              // height: 80.h,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(8),
              //   image: DecorationImage(
              // BUG: Will crash if coverUrl is null
              //     image: NetworkImage(room.coverUrl!),
              //     fit: BoxFit.cover,
              //   ),
              // ),
              child: Stack(children: [
                //! Solution: Use CachedNetworkImage for better performance and built-in loading/error handling
                CachedImage(
                  imageUrl: room.coverUrl,
                  width: 80.w,
                  height: 80.w,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                //! Solution: Place Positioned inside Stack

                if (room.isLive)
                  Positioned(
                    // BUG: Positioned outside of Stack
                    top: 0,
                    left: 0,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'LIVE',
                        style:
                            TextStyle(color: AppColors.white, fontSize: 8.sp),
                      ),
                    ),
                  )
              ]),
            ),
            // BUG: No spacing between image and text
            //! Solution: Add spacing
            SizedBox(width: 10.w),
            // --- Room Info ---
            //! Solution: Wrap Column with Expanded to prevent overflow and allow flexible width
            Expanded(
              child: Column(
                // BUG: Column not wrapped in Expanded, will overflow
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Room Name + Visitor Count
                  Row(
                    children: [
                      // BUG: Text will overflow on long names
                      // Text(
                      //   room.roomName,
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w600,
                      //     color: Colors.black,
                      //   ),
                      // ),
                      //! Solution: Add Expanded + overflow handling

                      Expanded(
                        child: Text(
                          room.roomName ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      // BUG: No spacing

                      //! Solution: Add spacing
                      SizedBox(width: 6.w),
                      _VisitorCount(count: room.visitorsCount),
                    ],
                  ),
                  // Row 2: Room Intro
                  Text(
                    // BUG: Will show "null" if roomIntro is null
                    //  room.roomIntro.toString(),
                    //! Solution: Handle null case gracefully
                    room.roomIntro ?? "",
                    //! Solution: Add maxLines and overflow handling to prevent layout issues with long intros
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.greyText,
                    ),
                    // BUG: No maxLines or overflow handling
                  ),
                  // Row 3: Country + Lock icon
                  Row(
                    children: [
                      // BUG: Will show "null" text if no country flag
                      // Text(room.countryFlag.toString(),
                      //     style: TextStyle(fontSize: 16)),
                      //! Solution: Conditional rendering
                      if (room.countryFlag != null)
                        Text(
                          room.countryFlag!,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      // BUG: No spacing
                      //! Solution: Add spacing
                      if (room.countryFlag != null && room.hasPassword)
                        SizedBox(width: 6.w),
                      if (room.hasPassword)
                        Icon(Icons.lock, size: 14, color: AppColors.primary),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisitorCount extends StatelessWidget {
  final int count;

  // BUG: Missing const, missing key
  //  _VisitorCount({required this.count});
  //! Solution: Add const constructor for better performance and immutability
  const _VisitorCount({
    super.key,
    required this.count,
  });
  String formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.visibility, size: 12, color: Colors.grey),
        SizedBox(width: 2),
        Text(
          // BUG: Should format large numbers (1234 → 1.2K)
          //count.toString(),
          //! Solution: Format large numbers for better readability
          formatCount(count),
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// BONUS: Color constants (for reference)
// ---------------------------------------------------------------------------

class AppColors {
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const greyText = Color(0xFFa5a7a4);
  static const primary = Color(0xFF32e5ac);
  static const shimmerBase = Color(0xFFE0E0E0);
  static const shimmerHighlight = Color(0xFFF5F5F5);
}

// Reusable Widgets and utilities
class CachedImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String errorAsset;
  final BorderRadius? borderRadius;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorAsset = 'assets/images/svg/utd-logo.svg',
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    /// 🔒 Handle null or empty URL early
    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return _buildErrorImage();
    }

    Widget image = CachedNetworkImage(
      imageUrl: imageUrl!,

      width: width,
      height: height,
      fit: fit,

      /// 🔄 Loading
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.shimmerBase,
            borderRadius: borderRadius ?? BorderRadius.circular(0),
          ),
        ),
      ),

      /// ❌ Error
      errorWidget: (context, url, error) => _buildErrorImage(),
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }

  /// 🧱 Fallback widget
  Widget _buildErrorImage() {
    return SvgPicture.asset(
      errorAsset,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
