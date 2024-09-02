import 'package:background_fetch/background_fetch.dart';
import 'package:dima/utils/notification_utils.dart';

void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;

  // Esegui la logica per mostrare una notifica una volta al giorno
  //DateTime now = DateTime.now();
  // Esempio: mostra una notifica ogni giorno alle 12:00
  await NotificationService().notifyUser();

  BackgroundFetch.finish(taskId);
}


Future<void> initializeBackgroundFetch() async {
  int status = await BackgroundFetch.configure(
    BackgroundFetchConfig(
      minimumFetchInterval: 1440,
      stopOnTerminate: false,
      enableHeadless: true,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
      requiredNetworkType: NetworkType.NONE
    ),
    (taskId) async {
      // Logica di background fetch
      //DateTime now = DateTime.now();
      await NotificationService().notifyUser();
      BackgroundFetch.finish(taskId);
    },
    (taskId) async {
      BackgroundFetch.finish(taskId);
    }
  );
}