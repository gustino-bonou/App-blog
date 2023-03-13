// import * as functions from "firebase-functions";
//
// const functions = require('firebase-functions');
// const admin = require('firebase-admin');
// admin.initializeApp();
//
// exports.notifySubscribers = functions.firestore
//     .document('articles/{articleId}')
//     .onCreate(async (snap, context) => {
//         const articleData = snap.data();
//         const authorId = articleData.authorId;
//
//         const authorDoc = await admin.firestore()
//             .collection('users')
//             .doc(authorId)
//             .get();
//
//         const authorName = authorDoc.data().name;
//
//         const subscribersDoc = await admin.firestore()
//             .collection('subscriptions')
//             .doc(authorId)
//             .get();
//
//         if (!subscribersDoc.exists) {
//             console.log(`No subscribers found for author ${authorId}`);
//             return null;
//         }
//
//         const subscribers = subscribersDoc.data().subscribers;
//
//         const payload = {
//             notification: {
//                 title: `${authorName} has published a new article`,
//                 body: `${articleData.title}`,
//                 click_action: `FLUTTER_NOTIFICATION_CLICK`
//             }
//         };
//
//         for (let subscriber of subscribers) {
//             const tokenDoc = await admin.firestore()
//                 .collection('users')
//                 .doc(subscriber)
//                 .get();
//
//             const token = tokenDoc.data().token;
//
//             await admin.messaging().sendToDevice(token, payload);
//         }
//
//         console.log(`Notification sent to ${subscribers.length} subscribers`);
//         return null;
//     });
//
// // // Start writing functions
// // // https://firebase.google.com/docs/functions/typescript
// //
// // export const helloWorld = functions.https.onRequest((request, response) => {
// //   functions.logger.info("Hello logs!", {structuredData: true});
// //   response.send("Hello from Firebase!");
// // });
