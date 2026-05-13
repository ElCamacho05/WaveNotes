<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <link rel="stylesheet" href="styles.css">
    </head>
    
    <body>
    <h2>WaveNotes</h2>

    <form action="/WaveNotes/separator" method="POST" enctype="multipart/form-data">
        <input type="file" id="usersSong" name="audio" accept=".mp3, .wav">
        <input type="submit" value="Separar Pistas">
    </form>

    <!-- Condicion para que las pistas solo se pongan una vez generadas -->
    <% if (session.getAttribute("pistasGeneradas") != null) { %>
        <hr>
        <h3>Tus Pistas Listas:</h3>
        
        <div>
            <label>Voces:</label>
            <audio controls>
                <source src="<%=request.getContextPath()%>/stream?track=vocals.mp3" type="audio/mpeg">
            </audio>

            <br><br>

            <label>Batería:</label>
            <audio controls>
                <source src="<%=request.getContextPath()%>/stream?track=drums.mp3" type="audio/mpeg">
            </audio>

            <br><br>

            <label>Bajo:</label>
            <audio controls>
                <source src="<%=request.getContextPath()%>/stream?track=bass.mp3" type="audio/mpeg">
            </audio>

            <br><br>

            <label>Otros:</label>
            <audio controls>
                <source src="<%=request.getContextPath()%>/stream?track=other.mp3" type="audio/mpeg">
            </audio>

            <p>
                Selecciona una canción:
            </p>

            <form action="/WaveNotes/notes" method="POST">
                <select name="selectedSong" id="selSong">
                    <option value="drums.mp3">Batería (Drums)</option>
                    <option value="bass.mp3">Bajo (Bass)</option>
                    <option value="vocals.mp3">Voces (Vocals)</option>
                    <option value="other.mp3">Otros</option>
                </select>
                <br><br>
                <input type="submit" value="Obtener Notas">
            </form>
            
            <% if (session.getAttribute("pitches") != null) { %>
                <h4>Notas extraídas:</h4>
                <p><%= session.getAttribute("pitches") %></p>
            <% } %>
        </div>
    <% } %>

    </body>
</html>