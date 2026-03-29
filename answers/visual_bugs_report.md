# Visual Bugs Report — Exercise 7

---

## Bug #1: Crash when room has no cover image
- **Where:** RoomCard → Cover Image  
- **Steps to reproduce:**
  1. Run the app
  2. Scroll to the second room ("Chill Zone")
- **Expected behavior:**  
  A placeholder image should be displayed when no cover exists
- **Actual behavior:**  
  App crashes due to null value used in image loading
- **Screenshot:** Find at answers/screenshots/exercise_7_bug_1.png 
![Exercise 7 Bug Screenshot](answers/screenshots/exercise_7_bug_1.png)
- **Severity:** Critical  
- **Proposed fix:**  
  Add null check and fallback placeholder for image and It is Better to add a reusabale widget to handle this situation
  Code Snippet :
  CachedImage(
  imageUrl: room.coverUrl,
  width: 80.w,
  height: 80.w,
  borderRadius: BorderRadius.circular(8.r),
)
if (imageUrl == null || imageUrl!.trim().isEmpty) {
  return _buildErrorImage();
}
---

## Bug #2: LIVE badge misplaced (Stack Issue)
- **Where:** RoomCard → Cover Image  
- **Steps to reproduce:**
  1. Run the app
  2. Observe rooms marked as live
- **Expected behavior:**  
  LIVE badge appears correctly on top of the image  
- **Actual behavior:**  
  Badge is not rendered properly due to incorrect layout usage  
- **Screenshot:** Find at answers/screenshots/exercise_7_bug_2.png 
![Exercise 7 Bug Screenshot](answers/screenshots/exercise_7_bug_2.png)

- **Severity:** High  
- **Proposed fix:**  
  Wrap image in a Stack and correctly position the badge over the Room Image
  Code Snippet :
  Stack(
  children: [
    CachedImage(
      imageUrl: room.coverUrl,
      width: 80.w,
      height: 80.w,
      borderRadius: BorderRadius.circular(8.r),
    ),
    if (room.isLive)
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            'LIVE',
            style: TextStyle(color: AppColors.white, fontSize: 8.sp),
          ),
        ),
      ),
  ],
)
---

## Bug #3: Room name text overflows
- **Where:** RoomCard → Room Name  
- **Steps to reproduce:**
  1. Run the app
  2. Observe rooms with long titles especially first and third image
- **Expected behavior:**  
  Text should end with ellipsis  
- **Actual behavior:**  
  Text overflows and breaks layout  
- **Screenshot:** Find at answers/screenshots/exercise_7_bug_3.png 
![Exercise 7 Bug Screenshot](answers/screenshots/exercise_7_bug_3.png)

- **Severity:** High  
- **Proposed fix:**  
  Apply maxLines and overflow handling
  Code Snippet :
  Expanded(
  child: Text(
    room.roomName,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.black,
    ),
  ),
)

---


## Bug #4: "null" text displayed in UI
- **Where:** RoomCard → Room Intro & Country Flag  
- **Steps to reproduce:**
  1. Run the app
  2. Observe second room
- **Expected behavior:**  
  Empty or hidden widget when data is null  
- **Actual behavior:**  
  Literal "null" text is displayed  
- **Screenshot:** Find at answers/screenshots/exercise_7_bug_4.png 
![Exercise 7 Bug Screenshot](answers/screenshots/exercise_7_bug_4.png)

- **Severity:** Medium  
- **Proposed fix:**  
  Add null checks before rendering text
  Code Snippet :
  Text(
  room.roomIntro ?? "",
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
if (room.countryFlag != null)
  Text(room.countryFlag!)

---

## Bug #5: Missing spacing between elements
- **Where:** RoomCard → Multiple sections  
- **Steps to reproduce:**
  1. Run the app
  2. Observe layout spacing
- **Expected behavior:**  
  Proper spacing between UI elements  
- **Actual behavior:**  
  Elements appear cramped and cluttered  
- **Screenshot:** Find at answers/screenshots/exercise_7_bug_5.png 
![Exercise 7 Bug Screenshot](answers/screenshots/exercise_7_bug_5.png)

- **Severity:** Medium  
- **Proposed fix:**  
  Add SizedBox spacing between widgets
  Code Snippet :
  Const SizedBox(width: 10.w),
  Const SizedBox(width: 6.w),

---



## Bug #6: Hardcoded dimensions break responsiveness
- **Where:** RoomCard layout  
- **Steps to reproduce:**
  1. Run on different screen sizes
  2. Rotate device
- **Expected behavior:**  
  Layout adapts responsively  
- **Actual behavior:**  
  UI appears cramped or misaligned  
- **Screenshot:** Find at answers/screenshots/exercise_7_bug_6.png 
![Exercise 7 Bug Screenshot](answers/screenshots/exercise_7_bug_6.png)

- **Severity:** Medium  
- **Proposed fix:**  
  Replace fixed sizes with flexible layouts
  Code Snippet :
  margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
  padding: EdgeInsets.all(5.w),
  SizedBox (
   // without restricted width or height
    CacheImage()
  )

---

## Bug #7: No loading or error state for images
- **Where:** Cover Image  
- **Steps to reproduce:**
  1. Simulate slow or no internet
- **Expected behavior:**  
  Show loading indicator or fallback image  
- **Actual behavior:**  
  Blank space or flickering occurs  
- **Screenshot:** Find at answers/screenshots/exercise_7_bug_7.png 
![Exercise 7 Bug Screenshot](answers/screenshots/exercise_7_bug_7.png)

- **Severity:** Medium  
- **Proposed fix:**  
  Add loadingBuilder and errorBuilder
  Code Snippet :
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

errorWidget: (context, url, error) => _buildErrorImage(),

---
## Bug #8: Status bar overlap (Missing SafeArea)
- **Where:** RoomCardList → Scaffold body (top of screen under AppBar / status bar)
- **Steps to reproduce:**
   1. Run the app on a device with a notch (or enable status bar overlay)
   2. Observe the top area of the screen
- **Expected behavior:**  
  Content should respect system UI (status bar / notch) and not overlap  
- **Actual behavior:**  
  Content may render under the status bar, causing visual overlap or clipped UI
- **Screenshot:** Find at answers/screenshots/exercise_7_bug_8.png 
![Exercise 7 Bug Screenshot](answers/screenshots/exercise_7_bug_8.png)

- **Severity:** Medium  
- **Proposed fix:** 
 Wrap the Whole Screen With Safe Area Widget
  Code Snippet :
  @override
  Widget build(BuildContext context) {
    return SafeArea( Scaffold(
      body: CustomScrollView(
        slivers: [ ] )))}

---
# Summary

- **Total Bugs:** 8 
- **Critical:** 1  
- **High:** 2  
- **Medium:** 5  

---

## Fixed Screen can be Found at : answers/screenshots/exercise_7_fixed.png
![Exercise 7 Fixed Screenshot](answers/screenshots/exercise_7_fixed.png)


## Notes

This report focuses on:
- Real user-facing UI/UX issues
- Runtime crashes and stability
- Responsiveness and layout behavior
- Data handling and visual polish