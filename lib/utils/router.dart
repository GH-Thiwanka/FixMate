import 'package:fixmate/data/chat_data.dart';
import 'package:fixmate/model/job_model.dart';
import 'package:fixmate/pages/activejobtracking.dart';
import 'package:fixmate/pages/customer/authscreens/forgrtpassword.dart';
import 'package:fixmate/pages/customer/authscreens/login.dart';
import 'package:fixmate/pages/customer/authscreens/otpverification.dart';
import 'package:fixmate/pages/customer/authscreens/signup.dart';
import 'package:fixmate/pages/dashboard/allcategoriesscreen.dart';
import 'package:fixmate/pages/dashboard/explore.dart';
import 'package:fixmate/pages/dashboard/homepage.dart';
import 'package:fixmate/pages/dashboard/post_a_job_screen.dart';
import 'package:fixmate/pages/messagescreen.dart';
import 'package:fixmate/pages/myjob/myjobscreen.dart';
import 'package:fixmate/pages/onboarding/onboarding.dart';
import 'package:fixmate/pages/onboarding/selection.dart';
import 'package:fixmate/pages/onboarding/splash.dart';
import 'package:fixmate/pages/dashboard/workerprofile.dart';
import 'package:fixmate/pages/profilescreen.dart';
import 'package:fixmate/pages/myjob/quotescreen.dart';
import 'package:fixmate/pages/myjob/rateandreview.dart';
import 'package:fixmate/pages/myjob/refundandsupport.dart';
import 'package:fixmate/pages/myjob/reschedulescreen.dart';
import 'package:fixmate/pages/workerchat.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/messages',
  routes: [
    //onboarding and splash screens
    GoRoute(path: '/splash', builder: (context, state) => const Splash()),

    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const Onboarding(),
    ),
    GoRoute(
      path: '/selection',
      builder: (context, state) => const SelectionPage(),
    ),

    //auth screens
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/otp-verification',
      builder: (context, state) => const OtpVerificationScreen(),
    ),

    //dashboard screens
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/worker-profile',
      builder: (context, state) => const WorkerProfileScreen(),
    ),

    //create job screens
    GoRoute(
      path: '/my-jobs',
      builder: (context, state) => const MyJobsScreen(),
    ),
    GoRoute(
      path: '/explore',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final screenTitle = extra?['title'] as String? ?? 'Top Rated Near You';

        return ExploreScreen(title: screenTitle);
      },
    ),
    GoRoute(
      path: '/all-categories',
      builder: (context, state) => const AllCategoriesScreen(),
    ),
    GoRoute(
      path: '/post-a-job',
      builder: (context, state) => const PostAJobScreen(),
    ),

    GoRoute(
      path: '/quotes',
      builder: (context, state) => const QuotesReceivedScreen(),
    ),

    GoRoute(
      path: '/reschedule',
      builder: (context, state) {
        final job = state.extra as JobModel;
        return RescheduleScreen(job: job);
      },
    ),

    GoRoute(
      path: '/rate-review',
      builder: (context, state) {
        final job = state.extra as JobModel;
        return RateAndReviewScreen(job: job);
      },
    ),

    GoRoute(
      path: '/refund-support',
      builder: (context, state) {
        final job = state.extra as JobModel?;
        return RefundAndSupportScreen(job: job);
      },
    ),

    //messages screen
    GoRoute(
      path: '/messages',
      builder: (context, state) => const MessagesScreen(),
    ),

    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final workerName = state.extra as String?;
        return WorkerChatScreen(
          conversation: ChatData.conversations.firstWhere(
            (conv) => conv.workerName == workerName,
            orElse: () => ChatData.conversations.first,
          ),
        );
      },
    ),

    GoRoute(
      path: '/active-job-tracking',
      builder: (context, state) {
        final job = state.extra as JobModel?;
        return ActiveJobTrackingScreen(job: job);
      },
    ),

    //profile screen
    GoRoute(
      path: '/profile',
      builder: (context, state) => const Profilescreen(),
    ),
  ],
);
