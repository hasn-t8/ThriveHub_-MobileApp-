import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrive_hub/core/helper/time_helper.dart';
import 'package:thrive_hub/core/utils/thank_you.dart';
import 'package:thrive_hub/screens/business/widgets/description_bottom_sheet.dart';
import 'package:thrive_hub/screens/search_screens/filter_screen.dart';
import 'package:thrive_hub/services/company_services/company_services.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/widgets/review_card.dart';
import 'package:thrive_hub/widgets/sort.dart';
import 'package:thrive_hub/widgets/filter_sort_buttons.dart';

class BusinessReviewScreen extends StatefulWidget {
  @override
  _BusinessReviewScreenState createState() => _BusinessReviewScreenState();
}

class _BusinessReviewScreenState extends State<BusinessReviewScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final CompanyService _reviewService = CompanyService();

  String? _description;
  File? _selectedImage;
  bool _isLoading = true;
  bool _isReplying = false; // Loader state for replying
  List<Map<String, dynamic>> _reviews = [];
  List<Map<String, dynamic>> filteredReviews = [];
  String _errorMessage = '';
  String? selectedSortOption;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final businessProfileId = prefs.getInt('business_profile_id') ?? -1;

    if (businessProfileId == -1) {
      setState(() {
        _errorMessage =
            'Invalid business profile ID. Please check your settings.';
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Fetch reviews
      final reviews = await _reviewService
          .getReviewsByBusinessId(businessProfileId.toString());
      if (reviews.isEmpty) {
        setState(() {
          _errorMessage = 'No reviews found';
        });
      } else {
        // Fetch replies for each review
        for (var review in reviews) {
          final reviewId = review['id'].toString();
          final replies = await _reviewService.getRepliesByReviewId(reviewId);
          review['replies'] = replies ?? [];
        }

        setState(() {
          _reviews = List<Map<String, dynamic>>.from(reviews);
          filteredReviews = List.from(_reviews);
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'No Review found.';
      });
      print('Error fetching reviews: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFiltersAndSorting({List<String> updatedFilters = const []}) {
    setState(() {
      // Reset filters if 'All' is selected
      if (updatedFilters.contains('All')) {
        filteredReviews = List.from(_reviews);
        return;
      }

      // Start with all reviews
      filteredReviews = List.from(_reviews);

      // Extract selected ratings and categories
      List<double> selectedRatings = updatedFilters
          .where(
              (filter) => RegExp(r'^\d$').hasMatch(filter)) // Matches numbers
          .map((rating) => double.tryParse(rating)!) // Converts to double
          .toList();

      List<String> selectedCategories = updatedFilters
          .where((filter) => !RegExp(r'^\d$').hasMatch(filter)) // Non-numeric
          .toList();

      // Filter by categories
      if (selectedCategories.isNotEmpty) {
        filteredReviews = filteredReviews.where((review) {
          return selectedCategories.contains(review['category']);
        }).toList();
      }

      // Filter by ratings
      if (selectedRatings.isNotEmpty) {
        filteredReviews = filteredReviews.where((review) {
          double reviewRating =
              (double.tryParse(review['rating']?.toString() ?? '0') ?? 0) / 2;
          return selectedRatings.contains(reviewRating);
        }).toList();
      }

      // Sort by the selected sort option
      if (selectedSortOption == 'Newest') {
        filteredReviews.sort((a, b) {
          DateTime dateA = DateTime.parse(a['created_at']);
          DateTime dateB = DateTime.parse(b['created_at']);
          return dateB.compareTo(dateA); // Newest first
        });
      } else if (selectedSortOption == 'No answer') {
        filteredReviews = filteredReviews.where((review) {
          return (review['replies'] as List).isEmpty; // No replies
        }).toList();
      } else if (selectedSortOption == 'With answer') {
        filteredReviews = filteredReviews.where((review) {
          return (review['replies'] as List).isNotEmpty; // Has replies
        }).toList();
      }
    });
  }

  void _saveDescription(String description, File? selectedImage) {
    setState(() {
      _description = description;
      _selectedImage = selectedImage;
    });
    ThankYou.show(context);
  }

  void _showBottomSheet(BuildContext context, String reviewId) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return ReusableBottomSheet(
          descriptionController: _descriptionController,
          onSave: (description, selectedImage) async {
            try {
              setState(() {
                _isReplying = true;
              });

              // Call _replyToReview and handle its success or failure
              final isReplySuccessful =
                  await _replyToReview(reviewId, description);

              // Navigator.pop(context); // Close the bottom sheet

              if (isReplySuccessful) {
                _fetchReviews(); // Refresh reviews on success
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to submit reply. Please try again.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to send reply: $error'),
                  backgroundColor: Colors.red,
                ),
              );
            } finally {
              setState(() {
                _isReplying = false;
              });
            }
          },
          onClose: () => Navigator.pop(context),
        );
      },
    );
  }

  Future<bool> _replyToReview(String reviewId, String replyText) async {
    if (replyText.trim().isEmpty) {
      return false; // No action needed if the reply text is empty
    }

    // Call the service to submit the reply
    final isReplySuccessful =
        await _reviewService.replyToReview(reviewId, replyText);
    // Show SnackBar only if the reply is successful
    if (isReplySuccessful) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reply submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
    return isReplySuccessful;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Reviews',
        showBackButton: false,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 10.0),
          FilterSortButtons(
            onFilter: (context) async {
              final List<String>? filters = await Navigator.push<List<String>>(
                context,
                MaterialPageRoute(builder: (context) => FilterScreen()),
              );

              return filters ?? [];
            },
            onSort: (context) async {
              final String? sortOption = await showModalBottomSheet<String>(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => const SortBottomSheet(
                  title: 'Sort By',
                  sortOptions: ['No answer', 'With answer', 'Newest'],
                ),
              );

              if (sortOption != null) {
                setState(() {
                  selectedSortOption = sortOption;
                });
                _applyFiltersAndSorting(updatedFilters: []);
              }
            },
            onFiltersUpdated: (updatedFilters) {
              _applyFiltersAndSorting(updatedFilters: updatedFilters);
            },
          ),
          SizedBox(height: 8.0),
          if (_isReplying)
            LinearProgressIndicator(), // Loader under the response
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(
                        child: Text(
                          _errorMessage,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredReviews.length,
                        itemBuilder: (context, index) {
                          final review = filteredReviews[index];
                          final hasReplies =
                              (review['replies'] as List).isNotEmpty;

                          return ReviewCard(
                            imageUrl: review['logo_url'] ??
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtuphMb4mq-EcVWhMVT8FCkv5dqZGgvn_QiA&s',
                            title: review['org_name'] ?? 'No Title',
                            rating: (double.tryParse(
                                        review['rating']?.toString() ?? '0') ??
                                    0) /
                                2,
                            location: review['location'] ?? '',
                            timeAgo: calculateTimeAgo(review['created_at']),
                            reviewerName:
                                review['customer_name'] ?? 'Anonymous',
                            reviewText: review['feedback'] ??
                                'No review text provided.',
                            likes: review['likes'] ?? 0,
                            isLiked: review['isLiked'] ?? false,
                            showReplyButton: !hasReplies,
                            onReply: () {
                              _showBottomSheet(
                                  context, review['id'].toString());
                            },
                            isReplied: hasReplies,
                            replyTitle: hasReplies
                                ? review['replies'][0]['reply']
                                : null, // Adjust as needed
                            replyTimeAgo: hasReplies
                                ? calculateTimeAgo(
                                    review['replies'][0]['created_at'])
                                : null,
                            replyMessage: hasReplies
                                ? review['replies'][0]['reply']
                                : null,
                            onTap: () {
                              print('ReviewCard tapped: ${review['org_name']}');
                            },
                            onLike: () {
                              setState(() {
                                if (review['isLiked']) {
                                  review['likes'] -= 1;
                                } else {
                                  review['likes'] += 1;
                                }
                                review['isLiked'] = !review['isLiked'];
                              });
                            },
                            onShare: () {
                              Share.share(
                                'Check out this review on Thrive Hub:\n\n"${review['feedback']}"\nRead more at: https://example.com/review/${review['org_name']}',
                                subject: 'Review of ${review['org_name']}',
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
