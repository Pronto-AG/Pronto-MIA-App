import 'package:mockito/mockito.dart' as _i1;
import 'package:pronto_mia/core/services/graphql_service.dart' as _i2;
import 'package:pronto_mia/core/services/jwt_token_service.dart' as _i3;
import 'package:pronto_mia/core/services/push_notification_service.dart' as _i4;

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
