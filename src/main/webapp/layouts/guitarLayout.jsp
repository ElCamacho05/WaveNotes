<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="guitar-game-container" style="width: 100%; height: 100%; position: relative;">
    
    <div style="position: absolute; top: 20px; left: 20px; z-index: 10; display: flex; gap: 20px;">
        <div class="glass-panel" style="padding: 10px 20px; font-weight: bold; color: var(--primary);">
            Score: <span id="scoreDisplay">0</span>
        </div>
        <button id="btnStartEngine" class="btn btn-login">Iniciar Micrófono y Tocar</button>
    </div>

    <canvas id="noteHighway" style="width: 100%; height: 100%; display: block;"></canvas>

    <div class="hit-zone" style="
        position: absolute; 
        bottom: 10%; 
        left: 0; 
        width: 100%; 
        height: 60px; 
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
        border-top: 2px solid var(--primary);
        border-bottom: 2px solid var(--primary);
        pointer-events: none;">
    </div>
</div>