<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/styles/guitar.css">

    <div class="guitar-game-container">

        <div class="glass-panel">
            <h3 class="glass-panel-title">
                <span class="material-symbols-outlined">queue_music</span> Info Práctica
            </h3>

            <div class="guitar-stats-grid">
                <div>
                    <p class="text-small text-muted" style="text-transform: uppercase;">Score</p>
                    <p class="guitar-score-display" id="scoreDisplay">0</p>
                </div>
                <div>
                    <p class="text-small text-muted" style="text-transform: uppercase;">Accuracy</p>
                    <p class="guitar-accuracy-display" id="accuracyDisplay">100%</p>
                </div>
            </div>

            <div class="guitar-btn-container">
                <button id="btnStartEngine" class="btn btn-login guitar-btn-start">Conectar Guitarra</button>
            </div>
        </div>

        <div class="perspective-view">
            <canvas id="guitarHighway" class="highway-track"></canvas>

            <div class="guitar-hit-zone-glow"></div>
            <div class="guitar-hit-zone-line"></div>
        </div>

        <div id="guitar-pads-container" class="guitar-pads-container">
            </div>
    </div>

    <script src="<%=request.getContextPath()%>/layouts/js/guitarEngine.js" defer></script>