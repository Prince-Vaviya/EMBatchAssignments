import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Like state
  int likes = 0;
  bool isLiked = false;

  // Like button function
  void toggleLike() {
    setState(() {
      if (isLiked) {
        likes--;
        isLiked = false;
      } else {
        likes++;
        isLiked = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ==========================================
      // APP BAR
      // ==========================================

      appBar: AppBar(
        backgroundColor: Colors.white,

        title: const Text(
          'Instagram',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          IconButton(
            onPressed: () {},

            icon: const Icon(
              Icons.favorite_border,
            ),
          ),

          IconButton(
            onPressed: () {},

            icon: const Icon(
              Icons.send_outlined,
            ),
          ),
        ],
      ),

      // ==========================================
      // BODY
      // ==========================================

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // ======================================
            // PROFILE SECTION
            // ======================================

            Padding(
              padding: const EdgeInsets.all(16),

              child: Row(
                children: [

                  // Profile Icon
                  Container(
                    width: 50,
                    height: 50,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      border: Border.all(
                        width: 2,
                      ),
                    ),

                    child: const Icon(
                      Icons.person,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Username
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          'flutter_student',

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 3),

                        Text(
                          'Learning Flutter',

                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Follow Button
                  ElevatedButton(
                    onPressed: () {},

                    child: const Text(
                      'Follow',
                    ),
                  ),
                ],
              ),
            ),

            // ======================================
            // POST
            // ======================================

            Container(
              width: double.infinity,
              height: 350,

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,

                  colors: [
                    Color(0xFFFFD54F),
                    Color(0xFFFF7043),
                    Color(0xFFE91E63),
                    Color(0xFF673AB7),
                  ],
                ),
              ),

              child: const Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [

                    Icon(
                      Icons.flutter_dash,

                      size: 100,

                      color: Colors.white,
                    ),

                    SizedBox(height: 15),

                    Text(
                      'Flutter',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      'Build beautiful apps',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ======================================
            // POST ACTIONS
            // ======================================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),

              child: Row(
                children: [

                  // LIKE
                  IconButton(
                    onPressed: toggleLike,

                    icon: Icon(

                      isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,

                      size: 30,

                      color: isLiked
                          ? Colors.red
                          : Colors.black,
                    ),
                  ),

                  // COMMENT
                  IconButton(
                    onPressed: () {},

                    icon: const Icon(
                      Icons.chat_bubble_outline,
                      size: 28,
                    ),
                  ),

                  // SHARE
                  IconButton(
                    onPressed: () {},

                    icon: const Icon(
                      Icons.send_outlined,
                      size: 28,
                    ),
                  ),

                  const Spacer(),

                  // SAVE
                  IconButton(
                    onPressed: () {},

                    icon: const Icon(
                      Icons.bookmark_border,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            // ======================================
            // LIKE COUNT
            // ======================================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Text(
                '$likes likes',

                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ======================================
            // CAPTION
            // ======================================

            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Text(
                'flutter_student '
                'Learning Flutter one widget at a time! 🚀',

                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ======================================
            // LIKE BUTTON
            // ======================================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(

                  onPressed: toggleLike,

                  icon: Icon(
                    isLiked
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),

                  label: Text(
                    isLiked
                        ? 'Liked'
                        : 'Like this post',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}