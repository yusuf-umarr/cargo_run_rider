// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';


// class RouteGenerator {
//   ///Generates routes, extracts and passes navigation arguments.
//   static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case splashScreenViewRoute:
//         return _getPageRoute(const SplashScreenView());

//       // case unAuthenticatedViewRoute:
//       //   return _getPageRoute(const LogInView());
//       case getStartedRoute:
//         return _getPageRoute(const GetStartedScreen());

//       case loginViewRoute:
//         return _getPageRoute(const LogInView());
//       case signUpViewRoute:
//         return _getPageRoute(const SignupView());
//       case changePasswordViewRoute:
//         return _getPageRoute(const ChangePasswordView());

//       case enterPhoneNumberViewRoute:
//         return _getPageRoute(const EnterPhoneNumberView());
//       case codeVerificationViewRoute:
//         return _getPageRoute(const VerifyCodeView());
//       case nameCountryLocationViewRoute:
//         return _getPageRoute(const NameCountryLocationView());
//       case enableLocationViewRoute:
//         return _getPageRoute(const EnableLocationView());
//       case interestsViewRoute:
//         return _getPageRoute(const InterestsView());
//       case photoUploadViewRoute:
//         return _getPageRoute(const PhotoUploadView());
//       case beginConnectingViewRoute:
//         return _getPageRoute(const BeginConnectingView());
//       case homePageViewRoute:
//         return _getPageRoute(const HomePageView());
//       case commentsScreenViewRoute:
//         var post = settings.arguments as AskBudyModel;

//         return _getPageRoute(CommentsScreen(post: post));
//       case connectDetailViewRoute:
//         var model = settings.arguments as AuthModel;

//         return _getPageRoute(ConnectDetailView(model: model));

//       case nestedCommentsViewRoute:
//         var comment = settings.arguments as AskBudyCommentModel;
//         return _getPageRoute(NestedCommentScreen(comment: comment));
//       case savedGoodsViewRoute:
//         return _getPageRoute(const SavedGoodsView());
//       case chatsViewRoute:
//         return _getPageRoute(const ChatView());
//       case conversationViewRoute:
//         //  final ChatHistoryModel chatHistory;
//         final chatHistory = settings.arguments;

//         if (chatHistory != null && chatHistory is ChatHistoryModel) {
//           return _getPageRoute(ConversationScreen(chatHistory: chatHistory));
//         }
//         return _getPageRoute(
//           _errorPage(message: "Chat room model parameter not passed"),
//         );
//       case forgotPasswordViewRoute:
//         return _getPageRoute(const ResetPasswordView());
//       case profileViewRoute:
//         return _getPageRoute(const ProfileView());
//       case myProductsViewRoute:
//         return _getPageRoute(const MyProductsView());
//       case subscriptionViewRoute:
//         return _getPageRoute(const SubscriptionView());
//       case settingsViewRoute:
//         return _getPageRoute(const SettingsView());
//       default:
//         return _getPageRoute(_errorPage());
//     }
//   }

//   //Wraps widget with a CupertinoPageRoute and adds route settings
//   static CupertinoPageRoute _getPageRoute(
//     Widget child, [
//     String? routeName,
//     dynamic args,
//   ]) =>
//       CupertinoPageRoute(
//         builder: (context) => child,
//         settings: RouteSettings(
//           name: routeName,
//           arguments: args,
//         ),
//       );

//   ///Error page shown when app attempts navigating to an unknown route
//   static Widget _errorPage({String message = "Error! Page not found"}) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Page not found',
//           style: TextStyle(color: Colors.red),
//         ),
//       ),
//       body: Center(
//         child: Text(
//           message,
//           style: const TextStyle(color: Colors.red),
//         ),
//       ),
//     );
//   }
// }