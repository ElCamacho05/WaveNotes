<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<nav class="top-nav" style="justify-content: space-between; padding: 0 32px;">
    <div style="display: flex; align-items: center; gap: 32px;">
        <img src="/src/main/resources/logo.png">
        <span class="heading-lg text-gradient-brand" style="font-size: 24px;">WaveNotes</span>
    </div>
    
    <div style="display: flex; align-items: center; gap: 16px;">
        <% if(!isLoggedIn) { %>
            <a href="login.jsp?redirect=welcome.jsp" class="btn btn-login" style="width: auto; padding: 8px 24px; font-size: 16px; border-radius: 99px;">Login</a>
            <a href="login.jsp?redirect=practices" class="btn btn-login" style="width: auto; padding: 8px 24px; font-size: 16px; border-radius: 99px;">Comenzar</a>
        <% } else{%>
            <!-- <span class="text-muted" style="margin-right: 8px;">Hola, <%= session.getAttribute("userName") %></span> -->
            <span class="text-muted" style="margin-right: 8px;">Hola, ${user.nameUser}</span>
            <a href="<%=request.getContextPath()%>/practices" class="btn btn-login" style="width: auto; padding: 8px 24px; font-size: 16px; border-radius: 99px;">Comenzar</a>
        <%} %>

    </div>
</nav>
