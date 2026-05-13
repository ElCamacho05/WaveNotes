<!-- 
Asistencia de IA para desarrollo creativo del frontend 
Uso de StitchAI para generacion de frontend inicial, 
modificado severamente por mi para cumplir completamente con mis espectativas y requerimientos
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>WaveNotes | Login</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=Manrope:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    
    <link rel="stylesheet" href="styles.css">
</head>

<body>
    <div class="bg-blobs">
        <div class="blob-primary"></div>
        <div class="blob-secondary"></div>
    </div>

    <main class="main-layout">
        <div class="hero-section">
            <div>
                <span class="heading-lg text-gradient-brand">WaveNotes</span>
            </div>
            <h1 class="heading-xl">
                APRENDIZAJE MUSICAL ASISTIDO POR <span class="text-gradient">IA</span>.
            </h1>
            <p class="text-muted" style="font-size: 18px; line-height: 28px;">
                Únete a nuestra creciente comunidad de músicos superándose con cada práctica.
            </p>
        </div>

        <div class="login-section">
            <div class="glass-panel" style="width: 100%; max-width: 440px; padding: var(--spacing-lg); display: flex; flex-direction: column;">
                
                <div style="margin-bottom: var(--spacing-lg); text-align: center;">
                    <h2 class="heading-lg" style="margin-bottom: var(--spacing-xs);">Bienvenido</h2>
                    <p class="text-muted">Regístrate para continuar aprendiendo</p>
                </div>

                <!-- <form id="loginForm" action="/WaveNotes/login" method="POST"> -->
                    <div style="display: flex; flex-direction: column; gap: var(--spacing-base); margin-bottom: var(--spacing-lg);">
                        <button id="btn-login-google" class="btn btn-social" value="Google">
                            <img alt="Google" src="https://www.svgrepo.com/show/303108/google-icon-logo.svg"/>
                            <span class="text-small">Continuar con Google</span>
                        </button>
                        <button class="btn btn-social" value="IOS" type="submit">
                            <span class="material-symbols-outlined">ios</span>
                            <span class="text-small">Continuar con Apple</span>
                        </button>
                    </div>
                <!-- </form> -->
                

                <div class="divider">
                    <span class="text-small text-muted">Or email</span>
                </div>

                <!-- <form id="loginForm" action="/WaveNotes/login" method="POST"> -->
                    <div class="form-group">
                        <label class="text-small text-muted" style="margin-left: var(--spacing-xs);">Correo Electrónico</label>
                        <div class="input-wrapper">
                            <span class="material-symbols-outlined input-icon">mail</span>
                            <input class="form-input" placeholder="name@company.com" type="email"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <label class="text-small text-muted" style="margin-left: var(--spacing-xs);">Contraseña</label>
                            <a class="text-small" style="color: var(--primary); text-transform: none;" href="#">¿Olvidaste tu contraseña?</a>
                        </div>
                        <div class="input-wrapper">
                            <span class="material-symbols-outlined input-icon">lock</span>
                            <input class="form-input" placeholder="••••••••" type="password"/>
                        </div>
                    </div>
                    <button class="btn btn-login" type="submit">Login</button>
                <!-- </form> -->

                <div style="margin-top: var(--spacing-lg); text-align: center;">
                    <p class="text-muted">
                        ¿No tienes cuenta?
                        <a style="color: var(--primary-container); font-weight: 600; margin-left: var(--spacing-xs);" href="#">Registrarse</a>
                    </p>
                </div>
            </div>
        </div>
    </main>

    <footer class="site-footer" style="background: #0a0a0b; margin-top: 0;">
        <div class="footer-content" style="align-items: flex-start;">
            <div style="display: flex; flex-direction: column;">
                <span class="heading-lg" style="font-size: 18px; margin-bottom: 8px;">Con cariño: Creador de WaveNotes.</span>
            </div>
            <div class="footer-links">
                <a class="text-small text-muted" href="#">Privacidad</a>
                <a class="text-small text-muted" href="#">Términos y Condiciones</a>
            </div>
        </div>
    </footer>
    <script type="module" src="<%=request.getContextPath()%>/loginModule.js"></script>
</body>
</html>