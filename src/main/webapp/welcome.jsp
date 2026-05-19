<!-- 
Asistencia de IA para desarrollo creativo del frontend 
Uso de StitchAI para generacion de frontend inicial, 
modificado severamente por mi para cumplir completamente con mis espectativas y requerimientos
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% boolean isLoggedIn = session.getAttribute("userLoggedIn") != null; %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>WaveNotes | Aprende música con WaveNotes</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=Manrope:wght@300;400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24; }
    </style>
    
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>

    <main style="padding-top: 64px;">
        <section class="hero-container">
            <div class="bg-blobs">
                <div class="blob-primary" style="width: 500px; height: 500px; top: 25%; left: 25%;"></div>
                <div class="blob-secondary" style="width: 600px; height: 600px; bottom: 25%; right: 25%;"></div>
            </div>

            <div class="hero-content">
                <div class="badge">
                    <span class="material-symbols-outlined" style="font-size: 16px;">bolt</span>
                    APRENDIZAJE MUSICAL ASISTIDO POR IA
                </div>
                
                <h1 class="hero-title">
                    Vuélvete experto en cada <span class="text-gradient-brand">Nota</span> con WaveNotes
                </h1>
                
                <p class="hero-subtitle">
                    Descubre el increible poder de procesamiento de WaveNotes, 
                    divide canciones en <span class="text-gradient-brand">instrumentos separados,</span> 
                    escoge el que quieras, 
                    visualiza la forma de tocar esa cancion mientras <span class="text-gradient-brand">llueven en pantalla</span> las instrucciones 
                    y comienza a aprender las notas extraidas usando el poder de <span class="text-gradient-brand">WaveNotes</span>.
                </p>
                
                <div class="btn-group">
                    <% if(!isLoggedIn) { %>
                        <a href="login.jsp" class="btn btn-login btn-large" style="width: auto;">Comenzar a aprender</a>
                    <% } else{%>
                        <a href="createPractice.jsp" class="btn btn-login btn-large" style="width: auto;">Comenzar a aprender</a>
                    <%} %>
                </div>
                </div>
        </section>

        <section class="bento-section">
            <div class="bento-container">
                <div class="bento-header">
                    <h2 class="heading-xl" style="margin-bottom: var(--spacing-xs);">Reconocimiento de Audio de Próxima Generación</h2>
                    <p class="text-muted">Tu centro de prácticas moderno, para un aprendizaje a tu medida.</p>
                </div>
                
                <div class="bento-grid">
                    <div class="bento-card bento-span-8 bento-flex-row">
                        <div style="flex: 1;">
                            <span class="material-symbols-outlined" style="color: var(--primary); font-size: 36px; margin-bottom: var(--spacing-sm);">layers</span>
                            <h3 class="heading-lg" style="font-size: 24px; margin-bottom: var(--spacing-sm);">Separación de Pistas Automáticas</h3>
                            <p class="text-muted" style="margin-bottom: var(--spacing-md);">Carga cualquier canción que quieras y nuestro sistema de IA lo separará en los distintos instrumentos que la componen. Prueba separando instrumentos de entre los permitidos con nuestro sistema:</p>
                            
                            <ul style="list-style: none; color: var(--primary); font-size: 14px; display: flex; flex-direction: column; gap: 8px;">
                                <li style="display: flex; align-items: center; gap: 8px;"><span class="material-symbols-outlined" style="font-size: 18px;">check_circle</span> Bajo</li>
                                <li style="display: flex; align-items: center; gap: 8px;"><span class="material-symbols-outlined" style="font-size: 18px;">check_circle</span> Batería</li>
                                <li style="display: flex; align-items: center; gap: 8px;"><span class="material-symbols-outlined" style="font-size: 18px;">check_circle</span> Voces</li>
                                <li style="display: flex; align-items: center; gap: 8px;"><span class="material-symbols-outlined" style="font-size: 18px;">check_circle</span> Otros (comúnmente Guitarra)</li>
                            </ul>
                        </div>
                        <!-- <div style="flex: 1; background: var(--surface-container-high); border-radius: 12px; min-height: 200px;"></div> -->
                    </div>

                    <div class="bento-card bento-span-4">
                        <span class="material-symbols-outlined" style="color: var(--secondary-container); font-size: 36px; margin-bottom: var(--spacing-sm);">graphic_eq</span>
                        <h3 class="heading-lg" style="font-size: 24px; margin-bottom: var(--spacing-sm);">Retroalimentación en Tiempo Real</h3>
                        <p class="text-muted">Conecta tu instrumento, comienza a tocar, y recibe Retroalimentación de tu música al instante.</p>
                    </div>

                    <div class="bento-card bento-span-5">
                        <span class="material-symbols-outlined" style="color: var(--primary); font-size: 36px; margin-bottom: var(--spacing-sm);">library_music</span>
                        <h3 class="heading-lg" style="font-size: 24px; margin-bottom: var(--spacing-sm);">Prácticas Persistentes</h3>
                        <p class="text-muted">Tu música, prácticas, score y estadísticas, todas, guardadas para tu comodidad.</p>
                    </div>

                    <div class="bento-card bento-span-7" style="display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <h3 class="heading-lg" style="font-size: 24px; margin-bottom: var(--spacing-sm);">Un Estudio de Calidad a tu Total Disposición</h3>
                            <p class="text-muted" style="max-width: 300px;">Carga tus prácticas cuando quieras y donde quieras.</p>
                        </div>
                        <span class="material-symbols-outlined" style="font-size: 64px; color: var(--primary);">cloud_sync</span>
                    </div>
                </div>
            </div>
        </section>

        <section class="cta-section">
            <div class="glass-panel cta-card">
                <div class="blob-primary" style="position: absolute; top: -50px; right: -50px; width: 250px; height: 250px;"></div>
                <h2 class="heading-xl" style="margin-bottom: var(--spacing-md); position: relative; z-index: 2;">¿Listo para convertirte en el mejor músico?</h2>
                <p class="text-muted" style="font-size: 18px; margin-bottom: var(--spacing-lg); position: relative; z-index: 2;">Únete a nuestra creciente comunidad de músicos superándose con cada práctica.</p>
                <a class="btn btn-white btn-large" style="display: inline-flex; width: auto; position: relative; z-index: 2;">Obtén WaveNotes Pro</a>
            </div>
        </section>
    </main>

    <%@ include file="includes/footer.jsp" %>
</body>
</html>