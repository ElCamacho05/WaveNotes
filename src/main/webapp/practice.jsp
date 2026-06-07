<!-- 
Asistencia de IA para desarrollo creativo del frontend 
Uso de StitchAI para generacion de frontend inicial, 
modificado severamente por mi para cumplir completamente con mis espectativas y requerimientos
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<% boolean isLoggedIn = session.getAttribute("user") != null; %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <title>WaveNotes | Práctica Activa</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="styles.css">
    
    <style>
        body { overflow: hidden; } /* evitar scroll mientras se esta usando (nomas por si acaso) */
        
        /* Boton para esconder la barra lateral */
        .nav-toggle-btn {
            position: absolute;
            top: 24px;
            left: 24px;
            z-index: 100;
            background: rgba(32, 31, 32, 0.6);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 8px;
            color: white;
            padding: 8px;
            cursor: pointer;
            backdrop-filter: blur(10px);
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }
        .nav-toggle-btn:hover { background: rgba(255,255,255,0.1); }
        
        /* ajustes para el area de juego */
        .practice-arena {
            position: absolute;
            top: 64px;
            left: 256px;
            width: calc(100vw - 256px);
            height: calc(100vh - 64px);
            background: #0a0a0b;
        }
    </style>
</head>

<body>
    <%@ include file="includes/header.jsp" %>
    
    <div id="sideNavWrapper">
        <%@ include file="includes/sideNavigation.jsp" %>
    </div>

    <main class="practice-arena" id="practiceArena">
        
        <button class="nav-toggle-btn" id="toggleNavBtn" title="Esconder/Mostrar Menú">
            <span class="material-symbols-outlined">menu_open</span>
        </button>

        <input type="hidden" id="practiceNotesRaw" value='${actualPractice.notesJson}'>

        <audio id="gameAudio" src="${actualPractice.song.urlAudio}" preload="auto"></audio>

        <div id="player-bar" class="glass-panel" style="position: absolute; bottom: 24px; left: 50%; transform: translateX(-50%); width: 85%; max-width: 800px; padding: 12px 24px; display: flex; align-items: center; gap: 20px; z-index: 1000; background: rgba(10, 10, 11, 0.95); border-radius: 16px; box-shadow: 0 10px 30px rgba(0,0,0,0.8);">
            
            <button id="btnPlayPause" class="btn-icon" style="background: transparent; color: white; border: none; cursor: pointer; display: flex;">
                <span class="material-symbols-outlined" style="font-size: 32px;" id="iconPlayPause">play_arrow</span>
            </button>
            
            <input type="range" id="seek-bar" min="0" max="100" value="0" step="0.1" style="flex: 1; accent-color: var(--primary-container); cursor: pointer;">
                
            <span id="time-display" style="color: var(--on-surface-variant); font-size: 14px; font-variant-numeric: tabular-nums;">0:00</span>
        </div>

        <c:choose>
            <c:when test="${actualPractice.trackInstrumentPractice == 'other' || actualPractice.trackInstrumentPractice == 'guitar' || actualPractice.trackInstrumentPractice == 'bass'}">
                <%@ include file="layouts/guitarLayout.jsp" %>
            </c:when>
            <c:when test="${actualPractice.trackInstrumentPractice == 'drums'}">
                <%@ include file="layouts/drumsLayout.jsp" %>
            </c:when>
            <c:otherwise>
                <div style="color: white; padding: 20px;">Instrumento no valido: ${actualPractice.trackInstrumentPractice}.</div>
            </c:otherwise>
        </c:choose>
    </main>

    <audio id="gameAudio" src="${actualPractice.song.urlAudio}" preload="auto"></audio>

    
    <!-- script para la barra lateral -->
    <script>
        const toggleBtn = document.getElementById('toggleNavBtn');
        const sideNav = document.querySelector('.side-nav');
        const arena = document.getElementById('practiceArena');
        const icon = toggleBtn.querySelector('span');

        toggleBtn.addEventListener('click', () => {
            sideNav.classList.toggle('collapsed');
            arena.classList.toggle('expanded');
            if(sideNav.classList.contains('collapsed')) { icon.innerText = "menu"; } 
            else { icon.innerText = "menu_open"; }
            setTimeout(() => { window.dispatchEvent(new Event('resize')); }, 310);
        });
    </script>
</body>
</html>