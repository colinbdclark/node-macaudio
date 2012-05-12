# node-macaudio
The interface is an AudioUnit(Mac) which can generate audio directly using JavaScript.

## Requirements
- Mac OS X (AudioUnit)
- [node.js](https://github.com/joyent/node) v0.6.x

## Install
`node-macaudio` is available through npm:
```sh
$ npm install macaudio
```

## Usage
```javascript
var macaudio = require("macaudio");

var bufferSize = 1024; // 512, 1024, 2048 or 4096
var node = new macaudio.JavaScriptOutputNode(bufferSize);

console.log("sampleRate:", node.sampleRate);
console.log("channels  :", node.channels);
console.log("bufferSize:", node.bufferSize);

var phase = 0;
var phaseStep = 880 / node.sampleRate;

node.onaudioprocess = function(e) {
    var L = e.getChannelData(0);
    var R = e.getChannelData(1);
    for (var i = 0; i < e.bufferSize; i++) {
        L[i] = R[i] = Math.sin(2 * Math.PI * phase);
        phase += phaseStep;
    }
};

node.start();
setTimeout(function() { node.stop(); }, 1000);
```
