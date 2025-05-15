import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:get/get.dart';

class Youtubepage extends StatefulWidget {
  const Youtubepage({super.key});

  @override
  State<Youtubepage> createState() => _YoutubepageState();
}

class _YoutubepageState extends State<Youtubepage> {
  ThemeController themeController = Get.find();

  // Sample list of YouTube videos
  final List<Map<String, String>> youtubeVideos = [
    {
      'title': '١٦- ١- بەرنامەى خۆراك (حيكمەتى خۆراكى پێغەمبەر)',
      'url': 'https://youtu.be/ROp3WMeMljM?si=F2322wHkZ2hAkFfJ',
    },
    {
      'title': '(١٦- ٢- بەرنامەى خۆراك خواردن بە بەرنامە)',
      'url': 'https://youtu.be/C3qyE4MNiJ8?si=2hx3GdRMYHEOqBBE',
    },
    {
      'title': '١٦- ٣- بەرنامەى خۆراك (زيادەڕەويى لە خواردندان)',
      'url': 'https://youtu.be/ed5hjPwRqF0?si=nEwkJ1ux_iJTxwzC',
    },
    {
      'title': '١٦- ٤- بەرنامەى خۆراك (دەستگرتنەوە لە زيادەخۆريى))',
      'url': 'https://youtu.be/6-p7Fmyrmmg?si=vofMcnZiYCIXp4th',
    },
    {
      'title': '١٦- ٥- بەرنامەى خۆراك (پاشماوەى خواردن))',
      'url': 'https://youtu.be/ey-UlXb6kKg?si=D8gubomnwc_tkcUY',
    },
    {
      'title': '١٦- ٦- بەرنامەى خۆراك (چارەسەر و خۆپاراستن)',
      'url': 'https://youtu.be/ffpJEiEe7uQ?si=KXU9XTwCjg8nwaAY',
    },
    {
      'title': '١٦- ٧- بەرنامەى خۆراك (قەڵەويى)',
      'url': 'https://youtu.be/tFOQZwRZz04?si=5ynrmFBOFRwt5-KE',
    },
    {
      'title': '١٦- ٨- بەرنامەى خۆراك (رێژەى خواردن)',
      'url': 'https://youtu.be/TBGSplsbDVY?si=HQHT7RYJCj3lUCdN',
    },
    {
      'title': '١٦- ٩- بەرنامەى خۆراك (رێجيم كردن)',
      'url': 'https://youtu.be/-amIquQXjP4?si=0cELsJy1c2q_D4Dd',
    },
    {
      'title': '١٦- ١٠- بەرنامەى خۆراك (پێغەمبەرى خوا چى خواردووە؟)',
      'url': 'https://youtu.be/vgf6qrWAM6w?si=6vh6Cjgw68AASprA',
    },
    {
      'title': '١٦- ١١- بەرنامەى خۆراك (چۆن و چەندە بخۆين ؟)',
      'url': 'https://youtu.be/-amIquQXjP4?si=vUR4O7BQUSLtcZJ7',
    },
    {
      'title': '١٦- ١٢- بەرنامەى خۆراك (خورما -١-)',
      'url': 'https://youtu.be/CMQrnalmYjQ?si=aI6pofs547BmrAZy',
    },
    {
      'title': '١٦- ١٣- بەرنامەى خۆراك (خورما -٢-)',
      'url': 'https://youtu.be/XVpJK4y30bU?si=vqHcJgd68yNcq_Uh',
    },
    {
      'title': '١٦- ١٤- بەرنامەى خۆراك (شير -١-)',
      'url': 'https://youtu.be/_9yNb8aUqe0?si=SPUJEiJb_MUCf8N8',
    },
    {
      'title': '١٦- ١٥- بەرنامەى خۆراك (شير -٢-)',
      'url': 'https://youtu.be/dZC7JmKWuI0?si=OyTUc1_zDFwONkBc',
    },
    {
      'title': '١٦- ١٦- بەرنامەى خۆراك (زەيتى زەيتوون -١-)',
      'url': 'https://youtu.be/Gsj4_ftgGR8?si=8Ady6Bbpx3K-0URq',
    },
    {
      'title': '١٦- ١٧- بەرنامەى خۆراك (زەيتى زەيتوون -٢-)',
      'url': 'https://youtu.be/bDIxmhJKJqU?si=jl5frkfrfigCtylv',
    },
    {
      'title': '١٦- ١٨- بەرنامەى خۆراك (زەيتى زەيتوون -٣-)',
      'url': 'https://youtu.be/SyxBbpKeCW8?si=IBLAMgfUt1moCxAz',
    },
    {
      'title': '١٦- ١٩- بەرنامەى خۆراك (سركە)',
      'url': 'https://youtu.be/ZYQbxTPQ8I8?si=GjYtEDTI2ZsCnwWv',
    },
    {
      'title': '١٦- ٢١- بەرنامەى خۆراك (گۆشت)',
      'url': 'https://youtu.be/jp0Flaq2E4g?si=F5JxuObPbG-i7oFv',
    },
    {
      'title': '١٦- ٢٢- بەرنامەى خۆراك (گۆشتى سوور)',
      'url': 'https://youtu.be/HvCMXo6dH4c?si=9e1iRu9KPNGyz4Ux',
    },
    {
      'title': '١٦- ٢٣- بەرنامەى خۆراك (گۆشتى سپی)',
      'url': 'https://youtu.be/lSE5c5zMGbE?si=QmhIxGrBfAKKu_Eb',
    },
    {
      'title': '١٦- ٢٤- بەرنامەى خۆراك (هەنگوين -١-)',
      'url': 'https://youtu.be/vL962N2vFV4?si=WqcB0CuTU1y-rLTY',
    },
    {
      'title': '١٦- ٢٥- بەرنامەى خۆراك (هەنگوين -٢-)',
      'url': 'https://youtu.be/7KhoIZvxjQQ?si=A_E0jl-fpYlVAL02',
    },
    {
      'title': '١٦- ٢٥- بەرنامەى خۆراك (هەنگوين -3-)',
      'url': 'https://youtu.be/cxWY_rWBdQs?si=Mtj7UYVeVr6yggYb',
    },
    {
      'title': '١٦- ٢٧- بەرنامەى خۆراك (ميوە)',
      'url': 'https://youtu.be/LmvoaxU5-mU?si=ck05RQFO_VpPkM2c',
    },
    {
      'title': '١٦- ٢٨- بەرنامەى خۆراك (ئەنجامى بەرنامەى خۆراكى پێغەمبەر)',
      'url': 'https://youtu.be/HKP8SzPrfNU?si=7IOBTjNhd_JEEA1a',
    },
    {
      'title': '١٦- ٢٩- بەرنامەى خۆراك (هێڵە گشتييەكانى بەرنامەى خۆراكى پێغەمبەر) کۆتایی',
      'url': 'https://youtu.be/7ToEgWOHoq0?si=jFyMsGokWwmMDO2K',
    },

    // Add more videos as needed
  ];

  // Function to launch the URL in the browser or YouTube app
  Future<void> launchURL(String url) async {
    await FlutterWebBrowser.openWebPage(
      url: url,
      customTabsOptions: CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.dark,
        toolbarColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: themeController.scaffold,
        appBar: AppBar(
          backgroundColor: themeController.scaffold,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: themeController.textAppBar),
            onPressed: () => Get.back(),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  'کۆی وتارە ڤیدیۆەیەکان',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'ZainPeet',
                    color: themeController.textAppBar,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: ListView.builder(
            itemCount: youtubeVideos.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Future.microtask(
                    () => launchURL(youtubeVideos[index]['url']!),
                  );
                },

                child: Card(
                  color: themeController.scaffold,
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.video_library,
                          color: themeController.textAppBar,
                          size: 30.sp,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            youtubeVideos[index]['title']!,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: themeController.textAppBar,
                              fontFamily: 'ZainPeet',
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
