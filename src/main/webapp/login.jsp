<!-- 
Asistencia de IA para desarrollo creativo del frontend 
Uso de StitchAI para generacion de frontend inicial, 
modificado severamente por mi para cumplir completamente con mis espectativas y requerimientos
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% boolean isLoggedIn = session.getAttribute("userLoggedIn") != null; %>
<% 
    String mode = request.getParameter("mode");
    boolean userHaveAccount = mode == null || !mode.equals("register"); 
%>

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

<body data-context="<%=request.getContextPath()%>">
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
                

                <div class="divider">
                    <span class="text-small text-muted">o inicia con tu correo electrónico</span>
                </div>

                <form id="auth-form">
                    <div class="form-group">
                        <label class="text-small text-muted" style="margin-left: var(--spacing-xs);">Correo Electrónico</label>
                        <div class="input-wrapper">
                            <span class="material-symbols-outlined input-icon">mail</span>
                            <input id="input-email" class="form-input" placeholder="name@company.com" type="email" required/>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="input-wrapper">
                            <span class="material-symbols-outlined input-icon">lock</span>
                            <input id="input-password" class="form-input" placeholder="••••••••" type="password" required/>
                        </div>
                    </div>

                    <% if (userHaveAccount) { %>
                        <button id="btn-login-mail" class="btn btn-login" type="submit">Login</button>
                    <% } else { %>
                        <button id="btn-register-mail" class="btn btn-login" type="submit">Registrarme</button>
                    <% } %>
                    
                </form>

                <div style="margin-top: var(--spacing-lg); text-align: center;">
                    <p class="text-muted">
                        <% if (userHaveAccount) { %>
                            <a onclick="setHaveAccount(false)" style="color: var(--primary-container); font-weight: 600; margin-left: var(--spacing-xs); cursor: pointer;">
                                ¿No tienes cuenta? ¡Regístrate aquí!
                            </a>
                        <% } else { %>
                            <a onclick="setHaveAccount(true)" style="color: var(--primary-container); font-weight: 600; margin-left: var(--spacing-xs); cursor: pointer;">
                                ¿Ya tienes cuenta? ¡Inicia sesión aquí!
                            </a>
                        <% } %>
                    </p>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="includes/footer.jsp" %>
    
    <script type="module" src="<%=request.getContextPath()%>/loginModule.js"></script>
    
    <script>
        var haveAccount = true;

        function setHaveAccount(state) {
            const contextPath = document.body.getAttribute('data-context') || '/WaveNotes';
            
            if (state) {
                window.location.href = contextPath + "/login.jsp";
            } else {
                window.location.href = contextPath + "/login.jsp?mode=register";
            }
        }

    </script>
</body>
</html>