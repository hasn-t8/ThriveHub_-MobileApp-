// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:thrive_hub/core/utils/no_page_found.dart';
// import 'package:thrive_hub/screens/business/widgets/profile_section.dart';
// import 'package:thrive_hub/services/auth_services/auth_service.dart';
// import 'package:thrive_hub/widgets/appbar.dart';
// import 'package:thrive_hub/widgets/profile_listitem.dart';
// import 'package:thrive_hub/core/utils/image_picker.dart';
//
// class BusinessProfileScreen extends StatefulWidget {
//   @override
//   _BusinessProfileScreenState createState() => _BusinessProfileScreenState();
// }
//
// class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
//   String _full_name = '';
//   String _email = '';
//   String _profileImageUrl = 'assets/avtar.jpg'; // Default image path
//   String _role = 'ceo'; // Default role for demonstration
//   bool _isLoading = false;
//   File? _image;
//
//   int reviewsCount = 234;
//   int titleCount = 47;
//   int projectsCount = 15;
//
//   List<Map<String, String>> get infoBoxes => [
//     {'title': '$reviewsCount', 'subtitle': 'Reviews'},
//     {'title': '$titleCount', 'subtitle': 'Title'},
//     {'title': '$projectsCount', 'subtitle': 'Projects'},
//   ];
//
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//
//   }
//
//   Future<void> _logout(BuildContext context) async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     AuthService logoutService = AuthService();
//     final result = await logoutService.logout();
//
//     setState(() {
//       _isLoading = false;
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(result['message']),
//     ));
//
//     if (result['success']) {
//       Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
//     }
//   }
//   Future<void> _loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Retrieve data from shared preferences
//     final fullName = prefs.getString('full_name') ?? 'Name'; // Default to 'Name' if null
//     final email = prefs.getString('email') ?? 'email@example.com'; // Default to example email
//     final profileImage = prefs.getString('profile_image');
//     final List<String>? userTypes = prefs.getStringList('user_types');
//     final role = userTypes?.isNotEmpty ?? false ? userTypes!.first : 'business-owner'; // Default to 'business-owner'
//
//     // Update the UI fields with the retrieved data
//     setState(() {
//       _full_name = fullName;
//       _email = email;
//       _role = role;
//
//       if (profileImage != null) {
//         _profileImageUrl = profileImage; // Assuming this is a URL
//       }
//     });
//   }
//
//
//   Future<void> _onImageIconPressed() async {
//     File? selectedImage = await pickImageWithUI(context);
//     if (selectedImage != null) {
//       setState(() {
//         _image = selectedImage;
//       });
//       await _uploadImage(selectedImage);
//     }
//   }
//
//   Future<void> _uploadImage(File image) async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     // Replace with your API endpoint
//     const String apiUrl = 'https://your-api-url.com/upload';
//
//     try {
//       var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//       request.files.add(await http.MultipartFile.fromPath('image', image.path));
//       var response = await request.send();
//
//       if (response.statusCode == 200) {
//         var responseData = await response.stream.bytesToString();
//         var jsonResponse = jsonDecode(responseData);
//
//         setState(() {
//           _profileImageUrl = jsonResponse['image_url']; // Assuming the API returns the image URL
//         });
//       } else {
//         print('Failed to upload image. Status Code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error uploading image: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   List<Map<String, dynamic>> _getProfileItemsForRole(String role) {
//     // Common items for all roles
//     List<Map<String, dynamic>> commonItems = [
//       {
//         'icon': Icons.help,
//         'text': 'Help Center',
//         'trailingIcon': Icons.arrow_forward_ios,
//         'onTap': () {
//           Navigator.pushNamed(context, '/business-help-center');
//         },
//       },
//       {
//         'icon': Icons.logout,
//         'text': _isLoading ? 'Logging out...' : 'Logout',
//         'trailingIcon': Icons.arrow_forward_ios,
//         'onTap': () {
//           _logout(context);
//         },
//       },
//     ];
//
//     // Role-specific items
//     List<Map<String, dynamic>> roleItems = [];
//     switch (role) {
//       case 'admin':
//         roleItems = [
//           {
//             'icon': Icons.notifications,
//             'text': 'Notification',
//             'trailingIcon': Icons.arrow_forward_ios,
//             'onTap': () {
//               Navigator.pushNamed(context, '/business-notification');
//             },
//           },
//           {
//             'icon': Icons.settings,
//             'text': 'Edit Account',
//             'trailingIcon': Icons.arrow_forward_ios,
//             'onTap': () {
//               Navigator.pushNamed(context, '/business-account-settings');
//             },
//           },
//         ];
//         break;
//
//       case 'business-owner':
//         roleItems = [
//           {
//             'icon': Icons.account_circle,
//             'text': 'Account Info',
//             'trailingIcon': Icons.arrow_forward_ios,
//             'onTap': () {
//               NoPageFound.show(context); // Call the function to show the alert
//               // Navigator.pushNamed(context, '/account-info');
//             },
//           },
//           {
//             'icon': Icons.people,
//             'text': 'Team',
//             'trailingIcon': Icons.arrow_forward_ios,
//             'onTap': () {
//               // NoPageFound.show(context); // Call the function to show the alert
//               Navigator.pushNamed(context, '/business-team');
//             },
//           },
//           {
//             'icon': Icons.attach_money,
//             'text': 'Pricing Plan',
//             'trailingIcon': Icons.arrow_forward_ios,
//             'onTap': () {
//               NoPageFound.show(context); // Call the function to show the alert
//               // Navigator.pushNamed(context, '/pricing-plan');
//             },
//           },
//           {
//             'icon': Icons.settings,
//             'text': 'Settings',
//             'trailingIcon': Icons.arrow_forward_ios,
//             'onTap': () {
//               // NoPageFound.show(context); // Call the function to show the alert
//               Navigator.pushNamed(context, '/business-account-settings');
//             },
//           },
//         ];
//         break;
//
//       case 'marketing':
//         roleItems = [
//           {
//             'icon': Icons.people,
//             'text': 'Team',
//             'trailingIcon': Icons.arrow_forward_ios,
//             'onTap': () {
//               // NoPageFound.show(context); // Call the function to show the alert
//               Navigator.pushNamed(context, '/business-team');
//
//             },
//           },
//           {
//             'icon': Icons.settings,
//             'text': 'Settings',
//             'trailingIcon': Icons.arrow_forward_ios,
//             'onTap': () {
//               Navigator.pushNamed(context, '/business-account-settings');
//             },
//           },
//         ];
//         break;
//     }
//
//     // Combine common and role-specific items
//     return [
//       ...roleItems,
//       ...commonItems, // Ensure logout is always shown at the bottom
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(
//         title: 'Reviews',
//         showBackButton: false,
//         centerTitle: true,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
//             child: ProfileSection(
//               fullName: _full_name,
//               email: _email,
//               profileImagePath: _profileImageUrl,
//               onEditProfile: () async {
//                 // setState(() {
//                 //   // Define a map of roles to corresponding emails
//                 //   const roleEmailMap = {
//                 //     'business-owner':'business-owner@gmail.com',
//                 //     'ceo': 'ceo@gmail.com',
//                 //     'marketing': 'marketing@gmail.com',
//                 //     'admin': 'admin@gmail.com',
//                 //   };
//                 //   const roles = ['ceo', 'marketing', 'admin'];
//                 //   int currentIndex = roles.indexOf(_role);
//                 //   _role = roles[(currentIndex + 1) % roles.length];
//                 //   _email = roleEmailMap[_role]!;
//                 //   _full_name=roles[(currentIndex + 1) % roles.length];
//                 // });
//                 // print('Edit profile clicked');
//               },
//               onEditImage: _onImageIconPressed,
//               infoBoxes: infoBoxes,
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(0),
//               children: _getProfileItemsForRole(_role)
//                   .map((item) => ProfileListItem(
//                 leadingIcon: item['icon'] as IconData,
//                 text: item['text'] as String,
//                 trailingIcon: item['text'] == 'Logout' ? null : item['trailingIcon'] as IconData?,
//                 onTap: item['onTap'] as void Function(),
//               ))
//                   .toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }






import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrive_hub/core/utils/no_page_found.dart';
import 'package:thrive_hub/screens/business/widgets/profile_section.dart';
import 'package:thrive_hub/services/auth_services/auth_service.dart';
import 'package:thrive_hub/services/profile_service/profile_service.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/widgets/profile_listitem.dart';
import 'package:thrive_hub/core/utils/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BusinessProfileScreen extends StatefulWidget {
  @override
  _BusinessProfileScreenState createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  String _full_name = '';
  String _email = '';
  String _profileImageUrl = 'assets/avtar.jpg'; // Default image path
  String _role = 'business-owner'; // Default role
  bool _isLoading = false;
  File? _image;

  int reviewsCount = 234;
  int titleCount = 47;
  int projectsCount = 15;

  List<Map<String, String>> get infoBoxes => [
    {'title': '$reviewsCount', 'subtitle': 'Reviews'},
    {'title': '$titleCount', 'subtitle': 'Title'},
    {'title': '$projectsCount', 'subtitle': 'Projects'},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _logout(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    AuthService logoutService = AuthService();
    final result = await logoutService.logout();

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result['message']),
    ));

    if (result['success']) {
      Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
    }
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final fullName = prefs.getString('full_name') ?? 'Name';
    final email = prefs.getString('email') ?? 'email@example.com';
    final profileImage = prefs.getString('profile_image');
    final List<String>? userTypes = prefs.getStringList('user_types');
    final role = userTypes?.isNotEmpty ?? false ? userTypes!.first : 'business-owner';

    setState(() {
      _full_name = fullName;
      _email = email;
      _role = role;

      if (profileImage != null && profileImage.isNotEmpty) {
        _profileImageUrl = profileImage;
      }
    });
  }

  Future<void> _onImageIconPressed() async {
    if (_image == null || _image!.path.isEmpty) {
      print("No valid image selected.");
      return;
    }

    try {
      final profileService = ProfileService(); // Create an instance
      final response = await profileService.uploadImage(_image!.path);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Extract URL from the response
        final imageUrl = responseData['url'];
        // Save the URL to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_image', imageUrl);
        await _loadUserData();
        setState(() {
          _profileImageUrl = imageUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile image uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print('Failed to upload image: ${response.reasonPhrase}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload profile image.'),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading profile image: $e'),
        ),
      );
    }
  }


  List<Map<String, dynamic>> _getProfileItemsForRole(String role) {
    List<Map<String, dynamic>> commonItems = [
      {
        'icon': Icons.help,
        'text': 'Help Center',
        'trailingIcon': Icons.arrow_forward_ios,
        'onTap': () {
          Navigator.pushNamed(context, '/business-help-center');
        },
      },
      {
        'icon': Icons.logout,
        'text': _isLoading ? 'Logging out...' : 'Logout',
        'trailingIcon': Icons.arrow_forward_ios,
        'onTap': () {
          _logout(context);
        },
      },
    ];

    List<Map<String, dynamic>> roleItems = [];
    switch (role) {
      case 'business-owner':
        roleItems = [
          {
            'icon': Icons.account_circle,
            'text': 'Account Info',
            'trailingIcon': Icons.arrow_forward_ios,
            'onTap': () {
              NoPageFound.show(context);
            },
          },
          {
            'icon': Icons.people,
            'text': 'Team',
            'trailingIcon': Icons.arrow_forward_ios,
            'onTap': () {
              Navigator.pushNamed(context, '/business-team');
            },
          },
          {
            'icon': Icons.notifications,
            'text': 'Notification',
            'trailingIcon': Icons.arrow_forward_ios,
            'onTap': () {
              Navigator.pushNamed(context, '/business-notification');
            },
          },
          {
            'icon': Icons.settings,
            'text': 'Settings',
            'trailingIcon': Icons.arrow_forward_ios,
            'onTap': () {
              Navigator.pushNamed(context, '/business-account-settings');
            },
          },
        ];
        break;
    }

    return [...roleItems, ...commonItems];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Reviews',
        showBackButton: false,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: ProfileSection(
              fullName: _full_name,
              email: _email,
              profileImagePath: _profileImageUrl,
              onEditProfile: () async {},
              onEditImage: _onImageIconPressed,
              infoBoxes: infoBoxes,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: _getProfileItemsForRole(_role)
                  .map((item) => ProfileListItem(
                leadingIcon: item['icon'] as IconData,
                text: item['text'] as String,
                trailingIcon: item['text'] == 'Logout'
                    ? null
                    : item['trailingIcon'] as IconData?,
                onTap: item['onTap'] as void Function(),
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

