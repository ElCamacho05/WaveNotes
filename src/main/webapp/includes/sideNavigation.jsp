<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700;900&family=Manrope:wght@200;300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 200, 'GRAD' 0, 'opsz' 24;
        }
    </style>
    
    <link rel="stylesheet" href="styles.css">
</head>

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
</html>