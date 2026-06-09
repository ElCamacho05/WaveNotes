// drums layout dom
const canvas = document.getElementById('guitarHighway');
const ctx = canvas.getContext('2d');
const scoreDisplay = document.getElementById('scoreDisplay');
const accuracyDisplay = document.getElementById('accuracyDisplay');
const btnStart = document.getElementById('btnStartEngine');
const padsContainer = document.getElementById('guitar-pads-container');

// reproductor
const audio = document.getElementById('gameAudio');
const btnPlayPause = document.getElementById('btnPlayPause');
const iconPlayPause = document.getElementById('iconPlayPause');
const seekBar = document.getElementById('seek-bar');
const timeDisplay = document.getElementById('time-display');

// variables de control de juego
const ANTICIPATION = 1.5; 
let hitZoneY = 0;
let isPlaying = false;
let score = 0;
let hits = 0;
let totalProcessed = 0;

const chordColors = [
    '#4cd6ff',
    '#dcb8ff',
    '#ffcdfa',
    '#39ff14',
    '#ffd500',
    '#ff8c00',
    '#a4e6ff',
    '#ff0055'
];

// procesamiento de acordes dinamicos
const notesRaw = document.getElementById('practiceNotesRaw')?.value;
let fallingNotes = [];
let uniqueChords = [];
let chordColorMap = {};

try {
    fallingNotes = JSON.parse(notesRaw || '[]');
    fallingNotes.forEach(n => { n.hit = false; n.missed = false; });
    
    // extraccion de acordes unicos en la cancion (para no saturar el workspace)
    const chordsSet = new Set(fallingNotes.map(n => n.chord));
    uniqueChords = Array.from(chordsSet).sort();
    
    uniqueChords.forEach((chord, index) => {
        chordColorMap[chord] = chordColors[index % chordColors.length];
        
        const pad = document.createElement('div');
        pad.id = 'pad-' + chord.replace('#', 'sharp');
        pad.style.cssText = 'display: flex; flex-direction: column; align-items: center; gap: 8px; flex: 1;';
        
        const square = document.createElement('div');
        square.className = 'chord-square';
        square.style.cssText = `width: 70px; height: 50px; border-radius: 8px; border: 3px solid ${chordColorMap[chord]}; background: rgba(255,255,255,0.05); display: flex; align-items: center; justify-content: center; transition: all 0.1s ease;`;
        
        const text = document.createElement('span');
        text.style.cssText = `color: ${chordColorMap[chord]}; font-size: 20px; font-weight: bold; font-family: monospace;`;
        text.innerText = chord;
        
        square.appendChild(text);
        pad.appendChild(square);
        padsContainer.appendChild(pad);
    });

} catch (e) { console.error("Error parseando notas de guitarra"); }


// inicializacion global de mic
let audioContext = null;
let analyser = null;
let dataArray = null;
let binWidth = 21.5; 

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
    return sum / ((endBin - startBin) + 1); 
}

// iluminacion de la bateria tras un golpe, dependiendo del ID del pad
function lightUpChord(chord) {
    const pad = document.getElementById('pad-' + chord.replace('#', 'sharp'));
    if (!pad) return;
    const square = pad.querySelector('.chord-square');
    
    square.style.background = chordColorMap[chord];
    square.style.boxShadow = `0 0 30px ${chordColorMap[chord]}`;
    square.style.transform = 'scale(1.1)';
    
    setTimeout(() => {
        square.style.background = 'rgba(255,255,255,0.05)';
        square.style.boxShadow = 'none';
        square.style.transform = 'scale(1)';
    }, 150);
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

function getLaneX(chord) {
    const position = uniqueChords.indexOf(chord) + 1;
    return canvas.width * (position / (uniqueChords.length + 1));
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
        alert("Presiona 'Iniciar Mic' primero para conectar tu batería.");
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

if (btnStart) btnStart.addEventListener('click', async () => {
    const micReady = await requestMicrophone();
    if(!micReady) return;

    btnStart.style.display = 'none';
    try {
        await audio.play();
        iconPlayPause.innerText = 'pause';
        if (!isPlaying) {
            isPlaying = true;
            requestAnimationFrame(gameLoop);
        }
    } catch (e) {
        alert("Error: La cancion no parece existir en la base de datos");
        btnStart.style.display = 'block';
    }
});

// loop principal del juego
function gameLoop() {
    if (audio.paused || !isPlaying) {
        requestAnimationFrame(gameLoop);
        return; 
    }

    ctx.clearRect(0, 0, canvas.width, canvas.height);
    const currentTime = audio.currentTime;

    analyser.getByteFrequencyData(dataArray);
    
    // config
    // configuracion para deteccion de ruido metalico de bateria (igual entran otros tonos, no solo electrica)
    let e_strum = getBandEnergy(80, 5000); 
    const now = Date.now();
    let energyDelta = e_strum - previousGameEnergy;

    // config
    if (e_strum > 80 && energyDelta > 60) {
        if (now - lastGameHitTime > 150) { 
            
            // deteccion de rasgueo de guitarra
            let hitNote = null;
            for (let i = 0; i < fallingNotes.length; i++) {
                let note = fallingNotes[i];
                let timeUntilHit = note.time - currentTime;
                
                // config
                // probando con 0.25s de intervalo para el usuario
                if (!note.hit && !note.missed && Math.abs(timeUntilHit) < 0.25) { 
                    hitNote = note;
                    break;
                }
            }

            if (hitNote) {
                hitNote.hit = true;
                hits++;
                totalProcessed++;
                score += 150;
                updateStats();
                
                lightUpChord(hitNote.chord);
                
                // efecto de onda expansiva / explosion
                ctx.beginPath();
                ctx.arc(getLaneX(hitNote.chord), hitZoneY, 60, 0, Math.PI * 2);
                ctx.fillStyle = chordColorMap[hitNote.chord];
                ctx.globalAlpha = 0.5;
                ctx.fill();
                ctx.globalAlpha = 1.0;
            }
            
            lastGameHitTime = now;
        }
    }
    previousGameEnergy = e_strum;

    // renderizado de acordes en pantalla
    fallingNotes.forEach(note => {
        const timeUntilHit = note.time - currentTime;

        if (timeUntilHit < -0.25 && !note.hit && !note.missed) {
            note.missed = true;
            totalProcessed++;
            updateStats();
        }

        if (timeUntilHit <= ANTICIPATION && timeUntilHit > -0.5) {
            if (!note.hit) {
                const speed = hitZoneY / ANTICIPATION;
                const y = hitZoneY - (timeUntilHit * speed);
                const x = getLaneX(note.chord);

                // dibujar acorde
                ctx.beginPath();
                ctx.roundRect(x - 35, y - 20, 70, 40, 8);
                ctx.fillStyle = "#0e0e0f"; 
                ctx.fill();
                
                ctx.lineWidth = 3;
                ctx.strokeStyle = chordColorMap[note.chord];
                ctx.shadowBlur = 15;
                ctx.shadowColor = chordColorMap[note.chord];
                ctx.stroke();
                ctx.shadowBlur = 0; 
                
                ctx.fillStyle = "white";
                ctx.font = "bold 16px monospace";
                ctx.textAlign = "center";
                ctx.textBaseline = "middle";
                ctx.fillText(note.chord, x, y);
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