<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    boolean isLoggedIn = session.getAttribute("user") != null;
%>

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
        .practice-arena {
            position: absolute;
            top: 64px; /* debajo del header */
            left: 256px; /* a la derecha del sideNav */
            width: calc(100vw - 256px);
            height: calc(100vh - 64px);
            background: #0a0a0b;
            position: relative;
        }
    </style>
</head>

<body>
    <%@ include file="includes/header.jsp" %>
    <%@ include file="includes/sideNavigation.jsp" %>

    <main class="practice-arena">
        <c:choose>
            <c:when test="${actualPractice.trackInstrumentPractice == 'other' || actualPractice.trackInstrumentPractice == 'guitar' || actualPractice.trackInstrumentPractice == 'bass'}">
                <%@ include file="layouts/guitarLayout.jsp" %>
            </c:when>
            <c:when test="${actualPractice.trackInstrumentPractice == 'drums'}">
                <%@ include file="layouts/guitarLayout.jsp" %>
            </c:when>
            <c:otherwise>
                <div style="color: white; padding: 20px;">Instrumento no valido: ${actualPractice.trackInstrumentPractice}.</div>
            </c:otherwise>
        </c:choose>
    </main>
</body>
</html>