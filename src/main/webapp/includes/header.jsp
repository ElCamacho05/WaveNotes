<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
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

<body>
    <nav class="top-nav" style="justify-content: space-between; padding: 0 32px;">
    <div style="display: flex; align-items: center; gap: 32px;">
        <span class="heading-lg text-gradient-brand" style="font-size: 24px;">WaveNotes</span>
        <div class="hidden-mobile" style="display: flex; gap: var(--spacing-md);">
            <a class="nav-link" href="welcome.jsp">Inicio</a>
            <% if(!isLoggedIn) { %>
                <a class="nav-link" href="login.jsp?redirect=practices"> Prácticas</a>
                <a class="nav-link" href="login.jsp?redirect=myStats.jsp">Estadísticas</a>
                <a class="nav-link" href="login.jsp?redirect=mySongs.jsp">Canciones</a>
            <% } else{%>
                <form id="uploadForm" action="/WaveNotes/practices" method="GET" style="margin: 0;">
                    <button class="nav-link" type="submit" style="background: none; border: none; cursor: pointer; font: inherit;"> Prácticas</button>
                </form>
                <a class="nav-link" href="myStats.jsp">Estadísticas</a>
                <a class="nav-link" href="mySongs.jsp">Canciones</a>
            <%} %>
        </div>
    </div>
    <div style="display: flex; align-items: center; gap: 16px;">
        <% if(!isLoggedIn) { %>
            <a href="login.jsp" class="btn btn-login" style="width: auto; padding: 8px 24px; font-size: 16px; border-radius: 99px;">Login</a>
        <% } else{%>
            <!-- <span class="text-muted" style="margin-right: 8px;">Hola, <%= session.getAttribute("userName") %></span> -->
            <span class="text-muted" style="margin-right: 8px;">Hola, ${user.nameUser}</span>
        <%} %>

        <a href="createPractice.jsp" class="btn btn-login" style="width: auto; padding: 8px 24px; font-size: 16px; border-radius: 99px;">Comenzar</a>
    </div>
</nav>
</body>
</html>