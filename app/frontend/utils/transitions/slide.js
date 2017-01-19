import Snabbt from 'snabbt.js'

export default {
  enter (el, done, forward = true) {
    var settings = {}

    if (forward) {
      settings = { scale: [1, 1], fromScale: [0.99, 0.99]}
    } else {
      settings = { scale: [1, 1], fromScale: [1.01, 1.01]}
    }

    Snabbt(el, {
      opacity: 1,
      fromOpacity: 0.01,
      scale: settings.scale,
      fromScale: settings.fromScale,
      easing: 'ease',
      duration: 200,
      complete() {
        done()
      },
    })
  },
  leave (el, done, forward = true) {
    var settings = {}

    if (forward) {
      settings = { scale: [1.01, 1.01], fromScale: [1, 1]}
    } else {
      settings = { scale: [0.99, 0.99], fromScale: [1, 1]}
    }

    Snabbt(el, {
      opacity: 0.01,
      fromOpacity: 1,
      scale: settings.scale,
      fromScale: settings.fromScale,
      easing: 'ease',
      duration: 200,
      complete() {
        done()
      },
    })
  },
}
