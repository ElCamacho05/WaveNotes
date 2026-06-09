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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/styles/practice.css">
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

        <div id="player-bar" class="glass-panel player-bar">
            
            <button id="btnPlayPause" class="btn-icon player-btn-play">
                <span class="material-symbols-outlined player-icon" id="iconPlayPause">play_arrow</span>
            </button>
            
            <input type="range" id="seek-bar" class="player-seek-bar" min="0" max="100" value="0" step="0.1">
                
            <span id="time-display" class="player-time-display">0:00</span>

        </div>

        <c:choose>
            <c:when test="${actualPractice.trackInstrumentPractice == 'other' || actualPractice.trackInstrumentPractice == 'guitar'}">
                <%@ include file="layouts/guitarLayout.jsp" %>
            </c:when>
            <c:when test="${actualPractice.trackInstrumentPractice == 'bass'}">
                <%@ include file="layouts/bassLayout.jsp" %>
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