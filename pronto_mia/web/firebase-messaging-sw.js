importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-messaging.js");

importScripts('firebase-config.js');

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

// TODO: Improve background message handling
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});
