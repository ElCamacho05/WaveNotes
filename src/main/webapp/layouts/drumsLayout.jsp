<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/styles/drums.css">

    <div class="drums-game-container">

        <div class="glass-panel">
            <h3 class="glass-panel-title">
                <span class="material-symbols-outlined">info</span> Info Práctica
            </h3>

            <div class="drums-stats-grid">
                <div>
                    <p class="text-small text-muted" style="text-transform: uppercase;">Score</p>
                    <p class="drums-score-display" id="scoreDisplay">0</p>
                </div>
                <div>
                    <p class="text-small text-muted" style="text-transform: uppercase;">Accuracy</p>
                    <p class="drums-accuracy-display" id="accuracyDisplay">100%</p>
                </div>
            </div>

            <div class="drums-btn-container">
                <button id="btnStartEngine" class="btn btn-login drums-btn-start">Iniciar Mic</button>
                <button id="btnTestDrums" class="btn btn-login drums-btn-test">Test</button>
            </div>
        </div>

        <div class="perspective-view">
            <canvas id="drumsHighway" class="highway-track"></canvas>

            <div class="drums-hit-zone-glow"></div>
            <div class="drums-hit-zone-line"></div>
        </div>

        <div class="drums-pads-container">

            <div id="pad-crash" class="drum-pad pad-crash">
                <div class="drum-pad-inner">
                    <span class="material-symbols-outlined">album</span>
                </div>
                <span class="drum-pad-label">Crash</span>
            </div>

            <div id="pad-hihat" class="drum-pad pad-hihat">
                <div class="drum-pad-inner">
                    <span class="material-symbols-outlined">album</span>
                </div>
                <span class="drum-pad-label">Hi-Hat</span>
            </div>

            <div id="pad-snare" class="drum-pad pad-snare">
                <div class="drum-pad-inner">
                    <span class="material-symbols-outlined">circle</span>
                </div>
                <span class="drum-pad-label">Snare</span>
            </div>

            <div id="pad-tom" class="drum-pad pad-tom">
                <div class="drum-pad-inner">
                    <span class="material-symbols-outlined">circle</span>
                </div>
                <span class="drum-pad-label">High Tom</span>
            </div>

            <div id="pad-kick" class="drum-pad pad-kick">
                <div class="drum-pad-inner">
                    <span class="material-symbols-outlined">adjust</span>
                </div>
                <span class="drum-pad-label">Kick</span>
            </div>

            <div id="pad-floortom" class="drum-pad pad-floortom">
                <div class="drum-pad-inner">
                    <span class="material-symbols-outlined">circle</span>
                </div>
                <span class="drum-pad-label">Floor Tom</span>
            </div>

        </div>
    </div>

    <script src="<%=request.getContextPath()%>/layouts/js/drumsEngine.js" defer></script>