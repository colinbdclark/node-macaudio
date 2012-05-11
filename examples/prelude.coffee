macaudio = require "macaudio"


class SineWave
    constructor: (frequency, sampleRate=44100, bufferSize=1024)->
        @frequency  = frequency
        @sampleRate = sampleRate
        @phase      = 0
        @phaseStep  = frequency / sampleRate
        @buffer     = new Float32Array(bufferSize)

    setFrequency: (frequency)->
        @frequency = frequency
        @phaseStep = frequency / @sampleRate

    process: ->
        for i in [0...@buffer.length]
            @buffer[i] = Math.sin(2 * Math.PI * @phase)
            @phase += @phaseStep
        @buffer


bufferSize = 1024
node = new macaudio.JavaScriptOutputNode(bufferSize)
sine = new SineWave(0, node.sampleRate, node.bufferSize)

console.log "node.sampleRate: #{node.sampleRate}"
console.log "node.channels  : #{node.channels}"
console.log "node.bufferSize: #{node.bufferSize}"

node.onaudioprocess = (e)->
    buffer = sine.process()
    amp    = 0.25

    outL = e.getChannelData(0)
    outR = e.getChannelData(1)

    for i in [0...e.bufferSize]
        outL[i] = buffer[i] * amp
        outR[i] = buffer[i] * amp


Prelude = """
C5 E5 G5 C6 E6 G5 C6 E6  C5 E5 G5 C6 E6 G5 C6 E6  C5 D5 A5 D6 F6 A5 D6 F6  C5 D5 A5 D6 F6 A5 D6 F6
B4 D5 G5 D6 F6 G5 D6 F6  B4 D5 G5 D6 F6 G5 D6 F6  C5 E5 G5 C6 E6 G5 C6 E6  C5 E5 G5 C6 E6 G5 C6 E6
C5 E5 A5 E6 A6 A5 E6 A6  C5 E5 A5 E6 A6 A5 E6 A6  C5 D5 F+5 A5 D6 F+5 A5 D6  C5 D5 F+5 A5 D6 F+5 A5 D6
B4 D5 G5 D6 G6 G5 D6 G6  B4 D5 G5 D6 G6 G5 D6 G6  B4 C5 E5 G5 C6 E5 G5 C6  B4 C5 E5 G5 C6 E5 G5 C6
A4 C5 E5 G5 C6 E5 G5 C6  A4 C5 E5 G5 C6 E5 G5 C6  D4 A4 D5 F+5 C6 D5 F+5 C6  D4 A4 D5 F+5 C6 D5 F+5 C6
G4 B4 D5 G5 B5 D5 G5 B5  G4 B4 D5 G5 B5 D5 G5 B5  G4 B-4 E5 G5 C+6 E5 G5 C+6  G4 B-4 E5 G5 C+6 E5 G5 C+6
F4 A4 D5 A5 D6 D5 A5 D6  F4 A4 D5 A5 D6 D5 A5 D6  F4 A-4 D5 F5 B5 D5 F5 B5  F4 A-4 D5 F5 B5 D5 F5 B5
E4 G4 C5 G5 C6 C5 G5 C6  E4 G4 C5 G5 C6 C5 G5 C6  E4 F4 A4 C5 F5 A4 C5 F5  E4 F4 A4 C5 F5 A4 C5 F5
D4 F4 A4 C5 F5 A4 C5 F5  D4 F4 A4 C5 F5 A4 C5 F5  G3 D4 G4 B4 F5 G4 B4 F5  G3 D4 G4 B4 F5 G4 B4 F5
C4 E4 G4 C5 E5 G4 C5 E5  C4 E4 G4 C5 E5 G4 C5 E5  C4 G4 B-4 C5 E5 B-4 C5 E5  C4 G4 B-4 C5 E5 B-4 C5 E5
F3 F4 A4 C5 E5 A4 C5 E5  F3 F4 A4 C5 E5 A4 C5 E5  F+3 C4 A4 C5 E-5 A4 C5 E-5  F+3 C4 A4 C5 E-5 A4 C5 E-5
A-3 F4 B4 C5 D5 B4 C5 D5  A-3 F4 B4 C5 D5 B4 C5 D5  G3 F4 G4 B4 D5 G4 B4 D5  G3 F4 G4 B4 D5 G4 B4 D5
G3 E4 G4 C5 E5 G4 C5 E5  G3 E4 G4 C5 E5 G4 C5 E5  G3 D4 G4 C5 F5 G4 C5 F5  G3 D4 G4 C5 F5 G4 C5 F5
G3 D4 G4 B4 F5 G4 B4 F5  G3 D4 G4 B4 F5 G4 B4 F5  G3 E-4 A4 C5 F+5 A4 C5 F+5  G3 E-4 A4 C5 F+5 A4 C5 F+5
G3 E4 G4 C5 G5 G4 C5 G5  G3 E4 G4 C5 G5 G4 C5 G5  G3 D4 G4 C5 F5 G4 C5 F5  G3 D4 G4 C5 F5 G4 C5 F5
G3 D4 G4 B4 F5 G4 B4 F5  G3 D4 G4 B4 F5 G4 B4 F5  C3 C4 G4 B-4 E5 G4 B-4 E5  C3 C4 G4 B-4 E5 G4 B-4 E5
C3 C4 F4 A4 C5 F5 C5 A4  C5 A4 F4 A4 F4 D4 F4 D4  C3 B3 G5 B5 D6 F6 D6 B5  D6 B5 G5 B5 D5 F5 E5 D5
C5 C5 C5 C5
"""

mtof = (m)->
     440 * Math.pow(Math.pow(2, (1 / 12)), m - 69)

atom = (a)->
    if (m = /^([CDEFGAB])([-+]?)([0-9]?)$/.exec(a)) != null
        x = { C:0, D:2, E:4, F:5, G:7, A:9, B:11 }[m[1]]
        x += 12 * (m[3]|0) + { "-":-1, "":0, "+":+1 }[m[2]]
    else 0

sequence = ( mtof(atom i) for i in Prelude.trim().split /\s+/ )

timerId = setInterval ->
    if sequence.length
        sine.setFrequency sequence.shift() * 2
    else
        node.stop()
        clearInterval timerId
, 180

node.start()
