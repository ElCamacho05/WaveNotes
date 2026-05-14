import { initializeApp } from "https://www.gstatic.com/firebasejs/12.13.0/firebase-app.js";
import { getAuth, signInWithPopup, GoogleAuthProvider } from "https://www.gstatic.com/firebasejs/12.13.0/firebase-auth.js";


// const firebaseConfig = {
//   apiKey: process.env.API_KEY,
//   authDomain: process.env.AUTH_DOMAIN,
//   projectId: process.env.PROJECT_ID,
//   storageBucket: process.env.STORAGE_BUCKET,
//   messagingSenderId: process.env.MESSAGING_SENDER_ID,
//   appId: process.env.APP_ID,
//   measurementId: process.env.MEASUREMENT_ID
// };

const firebaseConfig = {
  apiKey: "AIzaSyC9pDFo0vSYX0PqF4HqOByKxqKxWvTJzjY",
  authDomain: "wavenotes-b3cec.firebaseapp.com",
  projectId: "wavenotes-b3cec",
  storageBucket: "wavenotes-b3cec.firebasestorage.app",
  messagingSenderId: "34998766411",
  appId: "1:34998766411:web:700d7c2b4dd5adda9cb6ce",
  measurementId: "G-T8NK6EHEW8"
};

const app = initializeApp(firebaseConfig);
const provider = new GoogleAuthProvider();

function loginGoogle(e) {
    console.log("intentando iniciar sesion")
    if (e) e.preventDefault();

    const auth = getAuth();
    signInWithPopup(auth, provider)
    .then((result) => {
        // This gives you a Google Access Token. You can use it to access the Google API.
        const credential = GoogleAuthProvider.credentialFromResult(result);
        const token = credential.accessToken;
        // The signed-in user info.
        const user = result.user;
        console.log("autentidado con firebase")
        // IdP data available using getAdditionalUserInfo(result)
        // ...

        const params = new URLSearchParams();
        params.append('uid', user.uid); // Sí, user.uid es totalmente correcto
        params.append('email', user.email);
        params.append('name', user.displayName);
        
        const contextPath = document.body.getAttribute('data-context') || '/WaveNotes';
        
        fetch(contextPath + '/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        }).then(response => {
            if (response.ok) {
                // Una vez que el servidor Java creó la sesión, redirigimos
                const urlParams = new URLSearchParams(window.location.search);
                const destination = urlParams.get('redirect') || 'createPractice.jsp';

                window.location.href = contextPath + "/" + destination;
                
                // alert("iniciado correctamente")
                console.log("userid: " + user.uid)
                console.log("userName: " + user.displayName)

            } else {
                alert("-- (loginModule) Error al sincronizar con servidor interno: " + response.status)
            }
        })
        .catch(err => {
            alert("-- (loginModule) Fallo tas intentar conectar con el backend: " + err);
        });

    }).catch((error) => {
        // Handle Errors here.
        const errorCode = error.code;
        const errorMessage = error.message;
        // The email of the user's account used.
        const email = error.customData.email;
        // The AuthCredential type that was used.
        const credential = GoogleAuthProvider.credentialFromError(error);
        // ...
        alert("-- (loginModule) Fallo al iniciar sesion" + error)
    });
}

const btnGoogle = document.getElementById('btn-login-google');

if (btnGoogle) {
    btnGoogle.addEventListener('click', loginGoogle);
}