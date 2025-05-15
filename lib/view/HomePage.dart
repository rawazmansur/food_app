import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/Model/DiscussionModel.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:food/database/DatabaseHelper.dart';
import 'package:food/view/TopicsPage.dart';
import 'package:food/view/widgets/HomeCarousel.dart';
import 'package:food/view/widgets/CustomBottomNavigationBar.dart';
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<DiscussionModel>> _discussionsFuture;

  @override
  void initState() {
    super.initState();
    _discussionsFuture = DatabaseHelper().getAllDiscussions();
  }

  final ThemeController _themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final List<String> _carouselImages = [
      'https://scontent.fbgw4-4.fna.fbcdn.net/v/t39.30808-6/495369436_988975476731457_4551646234351932460_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=127cfc&_nc_eui2=AeH_gKadd3hKI6bkyKR5z5TVNT5-K7W0IU01Pn4rtbQhTfeCXUDs7M2HR_jTKFFU3cAnRGxMxV1bCaGNM1xWQeZn&_nc_ohc=LsoEE77FpjUQ7kNvwEu2ryp&_nc_oc=AdnPawhmPLr5vhUZsbs7305yfL0RFOq70dtZJZfABxZgZsjOcsY6hRSvXQ-DQXWkZEc&_nc_zt=23&_nc_ht=scontent.fbgw4-4.fna&_nc_gid=APHwjM1wE7YD3N4BeHXAAg&oh=00_AfIDt0Tms1fQ9ne1Bs5-fcafRPfoVUipc0VndhxToa3A9A&oe=6827D44D',
      'https://scontent.fbgw4-4.fna.fbcdn.net/v/t39.30808-6/495369436_988975476731457_4551646234351932460_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=127cfc&_nc_eui2=AeH_gKadd3hKI6bkyKR5z5TVNT5-K7W0IU01Pn4rtbQhTfeCXUDs7M2HR_jTKFFU3cAnRGxMxV1bCaGNM1xWQeZn&_nc_ohc=LsoEE77FpjUQ7kNvwEu2ryp&_nc_oc=AdnPawhmPLr5vhUZsbs7305yfL0RFOq70dtZJZfABxZgZsjOcsY6hRSvXQ-DQXWkZEc&_nc_zt=23&_nc_ht=scontent.fbgw4-4.fna&_nc_gid=APHwjM1wE7YD3N4BeHXAAg&oh=00_AfIDt0Tms1fQ9ne1Bs5-fcafRPfoVUipc0VndhxToa3A9A&oe=6827D44D',
      'https://scontent.fbgw4-4.fna.fbcdn.net/v/t39.30808-6/495369436_988975476731457_4551646234351932460_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=127cfc&_nc_eui2=AeH_gKadd3hKI6bkyKR5z5TVNT5-K7W0IU01Pn4rtbQhTfeCXUDs7M2HR_jTKFFU3cAnRGxMxV1bCaGNM1xWQeZn&_nc_ohc=LsoEE77FpjUQ7kNvwEu2ryp&_nc_oc=AdnPawhmPLr5vhUZsbs7305yfL0RFOq70dtZJZfABxZgZsjOcsY6hRSvXQ-DQXWkZEc&_nc_zt=23&_nc_ht=scontent.fbgw4-4.fna&_nc_gid=APHwjM1wE7YD3N4BeHXAAg&oh=00_AfIDt0Tms1fQ9ne1Bs5-fcafRPfoVUipc0VndhxToa3A9A&oe=6827D44D',
    ];

    return Obx(
      () => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: _themeController.scaffold,
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
               
                },
                icon: Icon(
                  Icons.info_outline,
                  color: _themeController.textAppBar,
                ),
              ),
            ],
            centerTitle: true,
            title: Text(
              'بەرنامەی خۆراکی پێغەمبەر ﷺ',
              style: TextStyle(
                fontSize: 20.sp,
                fontFamily: 'ZainPeet',
                color: _themeController.textAppBar,
              ),
            ),
            backgroundColor: _themeController.appBar,
          ),
          body: FutureBuilder<List<DiscussionModel>>(
            future: _discussionsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No discussions found.'));
              }

              final discussions = snapshot.data!;

              return ListView(
                children: [
                  HomeCarousel(images: _carouselImages),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: discussions.length,
                    itemBuilder: (context, index) {
                      final discussion = discussions[index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 22.w,
                          vertical: 7.h,
                        ),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:
                                _themeController.isDarkMode.value
                                    ? [
                                      const Color.fromARGB(255, 41, 41, 41),
                                      const Color.fromARGB(255, 67, 67, 67),
                                    ]
                                    : const [
                                      Color.fromARGB(255, 166, 196, 247),
                                      Color.fromARGB(255, 116, 166, 252),
                                    ],
                            stops: [0.0, 1.0],
                            begin: FractionalOffset.topRight,
                            end: FractionalOffset.bottomLeft,
                            tileMode: TileMode.clamp,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              () => TopicsPage(discussionId: discussion.id),
                            );
                          },

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  discussion.title,
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                    color: _themeController.textContainer,
                                    fontFamily: 'ZainPeet',
                                  ),
                                ),
                              ),
                              Container(
                                width: 27.w,
                                height: 27.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  discussion.id.toString(),
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: _themeController.textNumbers,
                                    fontFamily: 'ZainPeet',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
        ),
      ),
    );
  }
}
