importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-messaging.js");

// TODO: Add to configuration file
var firebaseConfig = {
  apiKey: "AIzaSyBeN4qYSTSZt1RiixS99jOFDrmeZXux5AE",
  authDomain: "pronto-mia-87b3f.firebaseapp.com",
  projectId: "pronto-mia-87b3f",
  storageBucket: "pronto-mia-87b3f.appspot.com",
  messagingSenderId: "966123215407",
  appId: "1:966123215407:web:19a0d61a1b122ac0ff84da"
};
firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
})
