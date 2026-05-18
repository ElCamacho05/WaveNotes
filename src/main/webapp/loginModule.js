import { initializeApp } from "https://www.gstatic.com/firebasejs/12.13.0/firebase-app.js";
import { getAuth, createUserWithEmailAndPassword, signOut, signInWithPopup, GoogleAuthProvider } from "https://www.gstatic.com/firebasejs/12.13.0/firebase-auth.js";


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
    console.log("-- (loginModule: Google) Intentando iniciar sesion")
    if (e) e.preventDefault();

    const auth = getAuth();
    signInWithPopup(auth, provider)
    .then((result) => {
        // This gives you a Google Access Token. You can use it to access the Google API.
        const credential = GoogleAuthProvider.credentialFromResult(result);
        const token = credential.accessToken;
        // The signed-in user info.
        const user = result.user;
        console.log("-- (loginModule: Google) Autentidado con firebase")
        // IdP data available using getAdditionalUserInfo(result)
        // ...

        const params = new URLSearchParams();
        params.append('uid', user.uid);
        params.append('email', user.email);
        params.append('name', user.displayName);
        
        const contextPath = document.body.getAttribute('data-context') || '/WaveNotes';
        
        fetch(contextPath + '/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        }).then(response => {
            if (response.ok) {
                const urlParams = new URLSearchParams(window.location.search);
                const destination = urlParams.get('redirect') || 'createPractice.jsp';

                window.location.href = contextPath + "/" + destination;
                
                console.log("userid: " + user.uid)
                console.log("userName: " + user.displayName)

            } else {
                alert("-- (loginModule: Google) Error al sincronizar con servidor interno: " + response.status)
            }
        })
        .catch(err => {
            alert("-- (loginModule: Google) Fallo tas intentar conectar con el backend: " + err);
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
        alert("-- (loginModule: Google) Fallo al iniciar sesion" + error)
    });
}

function loginEmail(e) {
    console.log("-- (loginModule: Email) Intentando iniciar sesion")

    if (e) e.preventDefault();

    const inputMail = document.getElementById("input-email").value;
    const inputPassword = document.getElementById("input-password").value;

    if (!inputMail || !inputPassword) {
        alert("Formulario de inicio incorrecto");
        return;
    }

    const auth = getAuth();
    signInWithEmailAndPassword(auth, inputMail, inputPassword)
    .then((userCredential) => {
        // Signed in 
        const user = userCredential.user;
        // ...

        console.log("-- (loginModule: Google) Autentidado con firebase")

        const params = new URLSearchParams();
        params.append('uid', user.uid);
        params.append('email', user.email);
        params.append('name', user.displayName);
        
        const contextPath = document.body.getAttribute('data-context') || '/WaveNotes';
        
        fetch(contextPath + '/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        }).then(response => {
            if (response.ok) {
                const urlParams = new URLSearchParams(window.location.search);
                const destination = urlParams.get('redirect') || 'createPractice.jsp';

                window.location.href = contextPath + "/" + destination;
                
                console.log("userid: " + user.uid)
                console.log("userName: " + user.displayName)

            } else {
                alert("-- (loginModule: Email) Error al sincronizar con servidor interno: " + response.status)
            }
        })
        .catch(err => {
            alert("-- (loginModule: Email) Fallo tas intentar conectar con el backend: " + err);
        });
    })
    .catch((error) => {
        const errorCode = error.code;
        const errorMessage = error.message;

        alert("-- (loginModule: Email) Fallo al iniciar sesion" + error)
    });
}

function registerEmail(e) {
    console.log("-- (loginModule: Register) Intentando registrar usuario...")
    if (e) e.preventDefault();

    const inputMail = document.getElementById("input-email").value;
    const inputPassword = document.getElementById("input-password").value;

    if (!inputMail || !inputPassword) {
        alert("Formulario de registro incorrecto");
        return;
    }

    const auth = getAuth();
    createUserWithEmailAndPassword(auth, inputMail, inputPassword)
    .then((userCredential) => {
        console.log("-- (loginModule: Register) Autentidado con firebase")
        // Signed up
        const user = userCredential.user;
        // ...

        const params = new URLSearchParams();
        params.append('uid', user.uid);
        params.append('email', user.email);
        params.append('name', user.email.split('@')[0]);

        const contextPath = document.body.getAttribute('data-context') || '/WaveNotes';
        
        fetch(contextPath + '/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        }).then(response => {
            if (response.ok) {
                const urlParams = new URLSearchParams(window.location.search);
                const destination = urlParams.get('redirect') || 'createPractice.jsp';

                window.location.href = contextPath + "/" + destination;
                
                console.log("userid: " + user.uid)
                console.log("userName: " + user.email.split('@')[0])

            } else {
                alert("-- (loginModule: Register) Error al sincronizar con servidor interno: " + response.status)
            }
        })
        .catch(err => {
            alert("-- (loginModule: Register) Fallo tas intentar conectar con el backend: " + err);
        });
    })
    .catch((error) => {
        const errorCode = error.code;
        if (errorCode === 'auth/weak-password') {
            alert("Tu contraseña debe tener al menos 6 caracteres.");
        } else if (errorCode === 'auth/email-already-in-use') {
            alert("Correo electrónico ya registrado. Prueba iniciando sesión.");
        } else if (errorCode === 'auth/invalid-email') {
            alert("Formato del correo electrónico no válido.");
        } else {
            alert("Error al registrar" + errorCode + ": " + error.message);
        }
    });
}

function logOut() {
    console.log("intentando cerrar sesion...");
    const auth = getAuth();
    const contextPath = document.body.getAttribute('data-context') || '/WaveNotes';

    signOut(auth).then(() => {
        console.log("Sesion en Firebase cerrada correctamente");

        // terminar sesion en servidor
        fetch(contextPath + '/logout', {
            method: 'POST'
        }).then(response => {
            if (response.ok) {
                console.log("Sesion en Tomcat destruida");
                resetApp();
                window.location.href = contextPath + "/welcome.jsp"; 
            } else {
                console.error("Tomcat devolvió un error al intentar destruir la sesión");
            }
        }).catch(err => {
            console.error("Error al comunicar el logout a Tomcat: ", err);
        });
    }).catch((error) => {
        alert("Error: " + error);
        console.log(error);
    });
}

function resetApp() {
    sessionStorage.clear();
}

// Login Google
const btnGoogle = document.getElementById('btn-login-google');

if (btnGoogle) {
    btnGoogle.addEventListener('click', loginGoogle);
}

// Login Email
const btnMail = document.getElementById('btn-login-mail');

if (btnMail) {
    btnMail.addEventListener('click', loginEmail);
}

// Register Email
const btnRegMail = document.getElementById('btn-register-mail');

if (btnRegMail) {
    btnRegMail.addEventListener('click', registerEmail);
}

// Logout
const btnLogOut = document.getElementById('btn-logout');

if (btnLogOut) {
    btnLogOut.addEventListener('click', logOut);
}