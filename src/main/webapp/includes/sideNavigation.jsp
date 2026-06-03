<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>

<aside class="side-nav">
    <div style="display: flex; flex-direction: column; gap: var(--spacing-base); flex-grow: 1;">
        <a class="side-nav-btn button" href="welcome.jsp">
            <span class="material-symbols-outlined">home</span> Inicio
        </a>
        <!-- <% if(!isLoggedIn) { %>
            <button class="side-nav-btn" href="login.jsp?redirect=practices">
                <span class="material-symbols-outlined">book</span> Practicas
            </button>

            <button class="side-nav-btn" href="login.jsp?redirect=myStats.jsp">
                <span class="material-symbols-outlined">bar_chart_4_bars</span> Estadísticas
            </button>

            <button class="side-nav-btn" href="login.jsp?redirect=mySongs.jsp">
                <span class="material-symbols-outlined">music_note</span> Canciones
            </button>
        <% } else{%>
            <form id="uploadForm" action="/WaveNotes/practices" method="GET" style="margin: 0;">
                <button class="side-nav-btn" href="login.jsp?redirect=practices">
                    <span class="material-symbols-outlined">book</span> Practicas
                </button>
            </form>
            
            <button class="side-nav-btn" href="myStats.jsp">
                <span class="material-symbols-outlined">bar_chart_4_bars</span> Estadísticas
            </button>

            <button class="side-nav-btn" href="mySongs.jsp">
                <span class="material-symbols-outlined">music_note</span> Canciones
            </button>
        <%} %> -->
        <% if(!isLoggedIn) { %>
            <a class="side-nav-btn button" href="login.jsp?redirect=practices">
                <span class="material-symbols-outlined">book</span>
                Prácticas
            </a>
            <a class="side-nav-btn button" href="login.jsp?redirect=myStats.jsp">
                <span class="material-symbols-outlined">bar_chart_4_bars</span>
                Estadísticas
            </a>
            <a class="side-nav-btn button" href="login.jsp?redirect=mySongs.jsp">
                <span class="material-symbols-outlined">music_note</span>
                Canciones
            </a>
        <% } else{%>
            <a class="side-nav-btn button" href="practices">
                <span class="material-symbols-outlined">book</span>
                Prácticas
            </a>
            <a class="side-nav-btn button" href="myStats.jsp">
                <span class="material-symbols-outlined">bar_chart_4_bars</span>
                Estadísticas
            </a>
            <a class="side-nav-btn button" href="mySongs.jsp">
                <span class="material-symbols-outlined">music_note</span>
                Canciones
            </a>
        <%} %>

        <a class="side-nav-btn button">
            <span class="material-symbols-outlined">settings</span> Ajustes
        </a>
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