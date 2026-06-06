<!-- 
Asistencia de IA para desarrollo creativo del frontend 
Uso de StitchAI para generacion de frontend inicial, 
modificado severamente por mi para cumplir completamente con mis espectativas y requerimientos
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<% 
    // Bandera de Java para saber si la sesión ya tiene las pistas en la RAM [cite: 35]
    boolean pistasListas = session.getAttribute("generatedTracks") != null; 
%>
<% boolean isLoggedIn = session.getAttribute("userLoggedIn") != null; %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


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
    <%@ include file="includes/header.jsp" %>

    <%@ include file="includes/sideNavigation.jsp" %>

    <main class="app-content" style="padding-left: var(--spacing-md); padding-right: var(--spacing-md); max-width: 1400px; margin-inline: auto;">
        
        <header style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: var(--spacing-lg);">
            <div>
                <h1 class="heading-xl" style="font-size: 40px; margin-bottom: var(--spacing-xs);">Mis Prácticas</h1>
                <p class="text-muted" style="font-size: 18px;">Gestione y revise su historial de aprendizaje de precisión.</p>
            </div>
        </header>

        <section class="practice-grid">
            <c:forEach items="${practices}" var="pract">
                <form action="<%=request.getContextPath()%>/training" method="GET" style="margin: 0; padding: 0;">
                    <input type="hidden" name="IDPractice" value="${pract.IDPractice}">
                    <!-- <input type="hidden" name="practiceTitle" value="${pract.titlePractice}">
                    <input type="hidden" name="instrument" value="${pract.trackInstrumentPractice}"> -->

                    <div class="glass-panel practice-card" onclick="this.closest('form').submit();" style="cursor: pointer;">
                        <div class="card-image-wrapper">
                            <img src="https://i.pinimg.com/236x/e1/65/d7/e165d74bf2260c25a278cf43e3c32ae7.jpg" alt="Synth" class="card-image"/>
                        </div>

                        <h3 class="heading-md">${pract.titlePractice}</h3>

                        <div class="card-meta text-small text-muted">
                            <span style="display: flex; align-items: center; gap: 4px;">
                                <span class="material-symbols-outlined" style="font-size: 14px;">schedule</span> 
                                04:22
                            </span>
                            <span class="card-tag">${pract.trackInstrumentPractice}</span>
                        </div>

                        <div class="card-stats-grid">
                            <div class="stat-box">
                                <p class="text-small text-muted">Puntuación</p>
                                <p style="color: var(--primary-container); font-weight: 700; font-size: 18px;">${pract.scorePractice}</p>
                            </div>
                            <div class="stat-box">
                                <p class="text-small text-muted">Precisión</p>
                                <p style="color: var(--primary); font-weight: 700; font-size: 18px;">${pract.accuracyPractice}</p>
                            </div>
                            <div class="delete-action-wrapper">
                                <button type="button" class="btn-delete" title="Eliminar Práctica" 
                                        onclick="triggerDelete('${pract.IDPractice}', event)">
                                    <span class="material-symbols-outlined">delete</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
                
            </c:forEach>
            
            <div class="new-practice-card" onclick="window.location.href='createPractice.jsp'">
                <span class="material-symbols-outlined" style="font-size: 48px; margin-bottom: 8px;">add_circle</span>
                <p style="font-family: var(--font-headline); font-weight: 600; font-size: 18px;">Nueva Práctica</p>
            </div>
        </section>
    </main>

    <!-- No se puede anidar de alguna forma el form de eliminacion, asi q toca incrustar por separado el comportamiento -->
    <form id="DeleteForm" action="<%=request.getContextPath()%>/practices" method="POST" style="display: none;">
        <input type="hidden" name="action" value="DELETE">
        <input type="hidden" name="practiceID" id="masterPracticeID" value="">
    </form>

    <script>
        function triggerDelete(practiceId, event) {
            event.stopPropagation();
            
            if(confirm('¿Estás seguro de que deseas eliminar esta práctica? Esta acción es irreversible.')) {
                
                document.getElementById('masterPracticeID').value = practiceId;
                document.getElementById('DeleteForm').submit();
            }
        }
    </script>

    <script type="module" src="<%=request.getContextPath()%>/loginModule.js"></script>
</body>
</html>