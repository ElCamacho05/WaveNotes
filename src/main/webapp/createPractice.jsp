<!-- 
Asistencia de IA para desarrollo creativo del frontend 
Uso de StitchAI para generacion de frontend inicial, 
modificado severamente por mi para cumplir completamente con mis espectativas y requerimientos
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% 
    // Bandera de Java para saber si la sesión ya tiene las pistas en la RAM [cite: 35]
    boolean pistasListas = session.getAttribute("generatedTracks") != null; 
%>
<% boolean isLoggedIn = session.getAttribute("userLoggedIn") != null; %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>WaveNotes | Create Session</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700;900&family=Manrope:wght@200;300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 200, 'GRAD' 0, 'opsz' 24;
        }
    </style>
    
    <link rel="stylesheet" href="styles.css">
</head>

<body data-pistas="<%= pistasListas %>">
    <nav class="top-nav" style="justify-content: space-between; padding: 0 32px;">
        <div style="display: flex; align-items: center; gap: 32px;">
            <span class="heading-lg text-gradient-brand" style="font-size: 24px;">WaveNotes</span>
            <div class="hidden-mobile" style="display: flex; gap: var(--spacing-md);">
                <a class="nav-link" href="welcome.jsp">Inicio</a>
                <% if(!isLoggedIn) { %>
                    <a class="nav-link" href="login.jsp?redirect=myPractices.jsp">Prácticas</a>
                    <a class="nav-link" href="login.jsp?redirect=myStats.jsp">Estadísticas</a>
                    <a class="nav-link" href="login.jsp?redirect=mySongs.jsp">Canciones</a>
                <% } else{%>
                    <a class="nav-link" href="myPractices.jsp">Prácticas</a>
                    <a class="nav-link" href="myStats.jsp">Estadísticas</a>
                    <a class="nav-link" href="mySongs.jsp">Canciones</a>
                <%} %>
            </div>
        </div>
        <div style="display: flex; align-items: center; gap: 16px;">
            <% if(!isLoggedIn) { %>
                <a href="login.jsp" class="btn" style="width: auto; background: transparent;">Login</a>
            <% } else{%>
                <span class="text-muted" style="margin-right: 8px;">Hola, <%= session.getAttribute("userName") %></span>
            <%} %>

            <% if(!isLoggedIn) { %>
                    <a href="login.jsp" class="btn btn-login" style="width: auto; padding: 8px 24px; font-size: 16px; border-radius: 99px;">Comenzar</a>
                <% } else{%>
                    <a href="createPractice.jsp" class="btn btn-login" style="width: auto; padding: 8px 24px; font-size: 16px; border-radius: 99px;">Comenzar</a>
                <%} %>
        </div>
    </nav>

    <aside class="side-nav">
        <div style="display: flex; flex-direction: column; gap: var(--spacing-base); flex-grow: 1;">
            <button class="side-nav-btn active">
                <span class="material-symbols-outlined">home</span> Inicio
            </button>
            <button class="side-nav-btn">
                <span class="material-symbols-outlined">book</span> Practicas
            </button>
            <button class="side-nav-btn">
                <span class="material-symbols-outlined">bar_chart_4_bars</span> Estadísticas
            </button>
            <button class="side-nav-btn">
                <span class="material-symbols-outlined">music_note</span> Canciones
            </button>
            <button class="side-nav-btn">
                <span class="material-symbols-outlined">settings</span> Ajustes
            </button>
        </div>
        
        <div style="border-top: 1px solid rgba(255,255,255,0.1); padding-top: var(--spacing-base); display: flex; flex-direction: column; gap: var(--spacing-base);">
            <button class="side-nav-btn">
                <span class="material-symbols-outlined">help</span> Soporte
            </button>

            <% if(!isLoggedIn) { %>
                <button class="side-nav-btn">
                    <span href="login.jsp" class="material-symbols-outlined">login</span> Login
                </button>
            <% } else{%>
                <button id="btn-logout" name="" class="side-nav-btn">
                    <span class="material-symbols-outlined">logout</span> LogOut
                </button>
            <%} %>
            
        </div>
    </aside>

    <main class="main-layout app-content">
        <div class="text-center" style="grid-column: 1 / -1; margin-bottom: var(--spacing-md);">
            <h1 class="heading-lg" style="margin-bottom: var(--spacing-xs);">Crea tu sesion de Practicas</h1>
            <p class="text-muted" style="font-size: 18px;">Carga tu canción favorita para comenzar la separación de pistas musicales.</p>
        </div>

        <div class="glass-panel upload-zone" style="grid-column: span 8; padding: var(--spacing-xl); min-height: 400px;">
            
            <div id="uploadUI" class="hidden">
                <div style="margin-bottom: var(--spacing-sm);">
                    <span class="material-symbols-outlined text-gradient-brand" style="font-size: 64px;">upload_file</span>
                </div>
                <h3 class="heading-lg" style="font-size: 24px; margin-bottom: var(--spacing-base);">Arrastra y suelta tu archivo de audio MP3 o WAV.</h3>
                
                <form id="uploadForm" action="/WaveNotes/separator" method="POST" enctype="multipart/form-data">
                    <label style="cursor: pointer;">
                        <input name="audio" accept=".mp3,.wav" type="file" style="display: none;" onchange="startUpload()"/>
                        <span class="btn btn-login" style="width: auto; padding: var(--spacing-sm) var(--spacing-md); font-size: 16px; border-radius: 99px;">
                            <span class="material-symbols-outlined">cloud_upload</span> Cargar canción
                        </span>
                    </label>
                </form>
            </div>

            <div id="loadingUI" style="display: none; text-align: center;">
                <div class="loader"></div>
                <h3 class="heading-lg" style="font-size: 20px;">Procesando en la GPU...</h3>
                <p class="text-muted">Separando pistas y aislando frecuencias. Esto tomará unos segundos.</p>
            </div>

            <div id="successUI" class="text-center hidden">
                <span class="material-symbols-outlined text-gradient-brand" style="font-size: 64px;">check_circle</span>
                <h3 class="heading-lg" style="font-size: 24px; margin-top: var(--spacing-sm);">¡Sesión Lista!</h3>
                <p class="text-muted">Las pistas se han separado y guardado en memoria de la aplicación.</p>
                <button onclick="location.reload()" class="btn" style="border: 1px solid var(--outline); margin-top: var(--spacing-md); width: auto; margin-inline: auto;">¿Te equivocaste? Sube otra canción</button>
            </div>

        </div>

        <form action="<%=request.getContextPath()%>/startup" method="POST" style="grid-column: span 4; display: flex; flex-direction: column; gap: var(--spacing-md); height: 100%;">
            
            <div id="panelConfig" class="glass-panel disabled-panel" style="padding: var(--spacing-md);">
                <h4 class="heading-lg" style="font-size: 20px; margin-bottom: var(--spacing-md); display: flex; align-items: center; gap: var(--spacing-base);">
                    <span class="material-symbols-outlined" style="color: var(--primary-container);">spatial_audio</span> Configuration
                </h4>
                
                <div style="display: flex; flex-direction: column; gap: var(--spacing-sm);">
                    <div style="padding: var(--spacing-sm); background: var(--surface-container-lowest); border: 1px solid var(--outline-variant); border-radius: 8px;">
                        <label class="text-small text-muted" style="display: block; margin-bottom: var(--spacing-sm);">Instrumento Deseado</label>
                        <div class="radio-group">

                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <label class="radio-label">
                                    Título de la práctica:
                                    <input type="text" name="titlePractice">
                                </label>
                            </div>

                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <label class="radio-label">
                                    <input type="radio" name="selectedSong" value="other.mp3" checked> Guitarra
                                </label>
                                <button type="button" class="preview-btn" onclick="playPreview('other.mp3', this)"><span class="material-symbols-outlined">play_circle</span></button>
                            </div>

                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <label class="radio-label">
                                    <input type="radio" name="selectedSong" value="bass.mp3"> Bajo
                                </label>
                                <button type="button" class="preview-btn" onclick="playPreview('bass.mp3', this)"><span class="material-symbols-outlined">play_circle</span></button>
                            </div>

                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <label class="radio-label">
                                    <input type="radio" name="selectedSong" value="drums.mp3"> Bateria
                                </label>
                                <button type="button" class="preview-btn" onclick="playPreview('drums.mp3', this)"><span class="material-symbols-outlined">play_circle</span></button>
                            </div>

                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <label class="radio-label">
                                    <input type="radio" name="selectedSong" value="vocals.mp3"> Voces
                                </label>
                                <button type="button" class="preview-btn" onclick="playPreview('vocals.mp3', this)"><span class="material-symbols-outlined">play_circle</span></button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <button id="btnStartPractice" type="submit" class="glass-panel tile-btn disabled-panel" style="flex-grow: 1; display: flex; flex-direction: column; justify-content: center; align-items: center; cursor: pointer; min-height: 180px;">
                <span class="material-symbols-outlined" style="font-size: 48px; color: var(--primary-container); margin-bottom: var(--spacing-xs);">play_arrow</span>
                <span class="heading-lg" style="font-size: 24px; color: var(--on-surface);">Iniciar Práctica</span>
            </button>
            
        </form>
    </main>

    <footer class="site-footer" style="background: #0a0a0b;">
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

    <script>

        const finishedTracks = document.body.getAttribute('data-pistas') === 'true';
        
        document.addEventListener("DOMContentLoaded", () => {
            evalUI();
        });

        function evalUI() {
            const uploadUI = document.getElementById('uploadUI');
            const successUI = document.getElementById('successUI');
            const panelConfig = document.getElementById('panelConfig');
            const btnStartPractice = document.getElementById('btnStartPractice');

            if (finishedTracks) {
                uploadUI.classList.add('hidden');
                successUI.classList.remove('hidden');
                
                panelConfig.classList.remove('disabled-panel');
                btnStartPractice.classList.remove('disabled-panel');
            } else {
                uploadUI.classList.remove('hidden');
                successUI.classList.add('hidden');
                
                panelConfig.classList.add('disabled-panel');
                btnStartPractice.classList.add('disabled-panel');
            }
        }
        function startUpload() {
            document.getElementById('uploadUI').style.display = 'none';
            document.getElementById('loadingUI').style.display = 'block';
            document.getElementById('uploadForm').submit();
        }

        // Variables globales para el reproductor
        let currentAudio = null;
        let currentButton = null;
        let currentTrackName = null;

        function playPreview(trackName, btnElement) {
            const iconSpan = btnElement.querySelector('.material-symbols-outlined');

            if (currentTrackName === trackName) {
                if (currentAudio.paused) {
                    currentAudio.play();
                    iconSpan.innerText = 'pause_circle';
                } else {
                    currentAudio.pause();
                    iconSpan.innerText = 'play_circle';
                }
                return;
            }

            if (currentAudio) {
                currentAudio.pause();
                currentAudio.currentTime = 0;

                if (currentButton) {
                    currentButton.querySelector('.material-symbols-outlined').innerText = 'play_circle';
                }
            }

            currentTrackName = trackName;
            currentButton = btnElement;

            const url = '/WaveNotes/stream?track=' + trackName;
            currentAudio = new Audio(url);

            currentAudio.onended = function() {
                iconSpan.innerText = 'play_circle';
            };

            currentAudio.play().then(() => {
                iconSpan.innerText = 'pause_circle';
            }).catch(error => {
                console.log("Aun no hay pistas listas para reproducir:", error);
            });
        }
    </script>
</body>
</html>