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
    <link rel="stylesheet" href="styles/practice.css">
</head>

<body data-pistas="<%= pistasListas %>" data-context="<%=request.getContextPath()%>">
    <%@ include file="includes/header.jsp" %>

    <%@ include file="includes/sideNavigation.jsp" %>

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
                
                    <form id="songUploadForm" action="<%=request.getContextPath()%>/separator" method="POST" enctype="multipart/form-data">                    <label style="cursor: pointer;">
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

        <form action="<%=request.getContextPath()%>/practices" method="POST" style="grid-column: span 4; display: flex; flex-direction: column; gap: var(--spacing-md); height: 100%;">
            
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
                                    <input type="text" name="titlePractice" required>
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

    <div id="global-player" class="mini-player">
        <div class="player-track-info">
            <span class="material-symbols-outlined track-icon">music_note</span>
            <div class="track-details">
                <span id="player-title" class="track-title">Pista</span>
                <span class="track-subtitle">WaveNotes Preview</span>
            </div>
        </div>
        
        <div class="player-controls">
            <button id="player-play-btn" class="ctrl-btn main-ctrl">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;" id="player-play-icon">pause</span>
            </button>
            <div class="player-progress">
                <span id="player-time-current" class="time-text">0:00</span>
                <div class="progress-bar-container" id="player-progress-container">
                    <div class="progress-fill" id="player-progress-fill"></div>
                </div>
                <span id="player-time-total" class="time-text">0:00</span>
            </div>
        </div>
        
        <div class="player-volume">
            <span class="material-symbols-outlined" style="font-size: 18px;">volume_up</span>
            <input type="range" id="player-volume-slider" min="0" max="1" step="0.01" value="1">
        </div>
    </div>

    <script type="module" src="<%=request.getContextPath()%>/loginModule.js"></script>

    <script>
        const contextPath = document.body.getAttribute('data-context') ?? '/WaveNotes';

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
            document.getElementById('songUploadForm').submit();
        }

        // variables de reproduccion
        let currentAudio = null;
        let currentButton = null;
        let currentTrackName = null;

        const globalPlayer = document.getElementById('global-player');
        const mainContent = document.querySelector('.app-content');
        const playerTitle = document.getElementById('player-title');
        const playerPlayBtn = document.getElementById('player-play-btn');
        const playerPlayIcon = document.getElementById('player-play-icon');
        const playerProgressFill = document.getElementById('player-progress-fill');
        const playerTimeCurrent = document.getElementById('player-time-current');
        const playerTimeTotal = document.getElementById('player-time-total');
        const progressContainer = document.getElementById('player-progress-container');
        const volumeSlider = document.getElementById('player-volume-slider');

        globalPlayer.classList.add('visible');
        mainContent.classList.add('player-active');

        // Formato matemático para segundos a mm:ss
        function formatTime(seconds) {
            if (isNaN(seconds)) return "0:00";
            const m = Math.floor(seconds / 60);
            const s = Math.floor(seconds % 60);
            return m + ":" + (s < 10 ? "0" : "") + s;
        }

        // Play/Pause desde el Reproductor Global
        playerPlayBtn.addEventListener('click', () => {
            if (!currentAudio) return;
            const iconSpan = currentButton.querySelector('.material-symbols-outlined');
            
            if (currentAudio.paused) {
                currentAudio.play();
                playerPlayIcon.innerText = 'pause';
                iconSpan.innerText = 'pause_circle';
            } else {
                currentAudio.pause();
                playerPlayIcon.innerText = 'play_arrow';
                iconSpan.innerText = 'play_circle';
            }
        });

        // Control de Volumen
        volumeSlider.addEventListener('input', (e) => {
            if (currentAudio) currentAudio.volume = e.target.value;
        });

        // Adelantar/Atrasar canción al dar clic en la barra
        progressContainer.addEventListener('click', (e) => {
            if (!currentAudio) return;
            const rect = progressContainer.getBoundingClientRect();
            const pos = (e.clientX - rect.left) / rect.width;
            currentAudio.currentTime = pos * currentAudio.duration;
        });

        // Función Principal del botón en las listas (Bento Box)
        function playPreview(trackName, btnElement) {
            const iconSpan = btnElement.querySelector('.material-symbols-outlined');

            // Si es la misma canción, solo pausar/reproducir
            if (currentTrackName === trackName) {
                if (currentAudio.paused) {
                    currentAudio.play();
                    iconSpan.innerText = 'pause_circle';
                    playerPlayIcon.innerText = 'pause';
                } else {
                    currentAudio.pause();
                    iconSpan.innerText = 'play_circle';
                    playerPlayIcon.innerText = 'play_arrow';
                }
                return;
            }

            // Si hay otra canción sonando, la matamos
            if (currentAudio) {
                currentAudio.pause();
                currentAudio.currentTime = 0;
                if (currentButton) {
                    currentButton.querySelector('.material-symbols-outlined').innerText = 'play_circle';
                }
            }

            currentTrackName = trackName;
            currentButton = btnElement;

            // Mostrar el reproductor global deslizándolo hacia arriba
            globalPlayer.classList.add('visible');
            mainContent.classList.add('player-active');
            
            // Actualizar el título del reproductor (quitamos el .mp3)
            playerTitle.innerText = "PISTA: " + trackName.replace('.mp3', '').toUpperCase();

            // Cargar y reproducir
            const url = contextPath + '/stream?track=' + trackName;
            currentAudio = new Audio(url);
            
            // Sincronizar el slider de volumen actual con el audio nuevo
            currentAudio.volume = volumeSlider.value;

            // Actualizar interfaz en tiempo real
            currentAudio.ontimeupdate = () => {
                playerTimeCurrent.innerText = formatTime(currentAudio.currentTime);
                playerTimeTotal.innerText = formatTime(currentAudio.duration);
                const percent = (currentAudio.currentTime / currentAudio.duration) * 100;
                playerProgressFill.style.width = percent + '%';
            };

            currentAudio.onended = function() {
                iconSpan.innerText = 'play_circle';
                playerPlayIcon.innerText = 'play_arrow';
                playerProgressFill.style.width = '0%';
                playerTimeCurrent.innerText = "0:00";
            };

            currentAudio.play().then(() => {
                iconSpan.innerText = 'pause_circle';
                playerPlayIcon.innerText = 'pause';
            }).catch(error => {
                console.log("Aun no hay pistas listas para reproducir:", error);
            });
        }
    </script>
</body>
</html>