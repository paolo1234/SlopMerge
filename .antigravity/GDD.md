# Game Design Document (GDD): Slop Merge

## 1. Scopo del Progetto & High Concept
L'obiettivo di **Slop Merge** è catturare l'attenzione frammentata della Generazione Z e Alpha unendo le meccaniche solide e assuefacenti di un *Merge Puzzle* (stile Suika Game) con un'estetica e un sound design ispirati ai contenuti virali "brainrot". Il gioco non deve solo intrattenere, ma deve fornire un costante *feedback sensoriale e dopaminico* (tramite juice, vibrazioni aptiche, e suoni "meme") rendendo impossibile per l'utente smettere di giocare dopo una sola partita. La monetizzazione non è forzata, ma basata su un sistema "pay-with-ads-to-survive", trasformando le pubblicità in preziosi poteri strategici.

---

## 2. Il Core Game Loop
Il flusso vitale del giocatore si divide in tre macro-stati:

1. **La Partita (Action)**: 
   - L'utente mira trascinando il dito e rilascia per **sparare** il frutto dal basso verso l'alto.
   - **Gravità Invertita**: I frutti "cadono" verso l'alto e si accumulano sul soffitto del contenitore.
   - Frutti dello stesso livello si fondono, scalando in grandezza e garantendo punti e riempiendo il **Brainrot Meter**.
   - Il giocatore utilizza poteri tattici (Laser Beam) per liberare spazio quando la pila di frutti scende troppo verso il basso.
2. **Il Game Over (Reward)**: 
   - Un frutto supera la "Linea del Cringe". 
   - Viene calcolato il punteggio finale e convertito in "Gettoni Slop".
   - Viene offerta la possibilità di moltiplicare i gettoni guadagnati guardando una Ads.
3. **Il Metagame (Progression)**: 
   - Nel Menu Principale, il giocatore spende i gettoni alla Macchinetta Gacha per sbloccare Skin tematiche (Zombie, Cyberpunk).
   - Visita il Slopdex per osservare quali frutti assurdi ha sbloccato e ammirare le "silhouette oscurate" di quelli che gli mancano (FOMO).
   - Riscuote premi per le *Daily Quests*.

---

## 3. Schermate e Interazioni dell'Utente (Flow UI/UX)

### Schermata di Avvio (Menu Principale)
- **Visuale**: Il contenitore di gioco vuoto fa da sfondo. Il Titolo "SLOP MERGE" pulsa in alto al centro.
- **Interazioni**:
  - Bottone gigante centrale **"PLAY"**.
  - Angolo in basso a sinistra: **Icona Libro** -> Apre il *Slopdex*.
  - Angolo in basso a destra: **Icona Distributore** -> Apre lo *Shop/Gacha*.
  - Icona laterale: **Quest Log** (con badge numerico rosso se ci sono ricompense da riscattare).

### Schermata In-Game (HUD)
- **Top Center**: Punteggio attuale, in font grandissimo e con animazione a "pop" ogni volta che sale.
- **Top Right (Preview)**: Il box che mostra il "Prossimo Frutto". Accanto c'è un piccolo tasto "+". Se cliccato: *"Vuoi vedere i prossimi 3 frutti per sempre? Guarda 1 Spot!"*.
- **Right Margin (Brainrot Meter)**: Una barra verticale in stile termometro. Si riempie a ogni fusione. Se brilla, il **Frullatore del Caos** è pronto all'uso.
- **Bottom Left**: Icona del telefono che trema (Shake). Mostra un contatore (es. "2/3"). Premendo un "+" vicino, propone uno Spot per 3 Shake aggiuntivi.
- **Bottom Right**: Icona del Magnete (Raggio Traente). Costa sempre 1 Spot per essere attivata.

### Schermata di Game Over
- Uno sfondo semi-trasparente nero oscura il disastro nel contenitore.
- Testo centrale: **CRINGE OVER!**
- **Scoreboard**: Punteggio attuale e Best Score.
- **Risultato Economico**: "Hai guadagnato 150 Gettoni Slop".
- **Bottoni**: 
  - Bottone gigante oro: "x3 Gettoni (Guarda Video)".
  - Bottone standard: "Rigioca".
  - Bottone standard: "Menu".

---

## 4. Meccaniche di Gioco Dettagliate

### La Fisica "Squishy"
I `RigidBody2D` non devono rimbalzare come palle da biliardo, ma come gavettoni. Questo richiede una massa che scala con il livello del frutto, attrito basso, e un sistema di "wobble" (tramite shader o tweens sullo Sprite) all'impatto.

### La Meccanica Originale: "Shoot & Bounce"
Invece di lasciar cadere i frutti verticalmente, il giocatore mira e spara i frutti nel contenitore.
- **Mira**: Trascinando il dito, si visualizza una traiettoria.
- **Lancio**: Rilasciando, il frutto viene sparato con un impulso.
- **Rimbalzi**: I frutti possono rimbalzare sui muri per raggiungere angoli difficili.

### Il Brainrot Meter e il Frullatore del Caos
Ogni volta che due frutti si fondono, generano energia. Più fusioni avvengono a catena (una fusione ne causa un'altra per caduta), più il moltiplicatore combo aumenta il riempimento.
Al 100%, l'utente tocca la barra: appare un'animazione di un frullatore al centro dello schermo che "risucchia" ed elimina istantaneamente i 3 frutti di livello più basso (tier 1 e 2), creando spazio prezioso.

### La Linea del Cringe (Condizione di Sconfitta)
Una linea tratteggiata rossa nella parte **bassa** dello schermo (vicino al lanciatore). Se la pila di frutti scende e tocca la linea per più di **3 secondi continui**, scatta il Game Over. Prima del Game Over definitivo, viene offerta la possibilità di usare un potere per pulire l'area.

---

## 5. Estetica, Audio e Game Feel (Juiciness)

- **Suoni Meme**: Ogni livello di fusione ha un effetto sonoro distinto. 
  - Livello 1-3: "Pop", "Squeak", "Boing".
  - Livello 4-7: Versi esagerati, risate AI.
  - Livello 8-11: "Vine Boom" fortissimo, screen shake intenso.
- **Feedback Aptico (Vibrazione)**: 
  - Toccare i bordi: Vibrazione impercettibile.
  - Fusione piccola: *Light Impact*.
  - Fusione enorme: *Heavy Impact* prolungato.
- **Effetti Visivi**: Esplosioni di particelle (emoji, stelle, coriandoli) che coprono brevemente lo schermo durante le fusioni per mascherare il cambio di sprite.

---

## 6. Tier dei Frutti (Draft)
1. Pisello Triste
2. Limone Arrabbiato
3. Kiwi Sospettoso
4. Mela Piangente
5. Arancia Sorridente (Maniaca)
6. Pesca Palestrata
7. Ananas Tattico
8. Melone Troll
9. Anguria Chad
10. Zucca Demoniaca
11. **Sole Cosmico (Vittoria/Punteggio Massimo)**
