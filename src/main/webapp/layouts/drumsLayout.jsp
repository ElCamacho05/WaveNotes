<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <div class="drums-game-container"
        style="width: 100%; height: 100%; position: relative; display: flex; flex-direction: column; background: radial-gradient(circle at center, rgba(119,1,208,0.1) 0%, transparent 70%);">

        <div class="glass-panel"
            style="position: absolute; top: 32px; right: 32px; width: 320px; padding: 24px; border-radius: 16px; z-index: 20; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5);">
            <h3
                style="color: var(--secondary-fixed-dim); font-family: var(--font-headline); font-size: 20px; font-weight: 700; margin-bottom: 16px; display: flex; align-items: center; gap: 8px;">
                <span class="material-symbols-outlined">info</span> Info Práctica
            </h3>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px;">
                <div>
                    <p class="text-small text-muted" style="text-transform: uppercase;">Score</p>
                    <p style="color: #4cd6ff; font-size: 28px; font-weight: bold;" id="scoreDisplay">0</p>
                </div>
                <div>
                    <p class="text-small text-muted" style="text-transform: uppercase;">Accuracy</p>
                    <p style="color: #ffcdfa; font-size: 28px; font-weight: bold;" id="accuracyDisplay">100%</p>
                </div>
            </div>

            <div style="display: flex; gap: 12px; margin-top: 20px;">
                <button id="btnStartEngine" class="btn btn-login" style="flex: 2; padding: 12px; font-size: 14px;">Iniciar Mic</button>
                <button id="btnTestDrums" class="btn btn-login"
                    style="flex: 1; padding: 12px; background: rgba(255,255,255,0.05); border: 1px solid var(--primary); color: var(--primary); font-size: 14px;">Test</button>
            </div>
        </div>

        <div style="flex: 1; width: 100%; max-width: 1000px; margin: 0 auto; position: relative; overflow: hidden;"
            class="perspective-view">

            <canvas id="drumsHighway" class="highway-track" style="width: 100%; height: 100%; display: block;"></canvas>

            <div
                style="position: absolute; bottom: 15%; left: 0; right: 0; height: 4px; background: linear-gradient(90deg, #39ff14, #4cd6ff, #dcb8ff, #a4e6ff, #ffcdfa, #ffd500); filter: blur(2px); z-index: 10;">
            </div>
            <div
                style="position: absolute; bottom: 15%; left: 0; right: 0; height: 1px; background: white; z-index: 11; opacity: 0.5;">
            </div>
        </div>

        <div
            style="height: 160px; display: flex; justify-content: space-around; align-items: flex-end; padding-bottom: 20px; padding-left: 16px; padding-right: 16px; z-index: 20; background: linear-gradient(to top, rgba(10,10,11,0.95), transparent);">

            <div id="pad-crash" class="drum-pad"
                style="display: flex; flex-direction: column; align-items: center; gap: 8px; cursor: pointer; flex: 1;">
                <div style="width: 70px; height: 70px; border-radius: 50%; border: 4px solid rgba(57,255,20,0.4); background: rgba(57,255,20,0.1); display: flex; align-items: center; justify-content: center; box-shadow: 0 0 15px rgba(57,255,20,0.2);">
                    <span class="material-symbols-outlined" style="color: #39ff14; font-size: 32px;">album</span>
                </div>
                <span style="color: #39ff14; font-size: 11px; font-weight: bold; text-transform: uppercase;">Crash</span>
            </div>

            <div id="pad-hihat" class="drum-pad"
                style="display: flex; flex-direction: column; align-items: center; gap: 8px; cursor: pointer; flex: 1;">
                <div style="width: 70px; height: 70px; border-radius: 50%; border: 4px solid rgba(76,214,255,0.4); background: rgba(76,214,255,0.1); display: flex; align-items: center; justify-content: center; box-shadow: 0 0 15px rgba(76,214,255,0.2);">
                    <span class="material-symbols-outlined" style="color: #4cd6ff; font-size: 32px;">album</span>
                </div>
                <span style="color: #4cd6ff; font-size: 11px; font-weight: bold; text-transform: uppercase;">Hi-Hat</span>
            </div>

            <div id="pad-snare" class="drum-pad"
                style="display: flex; flex-direction: column; align-items: center; gap: 8px; cursor: pointer; flex: 1;">
                <div style="width: 80px; height: 80px; border-radius: 50%; border: 4px solid rgba(220,184,255,0.4); background: rgba(220,184,255,0.1); display: flex; align-items: center; justify-content: center; box-shadow: 0 0 15px rgba(220,184,255,0.2);">
                    <span class="material-symbols-outlined" style="color: #dcb8ff; font-size: 40px;">circle</span>
                </div>
                <span style="color: #dcb8ff; font-size: 11px; font-weight: bold; text-transform: uppercase;">Snare</span>
            </div>

            <div id="pad-tom" class="drum-pad"
                style="display: flex; flex-direction: column; align-items: center; gap: 8px; cursor: pointer; flex: 1;">
                <div style="width: 80px; height: 80px; border-radius: 50%; border: 4px solid rgba(164,230,255,0.4); background: rgba(164,230,255,0.1); display: flex; align-items: center; justify-content: center; box-shadow: 0 0 15px rgba(164,230,255,0.2);">
                    <span class="material-symbols-outlined" style="color: #a4e6ff; font-size: 40px;">circle</span>
                </div>
                <span style="color: #a4e6ff; font-size: 11px; font-weight: bold; text-transform: uppercase;">High Tom</span>
            </div>

            <div id="pad-kick" class="drum-pad"
                style="display: flex; flex-direction: column; align-items: center; gap: 8px; cursor: pointer; flex: 1;">
                <div style="width: 100px; height: 100px; border-radius: 50%; border: 4px solid rgba(255,205,250,0.4); background: rgba(255,205,250,0.1); display: flex; align-items: center; justify-content: center; box-shadow: 0 0 25px rgba(255,205,250,0.3);">
                    <span class="material-symbols-outlined" style="color: #ffcdfa; font-size: 50px; font-variation-settings: 'FILL' 1;">adjust</span>
                </div>
                <span style="color: #ffcdfa; font-size: 11px; font-weight: bold; text-transform: uppercase;">Kick</span>
            </div>

            <div id="pad-floortom" class="drum-pad"
                style="display: flex; flex-direction: column; align-items: center; gap: 8px; cursor: pointer; flex: 1;">
                <div style="width: 90px; height: 90px; border-radius: 50%; border: 4px solid rgba(255,213,0,0.4); background: rgba(255,213,0,0.1); display: flex; align-items: center; justify-content: center; box-shadow: 0 0 15px rgba(255,213,0,0.2);">
                    <span class="material-symbols-outlined" style="color: #ffd500; font-size: 45px;">circle</span>
                </div>
                <span style="color: #ffd500; font-size: 11px; font-weight: bold; text-transform: uppercase;">Floor Tom</span>
            </div>

        </div>
    </div>

    <script src="<%=request.getContextPath()%>/layouts/js/drumsEngine.js" defer></script>