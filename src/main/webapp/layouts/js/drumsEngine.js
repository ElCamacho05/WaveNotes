// drums layout dom
const canvas = document.getElementById('drumsHighway');
const ctx = canvas.getContext('2d');
const scoreDisplay = document.getElementById('scoreDisplay');
const accuracyDisplay = document.getElementById('accuracyDisplay');
const btnStart = document.getElementById('btnStartEngine');
const btnTest = document.getElementById('btnTestDrums');

// reproductor
const audio = document.getElementById('gameAudio');
const btnPlayPause = document.getElementById('btnPlayPause');
const iconPlayPause = document.getElementById('iconPlayPause');
const seekBar = document.getElementById('seek-bar');
const timeDisplay = document.getElementById('time-display');

const visualPads = {
    0: document.getElementById('pad-kick'),
    1: document.getElementById('pad-snare'),
    2: document.getElementById('pad-hihat'),
    3: document.getElementById('pad-tom'),
    4: document.getElementById('pad-floortom'),
    5: document.getElementById('pad-crash'),
    'kick': document.getElementById('pad-kick'),
    'snare': document.getElementById('pad-snare'),
    'hihat': document.getElementById('pad-hihat'),
    'tom': document.getElementById('pad-tom'),
    'floortom': document.getElementById('pad-floortom'),
    'crash': document.getElementById('pad-crash')
};

// variables de control de juego
const ANTICIPATION = 1.5;
let hitZoneY = 0;
let isPlaying = false;
let score = 0;
let hits = 0;
let totalProcessed = 0;

const colors = {
    0: '#ffcdfa', // KICK: rosa
    1: '#dcb8ff', // SNARE: morado
    2: '#4cd6ff', // HIHAT: cyan
    3: '#a4e6ff', // HIGH TOM: azul claro
    4: '#ffd500', // FLOOR TOM: amarillo neon
    5: '#39ff14'  // CRASH: verde neon
};

const notesRaw = document.getElementById('practiceNotesRaw')?.value;
let fallingNotes = [];
try {
    fallingNotes = JSON.parse(notesRaw || '[]');
    fallingNotes.forEach(n => { n.hit = false; n.missed = false; });
} catch (e) { console.error("Error parseando notas"); }


// inicializacion global de mic
let audioContext = null;
let analyser = null;
let dataArray = null;
let binWidth = 21.5; // largo frecuencia de deteccion (se recalcula dependiendo del usuario)

async function requestMicrophone() {
    if (audioContext) return true;
    try {
        const stream = await navigator.mediaDevices.getUserMedia({ audio: true });

        audioContext = new (window.AudioContext || window.webkitAudioContext)();

        analyser = audioContext.createAnalyser();
        analyser.fftSize = 2048;
        analyser.smoothingTimeConstant = 0.1;

        const source = audioContext.createMediaStreamSource(stream);
        source.connect(analyser);
        dataArray = new Uint8Array(analyser.frequencyBinCount);

        binWidth = audioContext.sampleRate / analyser.fftSize;

        return true;
    } catch (err) {
        alert("Se requiere acceso al micrófono para jugar o calibrar.");
        return false;
    }
}

// obtener bin exacto de la frecuencia
function getBin(freq) {
    return Math.max(0, Math.min(Math.round(freq / binWidth), dataArray.length - 1));
}

// obtener el promedio de energia de una banda de frecuencias
function getBandEnergy(freqStart, freqEnd) {
    const startBin = getBin(freqStart);
    const endBin = getBin(freqEnd);
    if (startBin >= endBin) return dataArray[startBin] || 0;
    
    let sum = 0;
    for (let i = startBin; i <= endBin; i++) sum += dataArray[i];
    return sum / ((endBin - startBin) + 1); // Retorna el promedio
}

// iluminacion de la bateria tras un golpe, dependiendo del ID del pad
function lightUpDrum(drumIdOrType) {
    const pad = visualPads[drumIdOrType];
    if (!pad) return;
    
    pad.classList.add('active');
    if(drumIdOrType === 0 || drumIdOrType === 'kick') pad.classList.add('active-kick');
    if(drumIdOrType === 1 || drumIdOrType === 'snare') pad.classList.add('active-snare');
    if(drumIdOrType === 2 || drumIdOrType === 'hihat') pad.classList.add('active-hihat');
    if(drumIdOrType === 3 || drumIdOrType === 'tom') pad.classList.add('active-tom');
    if(drumIdOrType === 4 || drumIdOrType === 'floortom') pad.classList.add('active-floortom');
    if(drumIdOrType === 5 || drumIdOrType === 'crash') pad.classList.add('active-crash');
    
    setTimeout(() => {
        pad.classList.remove('active', 'active-kick', 'active-snare', 'active-hihat', 'active-tom', 'active-floortom', 'active-crash');
    }, 100);
}


// modo test, para que el usuario se acostumbre y componga cualquier cosa del instrumento
let testModeActive = false;
let lastTestHitTime = 0;
let previousTestEnergy = 0;

async function toggleTestMode() {
    if (testModeActive) {
        testModeActive = false;
        btnTest.style.background = "rgba(255,255,255,0.05)";
        btnTest.innerText = "Test";
        return;
    }

    const micReady = await requestMicrophone();
    if (!micReady) return;

    testModeActive = true;
    btnTest.style.background = "rgba(76, 214, 255, 0.2)";
    btnTest.innerHTML = "<span class='material-symbols-outlined' style='font-size:16px; vertical-align:middle;'>mic</span> Escuchando...";
    
    testLoop();
}
if (btnTest) btnTest.addEventListener('click', toggleTestMode);

function testLoop() {
    if (!testModeActive) return;

    analyser.getByteFrequencyData(dataArray);

    // multiplicadores para compensar la perdida natural de energia en agudos
    let e_kick = getBandEnergy(20, 60) * 1.0;
    let e_floor_tom = getBandEnergy(61, 120) * 1.0;
    let e_snare = getBandEnergy(121, 250) * 1.1;
    let e_high_tom = getBandEnergy(251, 1500) * 1.2;
    let e_hihat = getBandEnergy(4000, 8000) * 1.4;
    let e_crash = getBandEnergy(8001, 12000) * 1.5;

    let totalEnergy = e_kick + e_floor_tom + e_snare + e_high_tom + e_hihat + e_crash;
    let now = Date.now();
    let energyDelta = totalEnergy - previousTestEnergy;

    // delta mas permisivo (100) pero cooldown estricto (120ms)
    if (totalEnergy > 300 && energyDelta > 100) {
        if (now - lastTestHitTime > 120) {
            let energies = {
                0: e_kick, 1: e_snare, 2: e_hihat,
                3: e_high_tom, 4: e_floor_tom, 5: e_crash
            };
            let winnerStr = Object.keys(energies).reduce((a, b) => energies[a] > energies[b] ? a : b);
            let winnerDrum = parseInt(winnerStr);

            if (energies[winnerDrum] > 80) {
                let detectedDrum = winnerDrum;
                lightUpDrum(detectedDrum);
                lastTestHitTime = now;
                console.log(`[hit test] tambor: ${detectedDrum} | delta: ${energyDelta.toFixed(1)}`);
            }
        }
    }

    previousTestEnergy = totalEnergy;
    requestAnimationFrame(testLoop);
}


// modo juego de la app
let lastGameHitTime = 0;
let previousGameEnergy = 0;

function resizeCanvas() {
    canvas.width = canvas.parentElement.clientWidth;
    canvas.height = canvas.parentElement.clientHeight;
    hitZoneY = canvas.height * 0.85;
}
window.addEventListener('resize', resizeCanvas);
resizeCanvas();

// distribucion de carriles donde caen las notas
function getLaneX(drumId) {
    // izquierda extrema: Crash(5)
    // izq: HiHat(2)
    // centro-izq: Snare(1)
    // centro-der: HighTom(3)
    // der: Kick(0)
    // der extrema: FloorTom(4)
    const laneOrder = [5, 2, 1, 3, 0, 4];
    
    // Posicion del tambor (1 al 6)
    const position = laneOrder.indexOf(drumId) + 1;
    
    return canvas.width * (position / 7);
}

// controles de reproduccion
function formatTime(seconds) {
    if (isNaN(seconds)) return "0:00";
    const m = Math.floor(seconds / 60);
    const s = Math.floor(seconds % 60);
    return m + ":" + (s < 10 ? "0" : "") + s;
}

audio.addEventListener('loadedmetadata', () => { seekBar.max = audio.duration; });
audio.addEventListener('timeupdate', () => {
    seekBar.value = audio.currentTime;
    timeDisplay.innerText = formatTime(audio.currentTime);
});

seekBar.addEventListener('input', () => {
    audio.currentTime = seekBar.value;
    fallingNotes.forEach(n => {
        if (n.time > audio.currentTime) {
            n.hit = false;
            n.missed = false;
        }
    });
});

btnPlayPause.addEventListener('click', () => {
    if (!isPlaying) {
        alert("¡Presiona 'Iniciar Mic' primero para conectar tu batería!");
        return;
    }
    if (audio.paused) {
        audio.play();
        iconPlayPause.innerText = 'pause';
    } else {
        audio.pause();
        iconPlayPause.innerText = 'play_arrow';
    }
});

async function startMicEngine() {
    const micReady = await requestMicrophone();
    if(!micReady) return;

    if(testModeActive) toggleTestMode();
    btnStart.style.display = 'none';

    try {
        await audio.play();
        iconPlayPause.innerText = 'pause';
        if (!isPlaying) {
            isPlaying = true;
            requestAnimationFrame(gameLoop);
        }
    } catch (playError) {
        console.error(playError);
        alert("Asegúrate de que la canción exista en la base de datos.");
        btnStart.style.display = 'block';
    }
}
if (btnStart) btnStart.addEventListener('click', startMicEngine);


// loop principal del juego
function gameLoop() {
    if (audio.paused || !isPlaying) {
        requestAnimationFrame(gameLoop);
        return; 
    }

    ctx.clearRect(0, 0, canvas.width, canvas.height);
    const currentTime = audio.currentTime;

    // deteccion del microfono mediante fft
    let detectedDrum = -1;
    analyser.getByteFrequencyData(dataArray);
    
    // ecualizacion de frecuencias
    let e_kick = getBandEnergy(20, 60) * 1.0;
    let e_floor_tom = getBandEnergy(61, 120) * 1.0;
    let e_snare = getBandEnergy(121, 250) * 1.1;
    let e_high_tom = getBandEnergy(251, 1500) * 1.2;
    let e_hihat = getBandEnergy(4000, 8000) * 1.4;
    let e_crash = getBandEnergy(8001, 12000) * 1.5;

    let totalEnergy = e_kick + e_floor_tom + e_snare + e_high_tom + e_hihat + e_crash;
    const now = Date.now();
    let energyDelta = totalEnergy - previousGameEnergy;

    // control de impacto
    if (totalEnergy > 300 && energyDelta > 100) {
        if (now - lastGameHitTime > 120) {
            let energies = {
                0: e_kick, 1: e_snare, 2: e_hihat,
                3: e_high_tom, 4: e_floor_tom, 5: e_crash
            };
            let winnerStr = Object.keys(energies).reduce((a, b) => energies[a] > energies[b] ? a : b);
            let winnerDrum = parseInt(winnerStr);

            if (energies[winnerDrum] > 80) {
                detectedDrum = winnerDrum;
                lightUpDrum(detectedDrum);
                lastGameHitTime = now;
                console.log("[hit juego] tambor: ${detectedDrum} | delta: ${energyDelta.toFixed(1)}");
            }
        }
    }
    previousGameEnergy = totalEnergy;

    // renderizado de las notas
    fallingNotes.forEach(note => {
        const timeUntilHit = note.time - currentTime;

        if (timeUntilHit < -0.2 && !note.hit && !note.missed) {
            note.missed = true;
            totalProcessed++;
            updateStats();
        }

        // CONTROL DE ACIERTOS
        if (timeUntilHit <= ANTICIPATION && timeUntilHit > -0.5) {
            if (detectedDrum === note.targetDrum && !note.hit && !note.missed) {
                if (Math.abs(timeUntilHit) < 0.2) { // TOLERANCIA DE TIEMPO
                    note.hit = true;
                    hits++;
                    totalProcessed++;
                    score += 150;
                    updateStats();
                    
                    // generacion de brillo en canvas
                    ctx.beginPath();
                    ctx.arc(getLaneX(note.targetDrum), hitZoneY, 50, 0, Math.PI * 2);
                    ctx.fillStyle = colors[note.targetDrum];
                    ctx.globalAlpha = 0.6;
                    ctx.fill();
                    ctx.globalAlpha = 1.0;
                }
            }

            // nota cayendo
            if (!note.hit) {
                const speed = hitZoneY / ANTICIPATION;
                const y = hitZoneY - (timeUntilHit * speed);
                const x = getLaneX(note.targetDrum);

                ctx.beginPath();
                ctx.arc(x, y, 22, 0, Math.PI * 2);
                ctx.fillStyle = "#0e0e0f";
                ctx.fill();
                
                ctx.lineWidth = 4;
                ctx.strokeStyle = colors[note.targetDrum];
                ctx.shadowBlur = 20;
                ctx.shadowColor = colors[note.targetDrum];
                ctx.stroke();
                
                ctx.shadowBlur = 0;
            }
        }
    });

    requestAnimationFrame(gameLoop);
}

function updateStats() {
    if(scoreDisplay) scoreDisplay.innerText = score;
    if(accuracyDisplay && totalProcessed > 0) {
        const acc = Math.round((hits / totalProcessed) * 100);
        accuracyDisplay.innerText = acc + "%";
    }
}