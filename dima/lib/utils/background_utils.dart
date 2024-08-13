//import 'package:background_fetch/background_fetch.dart';
//import 'package:dima/utils/notification_utils.dart';
//
//void backgroundFetchHeadlessTask(HeadlessTask task) async {
//  String taskId = task.taskId;
//
//  // Esegui la logica per mostrare una notifica una volta al giorno
//  DateTime now = DateTime.now();
//  if (now.hour == 1) { // Esempio: mostra una notifica ogni giorno alle 12:00
//    await showNotification('Buongiorno!', 'Questa è la tua notifica giornaliera.');
//  }
//
//  BackgroundFetch.finish(taskId);
//}
//
//void initializeBackgroundFetch() {
//  BackgroundFetch.configure(
//    BackgroundFetchConfig(
//      minimumFetchInterval: 2, // intervallo di 24 ore
//      stopOnTerminate: false,
//      startOnBoot: true,
//    ),
//    (taskId) async {
//      // Logica di background fetch
//      DateTime now = DateTime.now();
//      if (now.hour == 16) { // Esempio: mostra una notifica ogni giorno alle 12:00
//        await showNotification('Buongiorno!', 'Questa è la tua notifica giornaliera.');
//      }
//      BackgroundFetch.finish(taskId);
//    },
//    backgroundFetchHeadlessTask,
//  );
//}
//