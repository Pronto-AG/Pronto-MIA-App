import 'package:mockito/mockito.dart' as _i1;
import 'package:pronto_mia/core/services/graphql_service.dart' as _i2;
import 'package:pronto_mia/core/services/jwt_token_service.dart' as _i3;
import 'package:pronto_mia/core/services/push_notification_service.dart' as _i4;
import 'package:pronto_mia/core/services/logging_service.dart' as _i5;
import 'package:pronto_mia/core/services/pdf_service.dart' as _i6;
import 'package:stacked_services/src/navigation_service.dart' as _i7;
import 'package:pronto_mia/core/services/authentication_service.dart' as _i8;
import 'package:pronto_mia/core/services/error_service.dart' as _i9;
import 'package:pronto_mia/core/services/department_service.dart' as _i10;
import 'package:pronto_mia/core/services/user_service.dart' as _i11;
import 'package:stacked_services/src/dialog/dialog_service.dart' as _i12;
import 'package:pronto_mia/core/services/deployment_plan_service.dart' as _i13;
import 'package:graphql/src/graphql_client.dart' as _i14;
import 'package:shared_preferences/shared_preferences.dart' as _i15;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i16;
import 'package:logging/src/logger.dart' as _i17;
import 'package:flutter_cache_manager/src/cache_manager.dart' as _i18;
import 'package:firebase_messaging/firebase_messaging.dart' as _i19;
import 'package:pronto_mia/core/services/external_news_service.dart' as _i20;

/// A class which mocks [GraphQLService].
///
/// See the documentation for Mockito's code generation for more information.
class MockGraphQLService extends _i1.Mock implements _i2.GraphQLService {}

/// A class which mocks [JwtTokenService].
///
/// See the documentation for Mockito's code generation for more information.
class MockJwtTokenService extends _i1.Mock implements _i3.JwtTokenService {}

/// A class which mocks [PushNotificationService].
///
/// See the documentation for Mockito's code generation for more information.
class MockPushNotificationService extends _i1.Mock
    implements _i4.PushNotificationService {}

/// A class which mocks [LoggingService].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoggingService extends _i1.Mock implements _i5.LoggingService {}

/// A class which mocks [PdfService].
///
/// See the documentation for Mockito's code generation for more information.
class MockPdfService extends _i1.Mock implements _i6.PdfService {}

/// A class which mocks [NavigationService].
///
/// See the documentation for Mockito's code generation for more information.
class MockNavigationService extends _i1.Mock implements _i7.NavigationService {}

/// A class which mocks [AuthenticationService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationService extends _i1.Mock
    implements _i8.AuthenticationService {}

/// A class which mocks [ErrorService].
///
/// See the documentation for Mockito's code generation for more information.
class MockErrorService extends _i1.Mock implements _i9.ErrorService {}

/// A class which mocks [DepartmentService].
///
/// See the documentation for Mockito's code generation for more information.
class MockDepartmentService extends _i1.Mock implements _i10.DepartmentService {
}

/// A class which mocks [UserService].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserService extends _i1.Mock implements _i11.UserService {}

/// A class which mocks [DialogService].
///
/// See the documentation for Mockito's code generation for more information.
class MockDialogService extends _i1.Mock implements _i12.DialogService {}

/// A class which mocks [DeploymentPlanService].
///
/// See the documentation for Mockito's code generation for more information.
class MockDeploymentPlanService extends _i1.Mock
    implements _i13.DeploymentPlanService {}

/// A class which mocks [GraphQLClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockGraphQLClient extends _i1.Mock implements _i14.GraphQLClient {}

/// A class which mocks [SharedPreferences].
///
/// See the documentation for Mockito's code generation for more information.
class MockSharedPreferences extends _i1.Mock implements _i15.SharedPreferences {
}

/// A class which mocks [FlutterSecureStorage].
///
/// See the documentation for Mockito's code generation for more information.
class MockFlutterSecureStorage extends _i1.Mock
    implements _i16.FlutterSecureStorage {}

/// A class which mocks [Logger].
///
/// See the documentation for Mockito's code generation for more information.
class MockLogger extends _i1.Mock implements _i17.Logger {}

/// A class which mocks [CacheManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockCacheManager extends _i1.Mock implements _i18.CacheManager {}

/// A class which mocks [FirebaseMessaging].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseMessaging extends _i1.Mock implements _i19.FirebaseMessaging {
}

/// A class which mocks [ExternalNewsService].
///
/// See the documentation for Mockito's code generation for more information.
class MockExternalNewsService extends _i1.Mock
    implements _i20.ExternalNewsService {}
