import "package:get_it/get_it.dart";

import "/services/auth_service/auth_impl.dart";
import "/services/auth_service/auth_service.dart";
import "/services/order_service/order_impl.dart";
import "/services/order_service/order_service.dart";

GetIt locator = GetIt.instance;

void setupLocator() async {
  locator.registerLazySingleton<AuthService>(() => AuthImpl());
  locator.registerLazySingleton<OrderService>(() => OrderImpl());
}
